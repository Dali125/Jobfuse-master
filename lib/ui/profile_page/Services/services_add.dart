import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobfuse/logic/models/create_service.dart';
import 'package:jobfuse/ui/components/ui-rands/mt_textfield.dart';
import 'package:jobfuse/ui/components/ui-rands/my_button.dart';

import '../../../logic/models/register_model.dart';
import '../../colors/colors.dart';
import 'dart:io';
import '../../components/ui-rands/text_guides.dart';




class ServicesAdd extends StatefulWidget {
  const ServicesAdd({Key? key}) : super(key: key);

  @override
  State<ServicesAdd> createState() => _ServicesAddState();
}

class _ServicesAddState extends State<ServicesAdd> {
  int activeStep = 0;
  int upperBound = 6;
  double changers = 18;
  double unchangers = 18;





  final _formKey = GlobalKey<FormState>();


  //Is it an offsite,or an onsite
  String name = '';
  //Choose somehow how it is
  String category = '';

  TextEditingController amount = TextEditingController();

  //Describing the task that yo
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();

  bool isPosted = false;

  File? _image;
  void _getImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }


  void _getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }



  void _submitForm() async {

    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const CupertinoAlertDialog(
            title: Text('Processing'),
            content:  SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please wait...'),
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()), // add a progress indicator
                ],
              ),
            ),
          );
        }
    );
    if (_image != null) {

      // Upload the image to Firebase Storage and get the download URL
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('freelance_service_banner_pictures')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      await uploadTask;
      final imageUrl = await storageRef.getDownloadURL();

      FreelanceService servicesAdd = FreelanceService(
          taskType: name,
          category: category
          , amount: amount.text.toString(),
          serviceTitle: title.text.toString(),
          description: description.text.toString(),
          serviceImage: imageUrl


      );
      servicesAdd.createService();






      setState(() {
        isPosted = true;
      });

      Fluttertoast.showToast(msg: 'Registration Successful', gravity: ToastGravity.BOTTOM);




      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);


    }
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: const Text('Create a Service'),
      ),

      body: Container(
        child: Form(
          key:_formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(


            children: [

              NumberStepper(
                activeStepBorderColor: AppColors.splashColor,
                activeStepColor: AppColors.logColor,
                numbers: const [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                ],

                // activeStep property set to activeStep variable defined above.
                activeStep: activeStep,

                // This ensures step-tapping updates the activeStep.
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),

              Expanded(
                  child: stepWidgets()

              ),
            ],

          ),
        ),
      ),

    );
  }
  Widget stepWidgets(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    switch(activeStep){

      case 1:
        return SingleChildScrollView(
          child: Column(
            children: [

              name == 'Offsite' ? SingleChildScrollView(
    child:

                     SizedBox(height: height,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('onsite_categories').snapshots(),
                                   builder: (context, snapshot) {
                                     if (snapshot.hasData) {
                                      return
                                        ListView.builder(
                                           itemCount: snapshot.data?.docs.length,
                                             itemBuilder: (context, index){

                                             var onsiteData = snapshot.data?.docs[index];

                                           return  FadeInUp(
                                               child: ListTile(
                                                  title: Text(onsiteData?['title']),
                                                  subtitle: Text(onsiteData?['subtitle']),
                                                   trailing: const Icon(Icons.arrow_forward_ios),
                                                    onTap: (){
                                                     setState(() {
                                                        category = onsiteData?['title'];
                                                        activeStep = activeStep + 1;
                                                           });
                                                         },
                                                       ),
                                                     );

                                                  });
                                       } else if (snapshot.hasError) {
                                               return const Icon(Icons.error_outline);
                                       } else {
                                       return const CircularProgressIndicator();
                                   }
    }),
    )


    )

                  :

              //The onsite stuff will be displayed here
              SingleChildScrollView(
                  child:

                  SizedBox(height: height,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('offsite_categories').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return
                              ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index){

                                    var onsiteData = snapshot.data?.docs[index];

                                    return  FadeInUp(
                                      child: ListTile(
                                        title: Text(onsiteData?['title']),
                                        subtitle: Text(onsiteData?['subtitle']),
                                        trailing: const Icon(Icons.arrow_forward_ios),
                                        onTap: (){
                                          setState(() {
                                            category = onsiteData?['title'];
                                            activeStep = activeStep + 1;
                                          });
                                        },
                                      ),
                                    );

                                  });
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error_outline);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  )


              ),




            ],
          ),
        );
//The budget goes here

