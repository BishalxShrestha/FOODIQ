import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodiq/models/predictionResult_model.dart';
import 'package:foodiq/pages/prediction_screen.dart';
import 'package:foodiq/widgets/object_detected_display.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  File? _image;
  bool _loading = false;

  

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() => _image = File(pickedImage.path));
      _showPredictDialog(pickedImage.path);
    }
  }

  void _showPredictDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (dialogcontext) => AlertDialog(
        title: const Text("Proceed to Prediction?"),
        content: const Text("Would you like to upload and predict this image?"),
        actions: [
           TextButton(
          onPressed: () => Navigator.pop(dialogcontext),
          child: const Text("Cancel"),
        ),


          ElevatedButton(
  onPressed: () async {
     Navigator.pop(dialogcontext);

     final pickedFile = File(imagePath);
            if (!mounted) return;

    // final pickedFile = _image;
    // if (pickedFile == null) return;

    final uri = Uri.parse('http://10.0.2.2:8000/predictresult'); //emulator

    // final uri = Uri.parse("http://192.168.1.83:8000/predictresult");


    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        final result = PredictionResult.fromJson(json);


          if (!mounted) return;

        // Navigate to ObjectDetectedDisplay directly
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ObjectDetectedDisplay(
              name: result.predictedClass,
              confidence: result.confidence,
              nutritionInfo: result.nutritionInfo,
              imageBase64: result.imageBase64,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Prediction failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  },
  child: const Text("Yes, Predict"),
),





          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => PredictionScreen(imagePath: imagePath),
          //       ),
          //     );
          //   },
          //   child: const Text("Yes, Predict"),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
   

          Center(
            child: Text("FoodIQ",style: GoogleFonts.nunito(
              fontWeight: FontWeight.w900,
              fontSize: 38,
              color: Color(0xff6c9dfe)
            ),),
          ),
          const SizedBox(height: 40),

        

            Container(
      height: 335,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
   
        image: DecorationImage(
          image: AssetImage('assets/images/homec2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),

          const SizedBox(height: 30),

          // Capture from camera
          GestureDetector(
            onTap: () => pickImage(ImageSource.camera),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, size: 40, color:Color(0xff616161),),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Click Photo",
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text("Open the camera to take a picture"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
