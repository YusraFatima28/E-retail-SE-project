//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login>
{
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passTextEditingController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('images/login.png'),height: 240,width: 240,
            ),Padding(padding: EdgeInsets.all(8),child: Text('login to your account',style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: formkey,
              child: Column(
                  children: [
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
                  ]
              ),
            ),
            RaisedButton(
              onPressed: () {
                emailTextEditingController.text.isNotEmpty && passTextEditingController.text.isNotEmpty
                    ? loginuser()
                    : showDialog(context: context,builder: (c){return ErrorAlertDialog(message: 'Please write email and password',);});
              },
              color: Colors.pink,
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 50,),
            Container(
              height: 4,
              width: screenwidth * 0.8, color: Colors.pink,
            ), SizedBox(height: 10,),
            FlatButton.icon(onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> AdminSignInPage()),),
              icon: Icon(Icons.nature_people,color: Colors.pink,
              ),label: Text('I am admin',style: TextStyle(color:Colors.pink, fontWeight: FontWeight.bold),),),
          ]
        ),
      ),
    );
  }
  FirebaseAuth auth = FirebaseAuth.instance;
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
        Route route=MaterialPageRoute(builder: (c)=> StoreHome());
        Navigator.pushReplacement(context, route);

    }); }}
    Future<void> readdata(FirebaseUser fuser)async{
    Firestore.instance.collection('users').document(fuser.uid).get().then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString('uid', dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartlist= dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartlist);
    });
  }
}
