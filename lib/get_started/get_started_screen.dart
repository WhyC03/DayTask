import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daytask/app/custom_button.dart';
import 'package:daytask/services/navigation_provider.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Image.asset('assets/app_logo.png', width: 100),
              SizedBox(height: 30),
              Container(
                height: 320,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                color: Colors.white,
                child: Image.asset('assets/image-1.png'),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Your Task with',
                    maxLines: 3,
                    style: TextStyle(fontSize: size.height*0.055, color: Colors.white),
                  ),
                  Text(
                    'DayTask',
                    style: TextStyle(
                      fontSize: 45,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                onTap: () {
                  context.read<NavigationProvider>().navigateToLogin(context);
                },
                text: 'Let\'s Start',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
