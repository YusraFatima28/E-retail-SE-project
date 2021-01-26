import 'dart:wasm';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        flexibleSpace: Container(
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
        colors: [Colors.limeAccent,Colors.lightGreenAccent],
        begin : const FractionalOffset(0.0,0.0),
    end : const FractionalOffset(0.0, 0.5),
    stops: [0,1],
    tileMode: TileMode.clamp,
    )
    )
    ),
    title: Text(
    'E-Retail',style: TextStyle(
    fontSize: 55,
    color: Colors.white,
    fontFamily: "Signatra",
    ),
    ),
    centerTitle: true,
    ),body: AdminSignInScreen());
  }
}
class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}
class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController adminIDTextEditingController = TextEditingController();
  final TextEditingController passTextEditingController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.limeAccent,Colors.lightGreenAccent],
                begin : const FractionalOffset(0.0,0.0),
                end : const FractionalOffset(0.0, 0.5),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
          ),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset('images/admin.png'),height: 190,width: 240,
              ),Padding(padding: EdgeInsets.all(14),child: Text('Admin',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
              ),
              Form(
                key: formkey,
                child: Column(
                    children: [
                      CustomTextField(
                        controller: adminIDTextEditingController,
                        data: Icons.person,
                        hintText: 'id',
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
              SizedBox(height: 25,),
              RaisedButton(
                onPressed: () {
                  adminIDTextEditingController.text.isNotEmpty && passTextEditingController.text.isNotEmpty
                      ? loginadmin()
                      : showDialog(context: context,builder: (c){return ErrorAlertDialog(message: 'Please write email and password',);});
                },
                color: Colors.pink,
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 50,),
              Container(
                height: 4,
                width: screenwidth * 0.8, color: Colors.pink,
              ), SizedBox(height: 20,),
              FlatButton.icon(onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> AuthenticScreen()),),
                icon: Icon(Icons.nature_people,color: Colors.pink,
                ),label: Text('I am not an admin',style: TextStyle(color:Colors.pink, fontWeight: FontWeight.bold),),),
              SizedBox(height: 50,),
            ]
        ),
      ),
    );
  }
  loginadmin(){
    Firestore.instance.collection('admins').getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data['id'] != adminIDTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('your id is not correct')));
        }
        else if(result.data['password'] != passTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('your password is not correct')));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome admin '+ result.data['name'])));
          setState(() {
            adminIDTextEditingController.text='';
            passTextEditingController.text = '';
          });
          Route route=MaterialPageRoute(builder: (c)=> UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
