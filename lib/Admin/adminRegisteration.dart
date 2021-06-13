import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
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
class adminRegisteration extends StatefulWidget {
  @override
  adminRegisterationState createState() => adminRegisterationState();
}
class adminRegisterationState extends State<adminRegisteration> {
  final TextEditingController fullnameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passTextEditingController = TextEditingController();
  final TextEditingController phonenumberTextEditingController = TextEditingController();
  final TextEditingController confirmPasswordTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String adminImageUrl = "";
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
                      child:
                      TextFormField(
                        controller: addressTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder( gapPadding: 9,
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(Icons.home_outlined),
                          labelText: 'Address',
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
                      child: TextFormField(
                        controller: emailTextEditingController,
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
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
                      ? uploadandsaveadminimage()
                      : showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: " Please provide correct information ",// 'Please write email and password',
                        );
                      });
                }},
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary,
                ),
                width: MediaQuery.of(context).size.width - 220.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    'Register Admin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
             SizedBox(height: 30,),
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
      adminImageUrl=urlImage;
      registerAdmin();
    });
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> saveAdminInfotoFirestore(FirebaseUser fadmin)async {
    Firestore.instance.collection('admins').document(fadmin.uid).setData({
      'admin_id': fadmin.uid, 'admin_email': fadmin.email, 'admin_password': passTextEditingController.text.trim(), 'admin_name': fullnameTextEditingController.text.trim() ,'admin_url': adminImageUrl,
      'admin_address' : addressTextEditingController.text.trim(), 'admin_PhoneNumber': phonenumberTextEditingController.text.trim()
    });
    await EcommerceApp.sharedPreferences.setString('uid',fadmin.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminEmail,fadmin.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminPassword,passTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminName,fullnameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminPhoneNumber,phonenumberTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminAvatarUrl,adminImageUrl);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.adminAddress,addressTextEditingController.text);

  }
  void registerAdmin() async{
    FirebaseUser firebaseAdmin;
    await auth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passTextEditingController.text.trim()).then((auth) {
      firebaseAdmin = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if (FirebaseUser != null) {
      saveAdminInfotoFirestore(firebaseAdmin).then((value){
        Navigator.pop(context);
        Route route=MaterialPageRoute(builder: (c)=> UploadPage());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future<void> uploadandsaveadminimage() async {
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
          phonenumberTextEditingController.text.isNotEmpty && addressTextEditingController.text.isNotEmpty ? uploadtostorage()
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


