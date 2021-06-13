import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';

class ChangePassword extends StatefulWidget {
  //final FirebaseUser fuser;
  //const ChangePassword(this.fuser);*/
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  FirebaseUser firebaseUser;
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController newPasswordTextEditingController =
      TextEditingController();
  final TextEditingController repeatPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
        backgroundColor: AppColors.primaryWhiteSmoke,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
    child : newAppBar() ),
    drawer: CollapsingNavigationDrawer(),


      body : SingleChildScrollView(
          child: Container(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
        SizedBox(
          height: 30,
        ),Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    //fontFamily: "Signatra",
                  ),
                ),
        SizedBox(height: 10,),
        Form(
          key: formkey,
          child: Column(children: [
            CustomTextField(

         /* decoration: new InputDecoration(
          border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.teal)),*/
              controller: emailTextEditingController,
              data: Icons.person,
              hintText: 'Email',
              isObsecure: false,
            ),
            CustomTextField(
              controller: passwordTextEditingController,
              data: Icons.email,
              hintText: 'Password',
              isObsecure: false,
            ),
            CustomTextField(
              controller: newPasswordTextEditingController,
              data: Icons.lock_open,
              hintText: 'New Password',
              isObsecure: true,
            ),
            CustomTextField(
              controller: repeatPasswordTextEditingController,
              data: Icons.lock_open,
              hintText: 'Confirm New Password',
              isObsecure: true,
            ),
          ]),
        ),
                RaisedButton(
                  onPressed: () {
                    print(EcommerceApp.user);
                    print(' pssss ');
                    savePassword();
                  },
                  color: AppColors.primary,
                  child: Text('Save Password', style: TextStyle(color: Colors.white)),
                ), SizedBox(height: 30,),
                Container(
                  height: 4,
                  width: screenwidth * 0.8, color: AppColors.primary,
                ), SizedBox(height: 15,),
      ]))),
    ));
  }
 /* FirebaseAuth auth = FirebaseAuth.instance;
  void loginuser()async{
    showDialog(context: context,builder: (c){return LoadingAlertDialog(message: 'Authentication please wait.....');});
    FirebaseUser firebaseUser;
    await auth.signInWithEmailAndPassword(email: emailTextEditingController.text.trim(),
        password: passTextEditingController.text.trim()).then((authUser){
      firebaseUser=authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if (firebaseUser !=null){
      readdata(firebaseUser).then((s){
        Navigator.pop(context);
        Route route=MaterialPageRoute(builder: (c)=> StoreHome1());
        Navigator.pushReplacement(context, route);

      }); }}*/
  displaydialog(String msg){
    showDialog(context: context,builder: (c){ return ErrorAlertDialog(message: msg);
    });
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> saveUpdatedUserInfoToFirestore(FirebaseUser firebaseUser)async {
    print( firebaseUser.uid);
    print( 'ui dd ');

    //firebaseUser=auth.user;
    Firestore.instance.collection('users').document(firebaseUser.uid).updateData( {'password' : newPasswordTextEditingController.text.trim() });
   /* setData({
      'password': newPasswordTextEditingController.text.trim()
    });*/
    //await EcommerceApp.sharedPreferences.setString('uid',firebaseUser.uid);
    //await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,firebaseUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userPassword, newPasswordTextEditingController.text);

  }
  Future<void> savePassword() async {
    FirebaseUser firebaseUser;
    await auth.signInWithEmailAndPassword(email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()).then((authUser){
      firebaseUser=authUser.user; }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
      newPasswordTextEditingController.text == repeatPasswordTextEditingController.text ?
      emailTextEditingController.text.isNotEmpty &&
          passwordTextEditingController.text.isNotEmpty  ? saveUpdatedUserInfoToFirestore(firebaseUser).then((value){
        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
          Route route=MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.push(context, route); });
        })

          : displaydialog('please fill the complete form')
          : displaydialog('passwords do not match');
    }
  }

