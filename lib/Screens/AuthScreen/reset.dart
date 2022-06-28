import 'package:auth_app/Screens/AuthScreen/login.dart';
import 'package:flutter/material.dart';
import '../../Provider/auth_provider.dart';
import './register.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({ Key? key }) : super(key: key);

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
 final TextEditingController _email = TextEditingController();

bool isLoading = false;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset"),
      ),
      body: isLoading == false
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        AuthClass().restPassword(
                          email: _email.text.trim(),
                        )
                            .then((value) {
                          if (value == "Email sent") {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value)));
                          }
                        });
                      },
                      child: const Text("Reset account")),
                 const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text("Already have an account? Login "),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}