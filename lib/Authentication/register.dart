import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Colors.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final TextEditingController fullnameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passTextEditingController = TextEditingController();
  final TextEditingController phonenumberTextEditingController = TextEditingController();
  final TextEditingController confirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File imageFile;
  final _formKey = GlobalKey<FormState>();
  // variable to enable auto validating of theform
  bool _autoValidate = true;
  // variable to enable toggling between showing and hiding password
  bool _hidePassword = true;

  Future<void> pickimage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenheight = MediaQuery
        .of(context)
        .size
        .height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox( height: 20,),
            InkWell(
              onTap: pickimage,
              child: CircleAvatar(
                  radius: screenwidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: imageFile == null ? null : FileImage(
                      imageFile),
                  child: imageFile == null ? Icon(
                      Icons.person_add, size: screenwidth * 0.15,
                      color: Colors.grey)
                      : null
              ),
            ),
            SizedBox(height: 20,),
            Form(
              key: formkey,
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      TextFormField(
                        controller: fullnameTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Full Name',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          return value.isEmpty ? 'Name cannot be empty' : null;
                        },
                      ),),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      TextFormField(
                        controller: phonenumberTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                      ),),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: emailTextEditingController,
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
//focusColor: Colors.white,
                            border: OutlineInputBorder(
                                gapPadding: 9,
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: passTextEditingController,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                                color: AppColors.primary,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 9,
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                        validator: (String value) {
                          return value.length < 8
                              ? 'Password must be more than 8 characters'
                              : null;
                        },
                      ),
                    ),
                   SizedBox(height: 30,),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: confirmPasswordTextEditingController,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 9,
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Confirm Password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                        validator: (String value) {
                          return value != passTextEditingController.text
                              ? ' Passwords must match! '
                          //'Password must be more than 8 characters'
                              : null;
                        },
                      ),
                    ),

                  ]
              ),
            ),
            SizedBox(height: 30,),
            InkWell(
              onTap: () {
                if (formkey.currentState.validate()) {
                  passTextEditingController.text == confirmPasswordTextEditingController.text &&
                  emailTextEditingController.text.isNotEmpty &&
                      passTextEditingController.text.isNotEmpty && phonenumberTextEditingController.text.isNotEmpty
                  && fullnameTextEditingController.text.isNotEmpty
                      ? uploadandsaveimage()
                      : showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: " Please provide correct information ",// 'Please write email and password',
                        );
                      });
                }},
//currentLocationAddress;
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary,
                ),
                width: MediaQuery.of(context).size.width - 220.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            /*RaisedButton(
              onPressed: () {
                uploadandsaveimage();
              },
              color: Colors.pink,
              child: Text('sign up', style: TextStyle(color: Colors.white)),
            ), */SizedBox(height: 30,),
            Container(
              height: 4,
              width: screenwidth * 0.8, color: Colors.pink,
            ), SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
  displaydialog(String msg){
    showDialog(context: context,builder: (c){ return ErrorAlertDialog(message: msg);
    });
  }
  uploadtostorage()async{
    showDialog(context: context,builder: (c){return LoadingAlertDialog(message: 'Authenticating please wait');
  });
  String imagefileName= DateTime.now().millisecondsSinceEpoch.toString();
  StorageReference storageReference= FirebaseStorage.instance.ref().child(imagefileName);
  StorageUploadTask storageUploadTask=storageReference.putFile(imageFile);
  StorageTaskSnapshot taskSnapshot= await storageUploadTask.onComplete;
  await taskSnapshot.ref.getDownloadURL().then((urlImage){
    userImageUrl=urlImage;
    registeruser();
  });
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> saveUserInfotoFirestore(FirebaseUser fuser)async {
    Firestore.instance.collection('users').document(fuser.uid).setData({
      'uid': fuser.uid, 'email': fuser.email, 'password': passTextEditingController.text.trim(), 'name': fullnameTextEditingController.text.trim() ,'PhoneNumber': int.parse(phonenumberTextEditingController.text),'url': userImageUrl,EcommerceApp.userCartList: ['garbageValue'],

    });
    await EcommerceApp.sharedPreferences.setString('uid',fuser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,fuser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userPassword,passTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,fullnameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setInt(EcommerceApp.userPhoneNumber,int.parse(phonenumberTextEditingController.text));
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,userImageUrl);

    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,['garbageValue']);
  }
  void registeruser() async{
    FirebaseUser firebaseUser;
    await auth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passTextEditingController.text.trim()).then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if (FirebaseUser != null) {
      saveUserInfotoFirestore(firebaseUser).then((value){
        Navigator.pop(context);
        Route route=MaterialPageRoute(builder: (c)=> StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future<void> uploadandsaveimage() async {
    if (imageFile == null) {
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: 'please select an image');
      });
    } else {
      passTextEditingController.text == confirmPasswordTextEditingController.text ?
      emailTextEditingController.text.isNotEmpty &&
          passTextEditingController.text.isNotEmpty &&
          fullnameTextEditingController.text.isNotEmpty &&
          confirmPasswordTextEditingController.text.isNotEmpty &&
          phonenumberTextEditingController.text.isNotEmpty ? uploadtostorage()
          : displaydialog('please fill the complete form')
          : displaydialog('passwords do not match');
    }
  }
  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  // regex method to validate email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }


}


