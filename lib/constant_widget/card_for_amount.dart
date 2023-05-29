import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {




  String myId = FirebaseAuth.instance.currentUser!.uid.toString();
  //Reference the collection

  String balance = '';
  getBalance() async{


    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('wallet');

    //Query the snapshot
    QuerySnapshot querySnapshot = await usersCollection
        .where('Userid',isEqualTo: myId)
        .get();

    //Get the document data
    DocumentSnapshot userdata = querySnapshot.docs[0];

    //We wanted the user id
    String docId = userdata.get('balance').toString();

    setState(() {

      balance = docId.toString();

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();


  }

  @override
  Widget build(BuildContext context) {





    print( balance);

    double width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      child: Container(

          height: 250,
          width: width,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(

            children: [


              FadeInImage.assetNetwork(placeholder: 'assets/lottie/explore.jpeg',

                image: 'https://firebasestorage.googleapis.com/v0/b/detail-crud.appspot.com/o/popular_services%2Fexplore.jpeg?alt=media&token=acd16f5a-8e44-4554-9c1e-b1bbee3a4f19',fit: BoxFit.fitWidth,width: width,)



              ,

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.bottomRight,child: Text(

                    'Balance: ${balance}',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25)),),
              )
            ],
          )
      ),
    );
  }
}
