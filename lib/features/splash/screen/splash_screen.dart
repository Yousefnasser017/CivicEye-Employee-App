
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final username = await _storage.read(key: 'username');
    if (username != null && username.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF725DFE),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo-white.png'),
          width: 120,
        ),
      ),
    );
  }
}
