import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:safe_campus/screens/admin_screen.dart';
import 'package:safe_campus/screens/login_screen.dart';
import 'package:safe_campus/screens/register_screen.dart';
import 'package:safe_campus/screens/sos_screen.dart';
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final storage = GetStorage();
  static const platform = MethodChannel('com.example.safe_campus/sos');
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _serviceRunning = false;
  bool _isInEmergency = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupMethodChannel();
    _initializeService();
    // Auto-enable service when app starts
    _autoEnableService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isInEmergency) {
      _isInEmergency = false;
    }
  }

  Future<void> _initializeService() async {
    try {
      final isRunning =
          await platform.invokeMethod<bool>('isServiceRunning') ?? false;
      setState(() => _serviceRunning = isRunning);
    } on PlatformException catch (e) {
      debugPrint("Service check failed: ${e.message}");
      setState(() => _serviceRunning = false);
    }
  }

  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      debugPrint("Method called: \\${call.method}");
      final userType = storage.read('userType') ?? 'user';
      switch (call.method) {
        case 'sos_trigger':
          if (!mounted || _isInEmergency || userType == 'admin') return;
          setState(() => _isInEmergency = true);
          _showEmergencyScreen();
          break;
        case 'sosTriggered':
          if (!mounted || _isInEmergency || userType == 'admin') return;
          setState(() => _isInEmergency = true);
          _showEmergencyScreen();
          break;
        case 'service_status':
          setState(() => _serviceRunning = call.arguments as bool);
          break;
      }
      return null;
    });
  }

  void _showEmergencyScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_navigatorKey.currentState != null) {
        _navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) =>  SosScreen()),
              (route) => false,
        );
      }
    });
  }

  Future<void> _autoEnableService() async {
    try {
      // Always enable service - no toggle option
      final result = await platform.invokeMethod<bool>('startService');
      setState(() => _serviceRunning = result ?? true);
    } catch (e) {
      debugPrint("Auto-enable service failed: $e");
    }
  }

  Future<void> _toggleService() async {
    // Service toggle disabled - always keep enabled
    return;
  }

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
      navigatorKey: _navigatorKey,
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
