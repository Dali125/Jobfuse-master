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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),

                  ),
    body:Center(child: Text('hsrh'),)
    );
  }
}

      