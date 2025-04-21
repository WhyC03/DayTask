// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daytask/services/auth_provider.dart';
import 'package:daytask/services/navigation_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait for a short duration to simulate loading
    await Future.delayed(const Duration(seconds: 2));

    if (authProvider.isLoggedIn) {
      context.read<NavigationProvider>().navigateTohome(context);
    } else {
      context.read<NavigationProvider>().navigateTogetStarted(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset('assets/app_logo.png')));
  }
}
