
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Colors.dart';
class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /*   appBar: AppBar(
          flexibleSpace: Container(
              decoration: new BoxDecoration(
              color: AppColors.primary
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
        ),*/
        body: AdminSignInScreen());
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
  bool _autoValidate = true;
  bool _hidePassword = true;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.yellow, Colors.pinkAccent],
                  //begin : Alignment.
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                )),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset('images/admin.png', height: 240,width : 280),height: 240,width: 280,
              ),Padding(padding: EdgeInsets.all(12),child: Text('Admin',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),
              ),
              Form(
                key: formkey,
                child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          controller: adminIDTextEditingController,
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

                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_open,
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
                      SizedBox(
                        height: 30.0,
                      ),
                    ]
                ),
              ),
              SizedBox(height: 25,),
              RaisedButton(
                onPressed: ()
                 { if (formkey.currentState.validate()) {

                  adminIDTextEditingController.text.isNotEmpty && passTextEditingController.text.isNotEmpty
                      ? loginadmin()
                      : showDialog(context: context,builder: (c){return ErrorAlertDialog(message: 'Please write email and password',);});
                }},
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
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  loginadmin(){
    Firestore.instance.collection('admins').getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data['admin_email'] != adminIDTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('your id is not correct')));
        }
        else if(result.data['admin_password'] != passTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('your password is not correct')));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome admin '+ result.data['admin_name'])));
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