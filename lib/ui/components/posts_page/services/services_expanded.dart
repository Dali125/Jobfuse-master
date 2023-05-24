import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
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

                                child:Column(

                                  children: [

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
