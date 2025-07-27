class PredictionResult {
  final String predictedClass;
  final double confidence;
  final String nutritionInfo;
  final String imageBase64;

  PredictionResult({
    required this.predictedClass,
    required this.confidence,
    required this.nutritionInfo,
    required this.imageBase64,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json['class_'],
      confidence: (json['confidence'] as num).toDouble(),
      nutritionInfo: json['nutrition_info'] ?? '',
      imageBase64: json['image'],
    );
  }
}
