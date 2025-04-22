import 'package:daytask/services/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daytask/app/theme.dart';
import 'package:daytask/secrets/app_secrets.dart';
import 'package:daytask/services/auth_provider.dart';
import 'package:daytask/services/navigation_provider.dart';
import 'package:daytask/get_started/splash_screen.dart';

void main() async {
  await Supabase.initialize(
    url: AppSecrets.supabaseURL,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DayTask',
        theme: AppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
