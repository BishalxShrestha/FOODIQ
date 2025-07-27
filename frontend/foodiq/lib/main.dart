import 'package:flutter/material.dart';
import 'package:foodiq/pages/splash_screen.dart';
import 'package:foodiq/pages/welcome_page.dart';
import 'package:foodiq/providers/auth_provider.dart';
import 'package:foodiq/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:foodiq/pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) =>ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AuthProvider()..checkLoginStatus(),)
      ],
      child: MaterialApp(
      theme: themeProvider.themeData,
        title: 'FOOD IQ',
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login':(context)=> LoginPage(),
          '/register':(context)=> RegisterPage(),
          '/welcome':(context)=> WelcomePage(),
          '/home':(context) => HomePage(),
        },
      
      
      ),
    );
  }
}


