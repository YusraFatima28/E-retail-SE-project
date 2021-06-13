import 'package:e_shop/Admin/adminAuthentication.dart';
import 'package:e_shop/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'authenication.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 23,),
            Text(
              "WELCOME TO E-RETAIL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: AppColors.primary),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "images/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            ButtonTheme(
              height: 50,
              minWidth: 170,
              child: RaisedButton.icon(
                onPressed: (){   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AuthenticScreen();
                    },
                  ),
                ); },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                label: Text('USER',
                  style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold , fontSize: 20),),
                icon: Icon(Icons.person, color:Colors.white,),
                textColor: AppColors.white,
                splashColor: Colors.red,
                color: AppColors.primary,),
            ),

            SizedBox(height: 20,),
            ButtonTheme(
              height: 50,
              minWidth: 170,
              child: RaisedButton.icon(
                onPressed: (){   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return adminAuthentication();
                    },
                  ),
                ); },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                label: Text('ADMIN',
                  style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold , fontSize: 20),),
                icon: Icon(Icons.person_pin, color:Colors.white,),
                textColor: AppColors.white,
                splashColor: Colors.red,
                color: AppColors.primary,),
            ),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}