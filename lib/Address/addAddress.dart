
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/MyLocation.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'address.dart';
class AddAddress extends StatelessWidget {
  //final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  //final cCity = TextEditingController();
  //final cState = TextEditingController();
  final cPinCode = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _autoValidate = true;

  @override
  Widget build(BuildContext context) {
    print(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) );
    //cFlatHomeNumber==
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: newAppBar(),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          final FormState form = formkey.currentState;
          if(form.validate()){

              print(' yahan p zara kro');
              final model = AddressModel(
              name: cName.text.trim(),
              //state: cState.text.trim(),
              pinCode: cPinCode.text.trim(),
              phoneNumber: cPhoneNumber.text.trim(),
              homeAddress: cFlatHomeNumber.text.trim(),
              //city: cCity.text.trim(),
            ).toJson();
            // add to firestore
            EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
            document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).
            document(DateTime.now().microsecondsSinceEpoch.toString()).setData(model).then((value){
              final snake= SnackBar(content: Text('New address added successfully '));
              scaffoldKey.currentState.showSnackBar(snake);
              FocusScope.of(context).requestFocus(FocusNode());
              formkey.currentState.reset();
            });
            Route route=MaterialPageRoute(builder: (c)=> Address());
            Navigator.pushReplacement(context, route);} },
       /*     final model = AddressModel(
              name: cName.text.trim(),
              //state: cState.text.trim(),
              pinCode: cPinCode.text.trim(),
              phoneNumber: cPhoneNumber.text.trim(),
              homeAddress: cFlatHomeNumber.text.trim(),
              //city: cCity.text.trim(),
            ).toJson();
            // add to firestore
            EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
            document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).
            document(DateTime.now().microsecondsSinceEpoch.toString()).setData(model).then((value){
              final snake= SnackBar(content: Text('New address added successfully '));
              scaffoldKey.currentState.showSnackBar(snake);
              FocusScope.of(context).requestFocus(FocusNode());
              formkey.currentState.reset();
            });
            Route route=MaterialPageRoute(builder: (c)=> Address());
            Navigator.pushReplacement(context, route);*/


            label: Text('Done'),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child : Container(
            color: Colors.white,
            //AppColors.dashPurple,
          child: Column(
            children: [
              Image.asset('images/address1.PNG', height: 230 ,width: MediaQuery.of(context).size.width,),
              SizedBox( height: 35 ,),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add new Address ', style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox( height: 20,),
              Form(
                key: formkey,
                autovalidate: _autoValidate,
                child: (Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: cName,
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
//focusColor: Colors.white,
                            border: OutlineInputBorder(
                                gapPadding: 9,
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            labelText: 'Name'),
                        keyboardType: TextInputType.name,
                        validator: (String value) {
                          return value.isEmpty ? 'Name cannot be empty' : null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller:cPhoneNumber,// phonenumberTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      TextFormField(
                        controller: cFlatHomeNumber,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.home_outlined),
                          labelText: 'Address ',
                        ),
                        keyboardType: TextInputType.streetAddress,
                        validator: (String value) {
                          return value.isEmpty ? 'Address cannot be empty' : null;
                        },
                      ),),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      TextFormField(
                        controller: cPinCode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.push_pin),
                          labelText: 'PinCode ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          return value.isEmpty ? 'PinCode cannot be empty' : null;
                        },
                        //validator: validateMobile,
                      ),),
                    SizedBox(
                      height: 30.0,
                    ),

                  ],
                )),
              ),
            ],
          ),),
        ), drawer: CollapsingNavigationDrawer(),
      ),
    );
  }
}
String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value) && value.length != 11) {
    return 'Please enter valid mobile number of 11 digits';
  }
  return null;
}
class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({
    Key key, this.hint, this.controller,}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=> val.isEmpty ? "Field can not be empty ": null ,
      ),
    );
  }
}
