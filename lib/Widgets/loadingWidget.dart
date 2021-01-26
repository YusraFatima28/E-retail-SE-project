import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:12.0),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),
  );
}
linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:12.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amberAccent),),
  );
}
