import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/ui/profile_page/Services/services.dart';
import 'package:jobfuse/ui/profile_page/Services/services_add.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../colors/colors.dart';



class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  String usernameFromDb = FirebaseAuth.instance.currentUser!.email.toString();
  String myuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    String uname = usernameFromDb;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('Userid', isEqualTo: myuid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                List interests = data['interests'];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          child: const Text('Profile', style: TextStyle(fontSize: 35)),
                        ),
                      ),
                      Center(
                        child: FadeInDown(
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    height: 128,
                                    width: 128,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data['imageUrl']),
                                    child: InkWell(
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Positioned(
                                      right: 4,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.splashColor2,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: Text(
                            '${data['First_name']}  ${data['Last_name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: Text(data['UserName']),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FadeInLeft(
                              delay: const Duration(milliseconds: 450),
                              child: const Text(
                                'About',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInLeft(child: const Divider()),
                      width < 600
                          ? Text(
                        data['about'],
                        style: const TextStyle(fontSize: 20),
                      )
                          : Row(
                        children: [
                          FadeInLeft(
                            delay: const Duration(milliseconds: 500),
                            child: Text(
                              data['about'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      FadeInLeft(
                        delay: const Duration(milliseconds: 450),
                        child: const Text(
                          'My Skills and Interests',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GridView.builder(

                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: interests.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3
                      )
                          , itemBuilder: (context, index){


                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            elevation: 10,
                            child: SizedBox(
                                height: 10,
                                width: 70,
                                child: Center(child: Text(interests[index]))),
                          ),
                        );




                          }),

                      FadeInLeft(child: const Divider()),
                      SizedBox(
                        height: 40,
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FadeInLeft(
                              delay: const Duration(milliseconds: 450),
                              child: const Text(
                                'My Services',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FadeInRight(child: TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ServicesAdd()));


                            },
                            child: Text('Add Service')))
                          ],
                        ),
                      ),
                      MyServices(),

                    ],
                  ),
                );
              },
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
      )








          );




  }
}
