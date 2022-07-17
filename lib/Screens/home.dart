import 'package:auth_app/Provider/auth_provider.dart';
import 'package:auth_app/Screens/AuthScreen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? user =  FirebaseAuth.instance.currentUser!.email == null 
  ? FirebaseAuth.instance.currentUser!.phoneNumber 
  : FirebaseAuth.instance.currentUser!.email;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            onPressed: () {
              AuthClass().signOut();
           Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
          const LoginPage()), (route) => false);
            },
            icon: const Icon(Icons.exit_to_app), 
          
          ),
        ],
      ),
      body:  Center(
        child: Text("Email $user"),
      ),
    );
  }
}