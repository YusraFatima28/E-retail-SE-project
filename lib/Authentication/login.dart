
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminAuthentication.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Store/ChangePassword.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';

import '../textFieldFormaters.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool _autoValidate = true;
// variable to enable toggling between showing and hiding password
  bool _hidePassword = true;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(mainAxisSize: MainAxisSize.max, children: [

          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('images/login.png'),
            height: 240,
            width: 240,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'login to your account',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Form(
            key: formkey,
            autovalidate: _autoValidate,
            child: (Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                if (formkey.currentState.validate()) {
//loginuser(); }
                    emailTextEditingController.text.isNotEmpty &&
                            passTextEditingController.text.isNotEmpty
                        ? loginuser()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: 'Please write email and password',
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
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 4,
            width: screenwidth * 0.8,
            color: Colors.pink,
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => adminAuthentication()),
            ),
            icon: Icon(
              Icons.nature_people,
              color: Colors.pink,
            ),
            label: Text(
              'I am admin',
              style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void loginuser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Authentication please wait.....');
        });
    FirebaseUser firebaseUser;
    await auth
        .signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      print(emailTextEditingController.text.trim().runtimeType);
      print(passTextEditingController.text.trim().runtimeType);
      print(' e and p');
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            ); //message: error.message.toString(),);
          });
    });
    if (firebaseUser != null) {
      readdata(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future<void> readdata(FirebaseUser fuser) async {
    Firestore.instance
        .collection('users')
        .document(fuser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString('uid', dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartlist =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartlist);
    });
  }

  TextStyle normalFont(Color color, double size) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(color: color),
//Color: color,
      fontSize: size,
    );
  }

  Widget primaryButtonPurple(
    Widget buttonChild,
    void Function() onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: RawMaterialButton(
        elevation: 0.0,
        hoverElevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        fillColor: AppColors.primary,
        child: buttonChild,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
    );
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