//Expeience Level goes here
      case 2:
        return SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),

                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: FadeInUp(child: TextGuide(text:'Make your service stand out', fontSize: 22, padding: 1,)),
                  ),
                ),
                const SizedBox(height: 15,),

                Center(child: TextGuide(fontSize: 18, text: 'Choose a Banner image', padding: 1)),

                Center(
                  child: FadeInDown(child: _image != null ?
                  Material(
                    child: Container(
                        height: 300,
                        width: width,
                        child: Image.file(_image!)),
                  ) : Image.network('https://www.freeiconspng.com/img/23485')

                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      MyButton(onTap: (){

                        _getImageFromGallery();

                      }, buttonText: 'From Gallery'
                      ),

                      MyButton(onTap: (){


                        _getImageFromCamera();
                      }, buttonText: 'Camera'
                      )

                    ],
                  ),
                ),




                const SizedBox(height: 80,),


                MyButton(onTap: (){

                  if (activeStep < upperBound) {
                    setState(() {
                      activeStep++;
                    });
                  }

                }, buttonText: 'Continue'),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        );

    //Project Duration
      case 3:
        return Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),

              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: FadeInUp(child: TextGuide(text:'Name your price', fontSize: 22, padding: 1,)),
                ),
              ),
              const SizedBox(height: 15,),
              FadeInUp(
                  delay: const Duration(milliseconds: 250),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: FadeInUp(
                        delay: const Duration(milliseconds: 250),
                        child: TextGuide(text:'Amount', fontSize: 20, padding: 1,)),
                  )),
              const SizedBox(height: 10,),

              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: MyTextField(controller: amount, hintText: 'Amount', obscureText: false,keyboardType: TextInputType.number,)),


                ],
              )),




              MyButton(onTap: (){

                if (activeStep < upperBound) {
                  setState(() {
                    activeStep++;
                  });
                }

              }, buttonText: 'Continue'),
              const SizedBox(height: 20,)
            ],
          ),
        );




    //post summary
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            TextGuide(fontSize: 20, text: 'Describe your Service', padding: 20),
            const SizedBox(height: 20,),

            TextGuide(fontSize: 18, text: 'Description', padding: 20),
            MyTextField(controller: description, hintText: 'e.g I will install bulbs', obscureText: false, maxLines: null,),
            const SizedBox(height: 20,),
            TextGuide(fontSize: 18, text: 'Title', padding: 20),
            Expanded(child: MyTextField(controller: title, hintText: 'Your service, in summary', obscureText: false)),
            MyButton(onTap: (){


              if (activeStep < upperBound) {
                setState(() {
                  activeStep++;
                });
              }


            }, buttonText: 'Continue')
          ],);


    //post summary
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: TextGuide(fontSize: 30, text: 'Finalize', padding: 15)),



            Center(
              child: FadeInDown(
                  delay: const Duration(milliseconds: 250),
                  child:  CircleAvatar(
                      radius: 60,
                      child: Image.file(_image!))


              ),
            ),
            FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: ListTile(leading:  Text('Service Title', style: TextStyle(fontSize:unchangers, fontWeight: FontWeight.normal),),trailing: Text(title.text.toString(), style: TextStyle(fontSize: changers, fontWeight: FontWeight.bold),))),
            FadeInUp(
                delay: const Duration(milliseconds: 350),
                child: ListTile(leading:  Text('TaskType', style: TextStyle(fontSize: unchangers),),trailing: Text(name, style: TextStyle(fontSize: changers, fontWeight: FontWeight.bold),),)),
            FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: ListTile(leading:  Text('Category', style: TextStyle(fontSize: unchangers),),trailing: Text(category, style: TextStyle(fontSize: changers, fontWeight: FontWeight.bold),),)),
            FadeInUp(
                delay: const Duration(milliseconds: 450),
                child: ListTile(leading:  Text('Amount', style: TextStyle(fontSize: unchangers),),trailing: Text ('from ${amount.text.toString()}', style: TextStyle(fontSize: changers, fontWeight: FontWeight.bold),),)),





            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: MyButton(onTap: (){

                _submitForm();


              }, buttonText: 'Create Service'),
            )
          ],);



    //What to show when selecting the task type
      default:
        return Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [

            const Padding(
              padding: EdgeInsets.only(left:10.0),
              child: Text('What service are you offering? Select an option below'),
            ),
            ListTile(
              title: const Text('OnSite'),
              subtitle: const Text('You prefer to do physical work'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: (){
                setState(() {
                  name = 'Onsite';
                  activeStep = activeStep + 1;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Offsite'),
              subtitle: const Text('Service is offered  remotely'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: (){

                setState(() {
                  name = 'Offsite';
                  activeStep = activeStep + 1;
                });
              },


            ),



          ],

        );



    }


  }
}
