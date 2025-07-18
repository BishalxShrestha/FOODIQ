from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import HTMLResponse, JSONResponse
import tensorflow as tf
import altair as alt
import uvicorn
from utils import load_and_prep, get_classes
import pandas as pd
from starlette.middleware.trustedhost import TrustedHostMiddleware
import base64
import json
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from auth.config import engine 
import auth.tables.users as user_table
import auth.routes.users as user_routes




class PredictionResponse(BaseModel):
    class_: str  # "class" is reserved in Python, so use "class_"
    confidence: float
    nutrition_info: Optional[str]
    image: str 

user_table.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Add CORS middleware to allow requests from any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add TrustedHostMiddleware to allow requests from localhost
app.add_middleware(TrustedHostMiddleware, allowed_hosts=["*"])

# Load and prepare model
model = tf.keras.models.load_model("./models/EfficientNetB1.hdf5")
class_names = get_classes()

# Load nutrition data 

nutrition_data = pd.read_csv('nutrition.csv')

# Define functions for nutrition and recommendation retrieval
def retrieve_nutrition_values(food_category):
    food_category_processed = food_category.lower().replace("-", "").replace("_", "").replace(" ", "")
    nutrition_values = nutrition_data[nutrition_data['product_name'].str.lower().str.replace("-", "").str.replace("_", "").str.replace(" ", "") == food_category_processed]
    return nutrition_values if not nutrition_values.empty else None


# Define a function for image prediction
def predicting(image, model):
    image = load_and_prep(image)
    image = tf.cast(tf.expand_dims(image, axis=0), tf.int16)
    preds = model.predict(image)
    pred_class = class_names[tf.argmax(preds[0])]
    pred_conf = tf.reduce_max(preds[0])
    top_5_i = sorted((preds.argsort())[0][-5:][::-1])
    values = preds[0][top_5_i] * 100
    labels = [class_names[top_5_i[x]] for x in range(5)]
    df = pd.DataFrame({
        "Top 5 Predictions": labels,
        "F1 Scores": values,
        'color': ['#EC5953', '#EC5953', '#EC5953', '#EC5953', '#EC5953']
    })
    df = df.sort_values('F1 Scores')
    return pred_class, pred_conf, df

# Define the home route
@app.get("/", response_class=HTMLResponse)
async def home():
    return """
    <html>
    <head>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        text-align: center;
    }
    h1 {
        color: #007bff;
        font-size: 40px;
    }
    h2 {
        color: #666;
    }
    #container {
        margin: 10em auto;
        padding: 10px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        width: 30%;
    }
    form input[type="file"] {
        display: block;
        margin: 20px auto;
        padding: 1em;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #f9f9f9;
        cursor: pointer;
    }
    form input[type="submit"] {
        margin-top: 10px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 5px;
        padding: 1em 1em;
        font-size: 18px;
        cursor: pointer;
    }
    </style>
    </head>
    <body>
    <div id="container">
    <h1>Food IQ</h1>
    <h3>Exposing what’s really on your plate!</h3>
    
    <form action="/predict" enctype="multipart/form-data" method="post">
        <input type="file" name="file">
        <input type="submit" value="Predict">
    </form>
    </div>
    </body>
    </html>
    """

