import 'package:flutter/material.dart';

class ContractBlock extends StatelessWidget {

  String image;
  ContractBlock({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(

        height: width < 500 ? 300: 500,
        width: width,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),

        ),
        child: Image.asset(image),
      ),
    );
  }
}
