import 'package:provider/provider.dart';

class UsersModel {
  // final String id;
  final String username;
  final String password;
  final String email;
  final String phone_number;
  final String firstname;
  final String lastname;

  UsersModel({
    // required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.phone_number,
    required this.firstname,
    required this.lastname,

  });

  //Create a user object from Json(Map)
  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      // id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      phone_number: json['phone_number'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,

    );
  }

  //convert a person object to Json(Map)
  Map<String, dynamic> toJSON() {
    return { 
      // 'id':id, 
      'username':username,
      'password':password,
      'email':email,
      'phone_number': phone_number,
      'firstname': firstname,
      'lastname': lastname,


    };
  }
}
