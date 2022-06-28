import 'package:auth_app/Screens/AuthScreen/login.dart';
import 'package:auth_app/Screens/AuthScreen/reset.dart';
import 'package:flutter/material.dart';

import '../../Provider/auth_provider.dart';
import '../home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
 final TextEditingController _email = TextEditingController();
 final TextEditingController _password = TextEditingController();

 bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
              AuthClass().createAccount(email: _email.text.trim(),
               password: _password.text.trim()).then((value) {
             if(value == "Account Created") {
              setState(() {
                isLoading = false;
               }
              );

              Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
          const HomePage(),), (route) => false);
             }
             else {
            setState(() {
              isLoading = false;
             }
            );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value),));
                }
               }
             );
            }, 
            color: Colors.blue,
          child: const Text("Create account"),
           ),
          const  SizedBox(height: 20,),
           GestureDetector(
            onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));   
            },
          child: const Text('Already have an account? Login'),
             ),
           ],
         ),
       ): const Center(
        child: CircularProgressIndicator()),
    );
  }
}