import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ZAMTEL extends StatelessWidget {
  ZAMTEL({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void pay({required int amount, required String number}) async {
      String url =
          'https://api.flutterwave.com/v3/charges?type=mobile_money_zambia';

      var headers = {
        'Authorization':
            'Bearer FLWSECK_TEST-091904fbc6c28d2cf25c06448569de9a-X',
        'content-type': 'application/json',
      };
      var data = jsonEncode({
        "phone_number": number,
        "amount": amount,
        "currency": "ZMW",
        "network": "MTN",
        "email": FirebaseAuth.instance.currentUser?.email.toString(),
        "tx_ref": "MC-3243e"
      });

      try {
        var response =
            await http.post(Uri.parse(url), headers: headers, body: data);
        if (response.statusCode == 200) {
          // Payment request was successful
          // Process the response here
          var responseData = jsonDecode(response.body);
          print(responseData);
          print(responseData['message']);
          // Open the web view
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => WebView(
          //       initialUrl: responseData['meta']['authorization']['redirect'],
          //       javascriptMode: JavascriptMode.unrestricted,
          //     ),
          //   ),
          // );

          // Handle the responseData accordingly
        } else {
          // Payment request failed
          // Handle the error response here
          print(
              'Payment request failed with status code: ${response.statusCode}');
          print('Error response: ${response.body}');
        }
      } catch (error) {
        // Exception occurred during the payment request
        // Handle the error here
        print('Error occurred: $error');
      }
    }

    return ScaffoldGradientBackground(
      gradient: LinearGradient(
          tileMode: TileMode.repeated,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white]),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FadeIn(
              delay: const Duration(milliseconds: 400),
              child: Container(
                  height: 250,
                  child: Center(
                      child: Image.asset(
                          'assets/mobile_money_icons/ZamtelMoney.png')))),
          MTNInput(
            controller: phoneNumber,
            title: 'Phone Number',
            inputType: TextInputType.phone,
            validator: (value1) {
              if (value1.isEmpty) {
                return 'Please enter an amount';
              }

              final phoneNumberRegex = r'^096[0-9]{7}$';
              final regex = RegExp(phoneNumberRegex);
              if (!regex.hasMatch(value1)) {
                return 'Please enter a valid MTN phone number';
              }
              return null;
            },
          ),
          MTNInput(
            title: 'Amount',
            inputType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a value';
              }
            },
            controller: amount,
          ),
          MTNButton(onTap: () {
            print('object');
          })
        ]),
      ),
    );
  }
}

Widget MTNInput(
    {required String title,
    required TextEditingController controller,
    required TextInputType inputType,
    required var validator}) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 25, color: Colors.green),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.green),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    ),
  );
}

Widget MTNButton({var onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
