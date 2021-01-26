

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          final FormState form = formKey.currentState;
          if(form.validate()){
            final model = AddressModel(
              name: cName.text.trim(),
              state: cState.text.trim(),
              pincode: cPinCode.text,
              phoneNumber: cPhoneNumber.text,
              flatNumber: cFlatHomeNumber.text,
              city: cCity.text.trim(),
            ).toJson();
            // add to firestore
            EcommerceApp.firestore.collection(EcommerceApp.collectionUser).
          document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).
          document(DateTime.now().microsecondsSinceEpoch.toString()).setData(model).then((value){
            final snake= SnackBar(content: Text('New address added successfully '));
            scaffoldKey.currentState.showSnackBar(snake);
            FocusScope.of(context).requestFocus(FocusNode());
            formKey.currentState.reset();

            });
            Route route=MaterialPageRoute(builder: (c)=> StoreHome());
            Navigator.pushReplacement(context, route);

          }
        },
            label: Text('Done'),
        backgroundColor: Colors.pink,
        icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add new Address ', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: 'Name',
                      controller: cName,
                    ),
                    MyTextField(
                      hint: 'Phone Number',
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: 'Flat Number / House Number ',
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: 'City',
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: 'State / Country',
                      controller: cState,
                    ),
                    MyTextField(
                      hint: 'Pincode',
                      controller: cPinCode,
                    ),
                  ],
                ),)],
          ),
        ), drawer: MyDrawer(),
      ),
    );
  }
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
