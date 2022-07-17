import 'dart:async';

import 'package:auth_app/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({ Key? key }) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {

  String selectedCountry = "+234";

  List<String> country = [
             "+234", "+1", "+345"
  ];

 final TextEditingController _phone = TextEditingController(); 
 final TextEditingController _code = TextEditingController();

 bool showClearIcon = false;  

 String getCodeText = 'Get Code';

 String myVerificationId = "";

 bool isSending = false; 
 bool isLoading = false;

late Timer _codeTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.5)),
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [ 
                //Country Code
                DropdownButton<String>(
                  underline: Container(),
                  value: selectedCountry,
                  items: country.map((String e) {
                    return DropdownMenuItem(
                      
                      child: Text(e),
                      value: e,
                      );
                  }).toList(),
                   onChanged: (String? value) {
                      setState(() {
                        selectedCountry = value!;
                      });
                   }
                  ),
                 Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 15,
                  color: Colors.black,
                  width: 2,
                 ),

                //phone field

              Expanded(child: TextFormField(
                onChanged: (value) {
                  setState(() {
              if (value.isEmpty)  {
                showClearIcon = false;
              } else {
                showClearIcon = true;
              }
                  });
                },
                controller: _phone,
                keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Phone number'
                    ),
                   )
                 ),
             
              //Clear Icon
        showClearIcon == false
         ?  const Text('')  
         : IconButton(
          onPressed: () {
              setState(() {
                _phone.clear();
                showClearIcon = false;
              });
            }, 
            icon: const Icon(Icons.close)
               )
                ],
              ),
            ),

            //Code Field
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: 
                          Border.all(color: Colors.grey, width: 1.5),
                        ),
                        child: TextFormField(
                          controller: _code,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Verification Code"
                         ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),

                //Get Code Button
                Expanded(
                  child: GestureDetector(
                    onTap: isSending == false 
                    ? () {
                       if (_phone.text.isNotEmpty) {
                      final String number = 
                      selectedCountry + _phone.text;
                      //Verify phone
                      print(number);
                      verifyPhoneNumber(context, number); 
                      }
                    } : null,
                  
                  child: Container(
                    padding: const EdgeInsets.all(17),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: 
                      Border.all(color: Colors.grey, width: 1.5)
                    ),
                    child:  Text(
                      "$getCodeText",
                    style:  TextStyle(
                      color: isSending == false 
                      ? Colors.grey
                      : Colors.amber,
                      fontWeight: FontWeight.bold
                    ),
                      ),
                     )
                    ), 
                  ),
              ],
             ),
            ),

            //Submit Button
            GestureDetector(
              onTap: isLoading == false
              ? () {
                if(_code.text.isNotEmpty){

                  //Verify code method
                  verifySmsCode(context, _code.text.trim());
                }
              } 
              : null, 
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                color: Colors.amber,
                padding: const EdgeInsets.all(15),
                child: isLoading == false 
                ? const Text('Verify Code') 
                : const Text('Loading...')
              ),
            )

           ],
         ),
       ),
     );
   }
   void verifyPhoneNumber(BuildContext context, String phone) async {
    int duration = 60;

    _codeTimer = Timer.periodic( const Duration(seconds: 1), (Timer timer) {
          setState(() {
            isSending = true;
         if(duration < 1) {
          _codeTimer.cancel();
          isSending = false ;
          getCodeText = "Get Code";
         }else{
           duration--;
           getCodeText = "$duration s";
         }

          });
     });

     //Phone Auth 
     FirebaseAuth _auth = FirebaseAuth.instance;

     await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);

      },
      timeout: const Duration(seconds: 60),
      verificationFailed: (FirebaseException error) {
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.code)));
      },

      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          myVerificationId = verificationId;
        });
      },
     
      codeAutoRetrievalTimeout: (String verificationId ) => null,
      );
    
   }
   //verify Code
   void verifySmsCode(BuildContext context, String code) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    setState(() {
      isLoading = true;
    });

    //Create a PhoneCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: myVerificationId,
      smsCode: code 
    );

      //Sign in the user with credential
      await auth.signInWithCredential(credential);
      setState(() {
        isLoading = false;
      });

       Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);


   }
}