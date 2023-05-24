import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/constant_widget/popular_services%20card.dart';
import 'package:jobfuse/ui/components/posts_page/recommended_posts.dart';
import 'package:jobfuse/ui/components/posts_page/services/all_services.dart';
import 'package:jobfuse/ui/components/posts_page/services/servicesTab.dart';
import 'package:jobfuse/ui/components/posts_page/tabs/Search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import '../../../constant_widget/card.dart';
import '../../colors/colors.dart';

class InitialHome extends StatefulWidget {
  const InitialHome({Key? key}) : super(key: key);

  @override
  State<InitialHome> createState() => _InitialHomeState();
}

class _InitialHomeState extends State<InitialHome> {

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void servicesEvent(String serviceName) async {
    await _analytics.logEvent(
      name: 'event_choosen',
      parameters: {
        'button_id': 'popular_services',
        'page_name': 'initial_home',
        'service_name':serviceName
      },
    );
  }


  void trackEvent() {
    _analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_id': 'submit_button',
        'page_name': 'home_screen',
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.notification.request();Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,


      //The main thingy
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 30,),
              //The searchbar goes here
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(

                        border: Border.all(

                            color: AppColors.splashColor2
                        )
                    ),
                    height: 50,
                    child: Material(
                      elevation: 10,
                      shadowColor: AppColors.splashColor2,
                      child:
                      Row(children: const [SizedBox(width: 10,),Icon(Icons.search_outlined, size: 40,),SizedBox(width: 30,), Text('Search')],)
                    ),
                  ),onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchJobs()));
                  if (kDebugMode) {
                    print('0');
                  }
                },
                ),
              ),
              const SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  FadeInLeft(delay: const Duration(microseconds: 300),child: const Text('Explore Popular Services', style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  
                  FadeInRight(
                      delay: const Duration(microseconds: 400),
                    child: TextButton( onPressed: () {

                      Navigator.push(context,MaterialPageRoute(builder: (context) => const AllServices()));
                    }, child: Text('See All', style: TextStyle(color: AppColors.splashColor2)),),
                  )
                ],
              ),
              const SizedBox(height: 10,),

              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: SizedBox(
                  height: 220,
                  width: width,
                  child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('services').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context,index){

                                  var services = snapshot.data!.docs[index];
                                  return Material(
                                    elevation: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(child: PopularService(imageUrl: services['image'],category: services['category'],),
                                        onTap: (){

                                          print(services['image']);
                                          print(services['category']);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelecteServices(category: services['category'], docId: services['document_id'])));
                                          servicesEvent(services['category']);
                                        },),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(services['category']),
                                        )
                                      ],
                                    ),
                                  );


                                }, separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(width: 15,);
                            },);


                          } else if (snapshot.hasError) {

                            return const Icon(Icons.error_outline);
                          } else {

                            return SizedBox(
                              height: 220,
                              width: width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                  itemCount: 4,
                                  itemBuilder: (context , index){
                                    return Shimmer(
                                        color: Colors.grey.shade500,
                                        child: const SizedBox(
                                      height: 220,
                                      width: 220,

                                    ));
                                  })
                            );
                          }
                        })),
              ),
              

              const SizedBox(height: 30,),

              FadeInLeft(
                  delay: const Duration(milliseconds: 600),
                child: InkWell(child: const MyCard(),
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendedPosts()));
                  },
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Recently viewed and more', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                  Text('See All')
                ],
              ),




            ],
          ),
        ),
      ),
    );
  }
}
