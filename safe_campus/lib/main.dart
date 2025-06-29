import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:safe_campus/screens/admin_screen.dart';
import 'package:safe_campus/screens/login_screen.dart';
import 'package:safe_campus/screens/register_screen.dart';
import 'package:safe_campus/screens/splash_screen.dart';
import 'package:safe_campus/screens/user_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {

    final bool isLoggedIn = storage.read('isLoggedIn') ?? false;
    final String userType = storage.read('userType') ?? '';


    String initialRoute;
    if (isLoggedIn) {
      if (userType == 'admin') {
        initialRoute = '/admin';
      } else if (userType == 'user') {
        initialRoute = '/user';
      } else {
        initialRoute = '/login';
      }
    } else {
      initialRoute = '/';
    }

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
      initialRoute: initialRoute,
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/user': (context) => UserScreen(),
        '/admin': (context) => AdminScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
