import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';

class WishListItemCounter extends ChangeNotifier{
  int counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userWishList).length-1;
  int get count => counter;
  Future<void> displayResult()async{
    int counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userWishList).length-1;
    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }
}