import 'package:e_shop/Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';


class WideButton extends StatelessWidget {
  final String message;
  final Function onPressed;
  WideButton({
    Key key,this.message,this.onPressed,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(color: AppColors.primary, ),
            width: MediaQuery.of(context).size.width*0.85,
            height: 50.0,
            child: Center(
              child: Text(message, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            ),
          ),
        ),
      ),
    );
  }
}
