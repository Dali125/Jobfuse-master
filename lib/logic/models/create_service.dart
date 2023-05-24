import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class FreelanceService{

 String taskType;
 String category;
 String amount;
 final String serviceTitle;
  final String description;
  final String serviceImage;


  FreelanceService( { required this.taskType,
    required this.category,
    required this.amount,
    required this.serviceTitle,
    required this.description,
    required this.serviceImage,
  });
  
  
  
  
  Future<void> createService()async{

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


    String newDocID = getRandomString(20);
    
    await FirebaseFirestore.instance.collection('freelance_services').doc(newDocID).set(
        {
          'TaskType': taskType,
          'Userid': FirebaseAuth.instance.currentUser!.uid.toString(),
          'category': category,
          'description':description,
          'document_id': newDocID,
          'minimum_price':amount,
          'service_image':serviceImage,
          'title': serviceTitle

        }).whenComplete(() => Fluttertoast.showToast(msg: 'Service Successfully Created').onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString())));
    
  }
}