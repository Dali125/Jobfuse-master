import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelecteServices extends StatefulWidget {
  String category;

  SelecteServices({Key? key, required this.category}) : super(key: key);

  @override
  State<SelecteServices> createState() => _SelecteServicesState();
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

      