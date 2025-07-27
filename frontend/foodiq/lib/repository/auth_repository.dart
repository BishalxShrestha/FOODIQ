import 'dart:convert';
import 'package:foodiq/models/users_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  // static String baseUrl = 'http://127.0.0.1:8000';
  static String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator

  //  static String baseUrl = 'http://192.168.1.83:8000'; 


  //user login
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['code'] == '200') {
        final token = data['result']['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
        return token;
      } else {
        print("Login failed: ${data['message']}");
        return null;
      }
    } else {
       print("HTTP error: ${response.statusCode}");
      return null;
    }
  }

  //user registration
  Future<bool> register(UsersModel user) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJSON()),
    );
    print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
  }

  //check login status
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }

  //Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  //Get stored token
   Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}

