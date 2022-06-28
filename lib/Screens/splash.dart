import 'package:auth_app/Screens/AuthScreen/login.dart';
import 'package:auth_app/Screens/AuthScreen/register.dart';
import 'package:auth_app/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    Future.delayed( const Duration(seconds: 3), () {
      if(auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(
          context,
           MaterialPageRoute(builder: (context) => const LoginPage(),), 
           (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
          const HomePage(),), (route) => false);
      }
    }
    );
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 80,
        ),
      ),
    );
  }
}