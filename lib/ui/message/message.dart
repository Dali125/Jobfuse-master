import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfuse/ui/drawer/my_drawer.dart';


import '../colors/colors.dart';
import 'choosechat.dart';
class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages'),
      centerTitle: true,),

      body: const CustomScrollView(

        slivers: [

          SliverToBoxAdapter(child: ChooseChat(),)
        ],




      ),

        drawer: MyDrawer(),
    );
  }
}
