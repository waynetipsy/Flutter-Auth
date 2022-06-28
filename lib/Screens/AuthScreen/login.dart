import 'package:auth_app/Provider/auth_provider.dart';
import 'package:auth_app/Screens/AuthScreen/reset.dart';
import 'package:auth_app/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 final TextEditingController _email = TextEditingController();
 final TextEditingController _password = TextEditingController();
bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: isLoading == false ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height:10),

            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          FlatButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              AuthClass().signIN(email: _email.text.trim(),
               password: _password.text.trim()).then((value) {
             if(value == "Welcome") {
              setState(() {
                isLoading = false;
              });

              Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
          const HomePage(),), (route) => false);
             }
             else {
            setState(() {
              isLoading = false;
            });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value),));
             }
               });
            }, 
            color: Colors.blue,
          child: const Text("Login account"),
           ),
          const  SizedBox(height: 20,),
           GestureDetector(
            onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));   
            },
          child: const Text("Don't have an account? Register"),
           ),

           const SizedBox(height: 10,),
          GestureDetector(
            child: const Text('Forgot Password? reset'),
            onTap: (() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPage()));
                }
              ),
             ),
           const  SizedBox(height: 10,
           ),

           //Social Auth Button
           Column(
            children: [
              GestureDetector(
                onTap: () {
          AuthClass().signInWithGoogle().then((UserCredential value) {
          final displayName = value.user?.displayName;

          print(displayName);

          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const HomePage()), (route) => false); 
             });
           },
            child: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(10),
        child: const Text("Continue with Google"),
            ),
              ),
          const SizedBox(height: 10,
          ),
          GestureDetector(
            onTap: () {
       AuthClass().signInWithFacebook().then((value) {
         Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
       }); 
            },
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(10),
            child: const Text('Continue with facebook'),
          ),
          )
            ],
           )
          
          ],
        ),
      ): const Center(child:  CircularProgressIndicator(),)
    );
  }
}