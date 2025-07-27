import 'dart:convert';
import 'package:foodiq/models/predictionResult_model.dart';
import 'package:http/http.dart' as http;


Future<PredictionResult?> uploadImageAndGetPrediction(String filePath) async {
  var uri = Uri.parse("http://10.0.2.2:8000/predictresult"); // Replace with your server IP

  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('file', filePath));

  var response = await request.send();

  if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final decodedJson = jsonDecode(responseData);
    return PredictionResult.fromJson(decodedJson);
  } else {
    print("Failed to get prediction: ${response.statusCode}");
    return null;
  }
}
