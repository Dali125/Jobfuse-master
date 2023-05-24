import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../servicesTab.dart';

class AllServicesOffered extends StatefulWidget {
  const AllServicesOffered({Key? key}) : super(key: key);

  @override
  State<AllServicesOffered> createState() => _AllServicesOfferedState();
}

class _AllServicesOfferedState extends State<AllServicesOffered> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [

          Text('Hi'),


          Container(
            height: height,
            width: width,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('onsite_services').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {


                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                      var data = snapshot.data!.docs[index];

                      return Column(
                        children: [
                          ListTile(
                            leading: Text(data['title'], style: TextStyle(fontSize: 16),),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelecteServices(category: data['title'],docId: data['document_id'],)));
                            },
                          ),
                          Divider()
                        ],
                      );


                    });
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error_outline);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          )
        ],
      ),
    );
  }
}
