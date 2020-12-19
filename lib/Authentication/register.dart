import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passTextEditingController = TextEditingController();
  final TextEditingController cpassTextEditingController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File imageFile;
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
            SizedBox(height: 8,),
            Form(
              key: formkey,
              child: Column(
                  children: [
                    CustomTextField(
                      controller: nameTextEditingController,
                      data: Icons.person,
                      hintText: 'name',
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: emailTextEditingController,
                      data: Icons.email,
                      hintText: 'email',
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: passTextEditingController,
                      data: Icons.lock_open,
                      hintText: 'password',
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: cpassTextEditingController,
                      data: Icons.lock_open,
                      hintText: 'confirm password',
                      isObsecure: true,
                    ),
                  ]
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadandsaveimage();
              },
              color: Colors.pink,
              child: Text('sign up', style: TextStyle(color: Colors.white)),
            ), SizedBox(height: 30,),
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
  uploadtostorage()async{ showDialog(context: context,builder: (c){return LoadingAlertDialog(message: 'Authenticating please wait');
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
      'uid': fuser.uid, 'email': fuser.email, 'name': nameTextEditingController.text.trim() ,'url': userImageUrl,EcommerceApp.userCartList: ['garbageValue']
    });
    await EcommerceApp.sharedPreferences.setString('uid',fuser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,fuser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,nameTextEditingController.text);
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
      passTextEditingController.text == cpassTextEditingController.text ?
      emailTextEditingController.text.isNotEmpty &&
          passTextEditingController.text.isNotEmpty &&
          cpassTextEditingController.text.isNotEmpty &&
          nameTextEditingController.text.isNotEmpty ? uploadtostorage()
          : displaydialog('please fill the complete form')
          : displaydialog('passwords donot match');
    }
  }
    }


