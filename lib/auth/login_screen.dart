import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daytask/app/custom_button.dart';
import 'package:daytask/app/custom_text_field.dart';
import 'package:daytask/services/auth_provider.dart';
import 'package:daytask/services/navigation_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(child: Image.asset('assets/app_logo.png', width: 150)),
                SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text('Email Address', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  prefixIconPath: 'assets/usertag.png',
                ),
                SizedBox(height: 10),
                Text('Password', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  prefixIconPath: 'assets/passwordtag.png',
                  obscureText: true,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password?', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 15),
                auth.isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                      onTap: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          // Show error
                          return;
                        }

                        try {
                          await auth.login(email, password, context);
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      text: 'Log In',
                    ),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        context.read<NavigationProvider>().navigateToSignUp(
                          context,
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
