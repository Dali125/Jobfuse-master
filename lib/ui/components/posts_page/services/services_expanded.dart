import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/ui/message/ChosenChat.dart';

import '../../ui-rands/my_button.dart';

class EpandedServices extends StatefulWidget {
  String image;
  String userId;
  String docId;

  EpandedServices({Key? key, required this.image, required this.userId, required this.docId}) : super(key: key);

  @override
  State<EpandedServices> createState() => _EpandedServicesState();
}

class _EpandedServicesState extends State<EpandedServices> {


  String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  flexibleSpace: Container(
                    height: 250,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fitWidth,
                      height: 250,
                    ),
                  ),
                  expandedHeight: 250,
                ),
                SliverToBoxAdapter(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('freelance_services')
                        .where('document_id', isEqualTo: widget.docId)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 700,
                          width: 700,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var user = snapshot.data!.docs[index];
                              return Container(

                                child:Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                                  child: Column(

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          SizedBox(width: 40,),
                                          TextButton(onPressed: ()async{

                                            //Reference the collection
                                            CollectionReference usersCollection =
                                            FirebaseFirestore.instance.collection('users');

                                            //Query the snapshot
                                            QuerySnapshot querySnapshot = await usersCollection
                                                .where('Userid',isEqualTo: user['Userid'])
                                                .get();

                                            //Get the document data
                                            DocumentSnapshot userdata = querySnapshot.docs[0];

                                            //We wanted the user id
                                            String userId = userdata.get('Userid');
                                            String image = userdata.get('imageUrl');
                                            String name = userdata.get('First_name') +' ' + userdata.get('Last_name');




                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyChosenChat(currentUser: currentUser, otherUser: user['Userid'], chattername: name, chatterImage: image)));


                                          }, child: Text('Contact'))
                                        ],
                                      ),

                                      Text(user['title'], style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),),
                                      Text(user['description'], style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text(user['minimum_price'], style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),),



                                      MyButton(onTap: () { print('something'); }, buttonText: 'continue',)




                                    ],
                                  ),
                                )

                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
