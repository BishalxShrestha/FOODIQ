import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ObjectDetectedDisplay extends StatelessWidget {
  final String name;
  final double confidence;
  final String nutritionInfo;
  final String imageBase64;

  const ObjectDetectedDisplay({
    super.key,
    required this.name,
    required this.confidence,
    required this.nutritionInfo,
    required this.imageBase64,
  });

  @override
  Widget build(BuildContext context) {
    const orangeColor = Colors.deepOrange;
    const greenColor = Colors.green;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                
               
                ),
                child: const Center(
                  child: Text(
                    "Image Detection Result",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildInfoRow(Icons.label, "Name", name, Colors.blue),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.check_circle_outline, "Confidence", "${confidence.toStringAsFixed(2)}%", orangeColor),
              const SizedBox(height: 20),

              Text(
                "Detected Image:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color:Color(0xFF6c9dfe),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color:Color(0xFF6c9dfe), width: 2),
                  
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    base64Decode(imageBase64),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // Text(
              //   "Nutritional Info:",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w700,
              //     color: greenColor,
              //   ),
              // ),
              const SizedBox(height: 8),
              Text(
                nutritionInfo,
                style:GoogleFonts.poppins(fontSize: 16, height: 1.5,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
