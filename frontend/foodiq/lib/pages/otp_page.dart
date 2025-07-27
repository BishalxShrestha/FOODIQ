// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';


// class OtpPage extends StatefulWidget {
//   final String phoneNumber;
//   const OtpPage({super.key, required this.phoneNumber});

//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage>{
//   final TextEditingController otpController = TextEditingController();

//   @override
//   void dispose() {
//     otpController.dispose();
//     super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         title: const Text('Verify OTP'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             Icon(
//               Icons.fastfood,
//               size: 80,
//               color: theme.colorScheme.primary,
//             ),
//             const SizedBox(height: 24),

//             Text(
//               'Enter OTP sent to ${widget.phoneNumber}',
//               textAlign: TextAlign.center,
//               style: theme.textTheme.titleMedium,
//             ),
//             const SizedBox(height: 24),

//             // OTP Input
//             PinCodeTextField(
//                 appContext: context,
//                 length: 6,
//             controller: otpController,
//             keyboardType: TextInputType.number,
//             autoFocus: true,
//               animationType: AnimationType.fade,
//               enableActiveFill: false,
//             pinTheme: PinTheme(
//                 shape:PinCodeFieldShape.box,
//               borderRadius: BorderRadius.circular(12),
//               fieldHeight:50,
//               fieldWidth:40,
//               activeColor: theme.colorScheme.primary,
//               selectedColor: Colors.grey,
//               inactiveColor: Colors.grey.shade400,
//             ),

//             ),
//             const SizedBox(height: 24),

//             // Submit Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   String otp = otpController.text;

//                   // TODO: Add OTP verification logic here

//                   Navigator.pushReplacementNamed(context, '/home');

//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text('Verify'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }