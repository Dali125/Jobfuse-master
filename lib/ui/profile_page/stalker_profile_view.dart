import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/ui/profile_page/Services/about.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../colors/colors.dart';
import 'Services/stalker_services.dart';



class StalkerView extends StatefulWidget {

  String userId;
  StalkerView({Key? key, required this.userId}) : super(key: key);

  @override
  State<StalkerView> createState() => _StalkerViewState();
}




class _StalkerViewState extends State<StalkerView> {
  String usernameFromDb = FirebaseAuth.instance.currentUser!.email.toString();
  String myuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    String uname = usernameFromDb;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Contact'),
              )
            ],
            collapsedHeight: 150,
            stretch: true,
            shadowColor: AppColors.splashColor2,
            expandedHeight: 150,
            elevation: 8,
            scrolledUnderElevation: 8,
            flexibleSpace: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('Userid', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              //The image is defined here
                              FadeInDown(
                                child: Stack(
                                  children: [
                                    //The Profile Picture
                                    ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Ink.image(
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(data['imageUrl']),
                                          child: InkWell(
                                            onTap: () {},
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 300),
                                child: Text(
                                  '${data['First_name']}  ${data['Last_name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 300),
                                child: Text(data['UserName']),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              //The ratings bar will be placed here, and this will show what users have to say about the user and stuff
                            ],
                          ),
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
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('Userid', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DefaultTabController(
                    length: 3, // Number of tabs
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'About'),
                            Tab(text: 'Services'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                        SizedBox(
                          height: height * 2,
                          width: width,
                          child: TabBarView(
                            children: [
                              Text('About'),
                              StalkerServices(userId: widget.userId,),
                              Ratings(userID: widget.userId,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Shimmer(
                    child: Container(
                      height: height,
                      color: AppColors.splashColor2,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
