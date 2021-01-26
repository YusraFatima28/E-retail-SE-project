import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

class TotalAmount extends ChangeNotifier{
  double _totalAmount=0;
  double get totalAmount=> _totalAmount;
  display(double no)async{
    _totalAmount=no;
    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }
}