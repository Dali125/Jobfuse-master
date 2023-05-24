import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfuse/ui/contracts/tabs/client_contracts.dart';
import 'package:jobfuse/ui/contracts/tabs/my_contracts.dart';

import '../../../constant_widget/contract_image_block.dart';

class OngoingContracts extends StatelessWidget {
  const OngoingContracts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          FadeInLeft(
            delay: Duration(milliseconds: 300),
            child: InkWell(child: ContractBlock(image:'assets/mobile_money_icons/card.png' ),
              onTap: (){
                Fluttertoast.showToast(msg: 'msg');
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyContracts()));
              },),
          ),
          SizedBox(height: 10,),
          FadeInLeft(
            delay: Duration(milliseconds: 400),
            child: InkWell(child: ContractBlock(image:'assets/mobile_money_icons/card.png' )
            ,onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClientContracts()));



              },

            ),
          ),

        ],
      ),
    );
  }
}
