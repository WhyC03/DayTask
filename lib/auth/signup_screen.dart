import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daytask/app/custom_button.dart';
import 'package:daytask/app/custom_text_field.dart';
import 'package:daytask/services/auth_provider.dart';
import 'package:daytask/services/navigation_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
                  'Create Your Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text('Full Name', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                CustomTextField(
                  controller: nameController,
                  prefixIconPath: 'assets/user.png',
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
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                          log('Checked');
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'I have read & agreed to DayTask ',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              'Privacy Policy.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                auth.isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                      onTap:
                          isChecked
                              ? () async {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();
                                final fullName = nameController.text.trim();

                                if (email.isEmpty ||
                                    password.isEmpty ||
                                    fullName.isEmpty) {
                                  return;
                                }

                                try {
                                  await auth.signUp(email, password, fullName, context);
                                } catch (e) {
                                  log(e.toString());
                                }
                              }
                              : () {},
                      text: 'Sign Up',
                    ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        context.read<NavigationProvider>().navigateToLogin(
                          context,
                        );
                      },
                      child: Text(
                        'Log In',
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
