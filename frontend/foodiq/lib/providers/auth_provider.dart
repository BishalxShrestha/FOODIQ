import 'package:flutter/widgets.dart';
import 'package:foodiq/models/users_model.dart';
import 'package:foodiq/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UsersModel? _currentUser;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  UsersModel? get currentUser => _currentUser;

   Future<void> login(String username, String password) async {
    final token = await _authRepository.login(username, password);
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

   Future<void> register(UsersModel user) async {
    final success = await _authRepository.register(user);
    if (success) {
      await login(user.username, user.password);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

    Future<void> checkLoginStatus() async {
    final loggedIn = await _authRepository.isLoggedIn();
    _isAuthenticated = loggedIn;
    notifyListeners();
  }

}
