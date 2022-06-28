import 'package:auth_app/Screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // InItialize flutterFire
      future: _initialization,
      builder: (context, snapshot) {
     // Check for errors
     if (snapshot.hasError) {
       return Container();
     }
     // Once complete, show your application
     if (snapshot.connectionState == ConnectionState.done) {
       return const Splash();
      }

      // Otherwise, show something whilist waiting for initialized to complete
     return const Center(
      child: CircularProgressIndicator(),
       );
      }
    ); 
  }
}
    
  
