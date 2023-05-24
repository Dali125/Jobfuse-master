//So, the contracts section will involve two or more users.
//This means that the users will be stored in an array
//So the order of precedence is that the first value in the array
//Will be the owner of the project, and the clients will follow
//Afterwards



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jobfuse/constant_widget/contract_image_block.dart';
import 'package:jobfuse/ui/colors/colors.dart';
import 'package:jobfuse/ui/components/ui-rands/text_guides.dart';
import 'package:jobfuse/ui/components/ui-rands/text_title.dart';
import 'package:jobfuse/ui/contracts/tabs/ongoing_contracts.dart';
import 'package:jobfuse/ui/drawer/my_drawer.dart';
import 'package:jobfuse/ui/payments_page/tabs/withdraw.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'contracts_block.dart';
class ContractsPage extends StatefulWidget {
  const ContractsPage({Key? key}) : super(key: key);

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {


  String myUserID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: AppBar(

          title: Text('Contracts'),
          centerTitle: true,
          bottom: const TabBar(

            tabs: [
              DelayedDisplay(delay: Duration(milliseconds: 200),
                child: Tab(
                  text: 'Ongoing',),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 200), child: Tab(
                text: 'Completed',),
              ),




            ],
          ),

        ),

        body:  TabBarView(
          children: [


            OngoingContracts()

          ,  Center(child: Text('Dali2'))

      ],
    ),



        drawer: MyDrawer(),
      ),
    );
  }
}

