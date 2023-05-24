import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../servicesTab.dart';

class MyInterests extends StatefulWidget {
  const MyInterests({Key? key}) : super(key: key);

  @override
  State<MyInterests> createState() => _MyInterestsState();
}

class _MyInterestsState extends State<MyInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users')
          .where('Userid',isEqualTo:FirebaseAuth.instance.currentUser!.uid.toString()).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data!.docs;

              List interests = documents[0].get('interests');

              return ListView.builder(
                  itemCount: interests.length,
                  itemBuilder: (context,index){


                  return  ListTile(
                      leading: Text(interests[index], style: const TextStyle(fontSize: 16),),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: ()async{

                        //Reference the collection
                      CollectionReference usersCollection =
                      FirebaseFirestore.instance.collection('onsite_services');

                      //Query the snapshot
                      QuerySnapshot querySnapshot = await usersCollection
                          .where('title',isEqualTo: interests[index])
                          .get();

                      //Get the document data
                      DocumentSnapshot userdata = querySnapshot.docs[0];

                      //We wanted the user id
                      String docId = userdata.get('document_id');

                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelecteServices(category: interests[index],docId: docId,)));

                    },
                    );

              });
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline);
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          }),
    );
  }
}
