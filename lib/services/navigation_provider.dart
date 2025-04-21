import 'package:flutter/material.dart';
import 'package:daytask/auth/login_screen.dart';
import 'package:daytask/auth/signup_screen.dart';
import 'package:daytask/get_started/get_started_screen.dart';
import 'package:daytask/home/home_screen.dart';

class NavigationProvider with ChangeNotifier {
  void navigateTogetStarted(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GetStartedScreen()),
    );
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void navigateTohome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}
