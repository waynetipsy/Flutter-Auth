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
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [ 
                //Country Code
                DropdownButton<String>(
                  value: selectedCountry,
                  items: country.map((String e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                      );
                  }).toList(),
                   onChanged: (String? value) {
                    print(value);
                   }
                  )

                ],
              ),
            )
           ],
        ),
      ),
    );
  }
}