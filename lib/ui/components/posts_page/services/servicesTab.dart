import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/ui/components/posts_page/services/services_expanded.dart';

class SelecteServices extends StatefulWidget {
  String category;
  String docId;



  SelecteServices({Key? key, required this.category, required this.docId}) : super(key: key);

  @override
  State<SelecteServices> createState() => _SelecteServicesState();
}




Future<void> recordVisitedResource(String serviceId, String docId) async{
  try{
    //The query to get the bwowsing history
    final querySnapshot = await FirebaseFirestore.instance.collection('browsing_history')
                         .where('document_id', isEqualTo: docId).get();

    if(querySnapshot.docs.isNotEmpty){

      //user has visited resource, nothing
    }else{


      //User has visited resource for the first time
      await FirebaseFirestore.instance.collection('browsing_history').doc(docId).set(
        {
          'user_id': FirebaseAuth.instance.currentUser!.uid.toString(),
          'service_id': serviceId,
          'document_id': docId

        }
      );

      await FirebaseFirestore.instance.collection('visitation_counter').doc(serviceId).set(
          {

           'count': FieldValue.increment(1),
            'service_id':serviceId

          });


    }
    
  }catch(e){
    
    //
  }
  
  
}

class _SelecteServicesState extends State<SelecteServices> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),

    body:  SizedBox(
      height: 500,
      width: width,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance 
            .collection('freelance_services')
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var services = snapshot.data!.docs[index];
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            width: width,
                            child: Image.network(
                              services['service_image'],
                              height: 110,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(services['description']),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => EpandedServices(image:services['service_image'], userId: services['Userid'], docId: services['document_id'],)));
                    //Store the information in the database

                    recordVisitedResource(services['document_id'], widget.docId);
                    print('object');
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 40);
              },
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    )
    );
  }
}

      