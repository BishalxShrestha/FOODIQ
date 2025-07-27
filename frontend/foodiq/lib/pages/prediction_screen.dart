import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodiq/models/predictionResult_model.dart';
import 'package:foodiq/services/api_services.dart';

class PredictionScreen extends StatefulWidget {
  final String imagePath;

  const PredictionScreen({required this.imagePath});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  PredictionResult? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    uploadImageAndGetPrediction(widget.imagePath).then((result) {
      setState(() {
        _result = result;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction Result")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _result == null
              ? Center(child: Text("Failed to get result"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Prediction: ${_result!.predictedClass}", style: TextStyle(fontSize: 22)),
                      Text("Confidence: ${_result!.confidence.toStringAsFixed(2)}%", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 16),
                      Image.memory(base64Decode(_result!.imageBase64), height: 300),
                      SizedBox(height: 16),
                      Text("Nutrition Info:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_result!.nutritionInfo),
                    ],
                  ),
                ),
    );
  }
}
