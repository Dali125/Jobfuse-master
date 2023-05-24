import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfuse/logic/models/submit_proposal.dart';
import 'package:jobfuse/ui/colors/colors.dart';
import 'package:jobfuse/ui/components/posts_page/post_edit.dart';
import 'package:jobfuse/ui/components/posts_page/posts.dart';
import 'package:jobfuse/ui/components/ui-rands/alert_diaog.dart';
import 'package:jobfuse/ui/components/ui-rands/my_button.dart';
import 'package:jobfuse/ui/components/ui-rands/text_guides.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';

import '../../../logic/edit_post.dart';
import '../home/home.dart';


//Function to view a post
class SelectedPost extends StatefulWidget {

  String experienceLevel;
  String clientId;
  String description;
  String title;
  String budget;
  String duration;
  String documentId;
  String category;
  String taskType;
  SelectedPost({Key? key,required this.experienceLevel, required this.description, required this.title
  ,required this.budget, required this.clientId, required this.duration, required this.documentId, required this.category, required this.taskType
  }) : super(key: key);

  @override
  State<SelectedPost> createState() => _SelectedPostState();
}

class _SelectedPostState extends State<SelectedPost> {


  //Current User/Freelance ID
  String myId = FirebaseAuth.instance.currentUser!.uid.toString();

  //The Controller of the remarks , which we shall post in the proposal
  final remarksController = TextEditingController();

   @override
   Widget build(BuildContext context) {


    //Width of Screen
    double width = MediaQuery.of(context).size.width;

    //Height of Screen
    double height = MediaQuery.of(context).size.height;
    print(height.toString());
    print({height-150}.toString());
    return

      Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Job Details     ',style: TextStyle(fontSize: 30),)),
            backgroundColor: AppColors.logColor,
          ),

          body:



              //Getting Post from Database
                SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').where('Userid', isEqualTo: widget.clientId).snapshots(),
                      builder: (context, snapshot){

                        if(snapshot.hasData){

                          var data = snapshot.data?.docs.toList();

                          print(data?[0].get('UserName'));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: width,
                                  height: height - 180,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height:
                                        10,),

                                        FadeInUp(
                                            delay: const Duration(milliseconds: 300),
                                            child: Text('Posted by :  ${data?[0].get('UserName')}',style: const TextStyle(fontSize: 20),)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FadeInUp(
                                            delay: const Duration(milliseconds: 350),
                                            child: Divider()),
                                        FadeInUp(
                                          delay: const Duration(milliseconds: 400),
                                          child: Center(
                                            child: Text(widget.title,style: const TextStyle(
                                                fontSize: 27,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                        ),
                                        FadeInUp(
                                            delay: const Duration(milliseconds: 450),
                                            child: Divider()),

                                        const SizedBox(height: 10,),


                                        FadeInUp(
                                          delay: const Duration(milliseconds: 500),
                                          child: Text('Client Description',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26
                                          ),),
                                        ),
                                        const SizedBox(height: 10,),


                                        FadeInUp(
                                          delay: const Duration(milliseconds: 600),
                                          child: Text(widget.description, style: const TextStyle(
                                          ),),
                                        ),
                                        FadeInUp(
                                            delay: const Duration(milliseconds: 650),
                                            child: Divider()),

                                        const SizedBox(height: 10,),
                                        FadeInUp(
                                            delay: const Duration(milliseconds: 700),
                                            child: TextGuide(fontSize: 20, text: 'Estimated Project Duration', padding: 1)),

                                        FadeInUp(
                                            delay: const Duration(milliseconds: 800),
                                            child: Text(widget.duration)),

                                        FadeInLeft(
                                            delay: const Duration(milliseconds: 850),
                                            child: Divider()),

                                        const SizedBox(height: 10,),
                                        FadeInUp(

                                            delay: Duration(milliseconds: 900),
                                            child: TextGuide(fontSize: 20, text: 'Task Type', padding: 1)),

                                        FadeInUp(
                                            delay: Duration(milliseconds: 1000),
                                            child: Text(widget.taskType)),

                                        FadeInLeft(
                                            delay: const Duration(milliseconds: 1050),
                                            child: Divider()),

                                        const SizedBox(height: 10,),
                                        FadeInUp(
                                            delay: Duration(milliseconds: 1100),
                                            child: TextGuide(fontSize: 20, text: 'Experience Level', padding: 1)),

                                        FadeInUp(
                                            delay: Duration(milliseconds: 1200),
                                            child: BounceInUp(child: Text(widget.experienceLevel))),

                                        const SizedBox(height: 10,),
                                        FadeInUp(
                                            delay: Duration(milliseconds: 1300),
                                            child: const Text('Estimated Budget', style: TextStyle(fontSize: 20),)),

                                        FadeInUp(
                                            delay: Duration(milliseconds: 1400),
                                            child: Text(widget.budget.toString()))




                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //For the Button to apply
                              BounceInUp(
                                child: Expanded(
                                    flex: 1,
                                    child: widget.clientId == myId ? Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          MyButton(onTap: (){


                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostEdit(
                                              experienceLevel: widget.experienceLevel,
                                              description: widget.description,
                                              title: widget.title,
                                              budget: widget.budget,
                                              clientId: widget.clientId,
                                              duration: widget.duration,
                                              projectID: widget.documentId


                                            )));

                                          }, buttonText: 'Edit Post'),
                                          const SizedBox(width: 15,),
                                          //To Delete a post
                                          MyButton(onTap: (){

                                            print('tapped to delete');
                                           EditPost editpost = EditPost(budget: widget.budget,
                                               description: widget.description,
                                               documentId: widget.documentId,
                                               duration: widget.duration,
                                               experiencelevel: widget.experienceLevel,
                                               title: widget.title);

                                            editpost.deletePost();


                                            Fluttertoast.showToast(msg: 'Operation Successful', gravity: ToastGravity.BOTTOM);


                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));



                                          }, buttonText: 'Delete Post')
                                        ],
                                      ),
                                    ) :
                                    MyButton(onTap: (){



                                      try{
                                        showDialog<void>(
                                              context: context,
                                              barrierDismissible: true,
                                              // false = user must tap button, true = tap outside dialog
                                              builder: (BuildContext dialogContext) {
                                                return SingleChildScrollView(
                                                  child: AlertDialog(
                                                    title: const Text('Enter a remark, on why you should take the job '),
                                                    content: TextField(
                                                      controller: remarksController,

                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('Submit'),
                                                        onPressed: () {

                                                          ProposalSubmission psub = ProposalSubmission(remarksController.text.trim(),widget.clientId, myId, widget.documentId);

                                                          psub.submitProposal();
                                                          Navigator.of(dialogContext)
                                                              .pop();
                                                          Fluttertoast.showToast(msg: 'Operation Successful');// Dismiss alert dialog
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                           // ProposalSubmission psub = ProposalSubmission(widget.clientId, myId, widget.documentId);

                                        //psub.submitProposal();

                                        Fluttertoast.showToast(msg: 'Successfully Applied for job');

                                      }catch (e){


                                        return Fluttertoast.showToast(msg: 'Operation failed');
                                      }




                                    }, buttonText: 'Apply')
                                ),
                              )

                            ],
                          );



                        }else{


                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }


                      }
                    ),
                  ),
                ),

        );
  }
}
