import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:foodiq/models/predictionResult_model.dart';
import 'package:foodiq/widgets/home_content.dart';
import 'package:foodiq/widgets/object_detected_display.dart';
import 'package:foodiq/widgets/upload_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectIndex = 0;
  PredictionResult? predictionResult;

  final GlobalKey<CurvedNavigationBarState> _bottomNavKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _confirmLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8589e4),
              ),
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void handlePrediction(PredictionResult result) {
    setState(() {
      predictionResult = result;
      selectIndex = 1;
    });
  }

  Future<void> _pickFromGalleryAndPredict() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final File imageFile = File(pickedImage.path);
    final uri = Uri.parse('http://10.0.2.2:8000/predictresult'); //emulator

    // final uri = Uri.parse('http://192.168.1.83:8000/predictresult');

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        final result = PredictionResult.fromJson(json);
        handlePrediction(result);
      } else {
        _showError("Prediction failed: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomeContent(),
      // UploadImage(onResult: handlePrediction),
      predictionResult != null
          ? ObjectDetectedDisplay(
            name: predictionResult!.predictedClass,
            confidence: predictionResult!.confidence,
            nutritionInfo: predictionResult!.nutritionInfo,
            imageBase64: predictionResult!.imageBase64,
          )
          : const Center(child: Text("No prediction yet")),

      // const SizedBox()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: pages[selectIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavKey,
        index: selectIndex,
        height: 60.0,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF6C9DFE),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        items: <Widget>[
          const Icon(Icons.home, size: 30, color: Colors.white),
          const Icon(Icons.bar_chart, size: 30, color: Colors.white),
          IconButton(
            onPressed: () => _confirmLogoutDialog(context),
            icon: const Icon(Icons.logout, size: 30, color: Colors.white),
          ),
        ],
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, right: 8.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF6C9DFE),
            shape: const CircleBorder(),
            onPressed: _pickFromGalleryAndPredict,
            child: const Icon(Icons.add, size: 36, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:foodiq/models/predictionResult_model.dart';
// import 'package:foodiq/widgets/home_content.dart';
// import 'package:foodiq/widgets/object_detected_display.dart';
// import 'package:foodiq/widgets/upload_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int selectIndex = 0;
//   PredictionResult? predictionResult;

//   final GlobalKey<CurvedNavigationBarState> _bottomNavKey = GlobalKey();

//   Future<void> logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   void _confirmLogoutDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
        
//         content: Text("Are you sure you want to logout?",style: GoogleFonts.poppins(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),),
//         actions: [
//           TextButton(
//             child: const Text("Cancel"),
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Color(0xff8589e4)),
//             child: const Text("Logout"),
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog first
//               logout(context); 
//             },
//           ),
//         ],
//       );
//     },
//   );
// }


//   void handlePrediction(PredictionResult result) {
//     setState(() {
//       predictionResult = result;
//       selectIndex = 2;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pages = [
//       const HomeContent(),
//       UploadImage(onResult: handlePrediction),
//       predictionResult != null
//           ? ObjectDetectedDisplay(
//             name: predictionResult!.predictedClass,
//             confidence: predictionResult!.confidence,
//             nutritionInfo: predictionResult!.nutritionInfo,
//             imageBase64: predictionResult!.imageBase64,
//           )
//           : const Center(child: Text("No prediction yet")),
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBody: true, 
   
//       body: pages[selectIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavKey,
//         index: selectIndex,
//         height: 60.0,
//         backgroundColor: Colors.transparent,
//         // color: Colors.green,
//         color: Color(0xFF6C9DFE),

//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 500),
//         items: <Widget>[
//           const Icon(Icons.home, size: 30, color: Colors.white),
          
//           const Icon(Icons.bar_chart, size: 30, color: Colors.white),
         
//           IconButton(
//             onPressed: () {
//               _confirmLogoutDialog(context);
//             },
//             icon: const Icon(Icons.logout,size: 30, color: Colors.white),
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             selectIndex = index;
//           });
//         },
//       ),


//           floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 15.0, right: 8.0),
//         child: SizedBox(
//            height: 70,
//            width: 70,
//           child: FloatingActionButton(
//             backgroundColor: const Color(0xFF6C9DFE),
//              shape: const CircleBorder(),
//             onPressed: () {
//               setState(() {
//                 selectIndex = 1; // Navigate to upload page
//               });
//             },
//             child: const Icon(Icons.add, size: 36,color: Colors.white),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