# Define the prediction route
@app.post("/predict", response_class=HTMLResponse)
async def predict(file: UploadFile = File(...)):
    image = await file.read()
    pred_class, pred_conf, df = predicting(image, model)
    
    # Convert the image data to Base64
    image_base64 = base64.b64encode(image).decode('utf-8')
    
    chart = alt.Chart(df).mark_bar().encode(
        x='F1 Scores',
        y=alt.X('Top 5 Predictions', sort=None),
        color=alt.Color("color", scale=None),
        text='F1 Scores'
    ).properties(width=600, height=400)
    chart_html = chart.to_html()
    
    nutrition_values = retrieve_nutrition_values(pred_class)
    nutrition_table = ""
    if nutrition_values is not None and not nutrition_values.empty:
        nutrition_table += "<h3>Nutrition Values:</h3>"
        nutrition_table += "<table>"
        nutrition_table += "<tr><th>Product Name</th><th>Energy</th><th>Carbohydrates</th><th>Sugars</th><th>Proteins</th><th>Fat</th><th>Fiber</th><th>Cholesterol</th></tr>"
        for index, row in nutrition_values.iterrows():
            nutrition_table += "<tr>"
            nutrition_table += f"<td>{row['product_name']}</td>"
            nutrition_table += f"<td>{row['energy_100g']} kJ</td>"
            nutrition_table += f"<td>{row['carbohydrates_100g']} g</td>"
            nutrition_table += f"<td>{row['sugars_100g']} g</td>"
            nutrition_table += f"<td>{row['proteins_100g']} g</td>"
            nutrition_table += f"<td>{row['fat_100g']} g</td>"
            nutrition_table += f"<td>{row['fiber_100g']} g</td>"
            nutrition_table += f"<td>{row['cholesterol_100g']} mg</td>"
            nutrition_table += "</tr>"
        nutrition_table += "</table>"
    
            
    return HTMLResponse(content=f"""
    <html>
    <head>
    <style>
    body {{
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        text-align: center;
    }}

    h2 {{
        color: #007bff;
    }}
    img {{
        margin-top: 1em;
        border: 1px solid #ccc;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }}
    .container{{
        margin-top: 1em;
        display: flex;
        justify-content: space-between;
    }}

    </style>
    </head>
    <body>
    <div >
    <h2>Prediction: {pred_class}</h2>
    <p>Confidence: {pred_conf*100:.2f}%</p>
    <img src="data:image/jpeg;base64,{image_base64}" alt="Uploaded Image" width="400">
    </div>
    <div class="container">
    <div> {chart_html} </div>
    <div> {nutrition_table} </div>
    </div>

    </body>
    </html>
    """)

# Define a route to return prediction results as JSON
@app.post("/predictresult", response_model=PredictionResponse)
async def predictresult(file: UploadFile = File(...)):
    image = await file.read()

    # Predict
    pred_class, pred_conf, df = predicting(image, model)
    
    nutrition_values = retrieve_nutrition_values(pred_class)
    nutrition_info = ""
    if nutrition_values is not None and not nutrition_values.empty:
        nutrition_info += "Nutrition Values:\n"
        nutrition_info += f"Product Name: {nutrition_values['product_name'].iloc[0]}\n"
        nutrition_info += f"Energy: {nutrition_values['energy_100g'].iloc[0]} kJ\n"
        nutrition_info += f"Carbohydrates: {nutrition_values['carbohydrates_100g'].iloc[0]} g\n"
        nutrition_info += f"Sugars: {nutrition_values['sugars_100g'].iloc[0]} g\n"
        nutrition_info += f"Proteins: {nutrition_values['proteins_100g'].iloc[0]} g\n"
        nutrition_info += f"Fat: {nutrition_values['fat_100g'].iloc[0]} g\n"
        nutrition_info += f"Fiber: {nutrition_values['fiber_100g'].iloc[0]} g\n"
        nutrition_info += f"Cholesterol: {nutrition_values['cholesterol_100g'].iloc[0]} mg\n"
    
    
    combined_info = f"{nutrition_info}"

     # Encode image in Base64
    image_base64 = base64.b64encode(image).decode('utf-8')

    # return {
    #     'class': pred_class,
    #     'confidence': float(pred_conf * 100),
    #     'nutrition_info': combined_info
    # }

     # Return JSON
    return PredictionResponse(
        class_=pred_class,
        confidence=float(pred_conf * 100),
        nutrition_info=nutrition_info,
        image=image_base64
    )
app.include_router(user_routes.router)


if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=8000)
