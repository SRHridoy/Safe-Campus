import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safe_campus/screens/admin_screen.dart';
import 'package:safe_campus/screens/login_screen.dart';
import 'package:safe_campus/screens/register_screen.dart';
import 'package:safe_campus/screens/splash_screen.dart';
import 'package:safe_campus/screens/user_screen.dart';

import 'firebase_options.dart';

    void main() async{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Safe Campus',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.green[50],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/user': (context) => UserScreen(),
            '/admin': (context) => AdminScreen(),
            // Add other routes here as needed
          },
          debugShowCheckedModeBanner: false,
        );

      }
    }
