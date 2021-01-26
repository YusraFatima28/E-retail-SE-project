
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

class AddressChanger extends ChangeNotifier{
  int _counter=0;
  int get count => _counter;
  displayResult(int v){
    _counter=v;
    notifyListeners();

  }

}