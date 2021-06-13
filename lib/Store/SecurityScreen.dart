import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Authentication/welcome.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*import 'package:petShop/screens/settings_screens/changePassword.dart';
import 'package:petShop/utils/colors.dart';
import 'package:petShop/utils/permission_handler.dart';
import 'package:petShop/widgets/allWidgets.dart';
import 'package:permission_handler/permission_handler.dart';*/
import 'package:flutter_svg/svg.dart';

import '../Colors.dart';
import 'ChangePassword.dart';

class SecurityScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final listTileIcons = [
      "images/key.svg",
     "images/logout.svg"


    ];
    final listTileNames = [
      "Change Password",
      "Log Out "
    ];
    final listTileActions = [
          () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => ChangePassword(),
          ),
        );
      },
          () {
            Future<void> _signOut() async {
              await auth. signOut();
            }
            _signOut();
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (_) => WelcomeScreen(),

        //AuthenticScreen(),
      ),
      );
      }
    ];
    return Scaffold(
      backgroundColor: AppColors.primaryWhiteSmoke,
      drawer: CollapsingNavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child : newAppBar() ),
      /*primaryAppBar(
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
          onPressed: () {
            Route route =
            MaterialPageRoute(builder: (c) => StoreHome()); //AddAddress()
            Navigator.pushReplacement(context, route);
          },
        ),
        Text(
          "Security",
          style: TextStyle(color: AppColors.black, fontSize: 22),
        ),
        AppColors.primaryWhiteSmoke,
        null,
        true,
        null,
      ),*/
      body: primaryContainer(
        Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: listTileNames.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return Container(
                child: Column(
                  children: <Widget>[
                    listTileButton(
                      listTileActions[i],
                      listTileIcons[i],
                      listTileNames[i],
                      AppColors.black,
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Widget listTileButton(
      void Function() onPressed,
      String iconImage,
      String listTileName,
      Color color,
      ) {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            SizedBox(width: 20.0),
            SvgPicture.asset(
              iconImage,
              height: 30,
              color: AppColors.black,
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Text(
                listTileName,
                style: TextStyle(color: AppColors.black, fontSize: 18 ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.black,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
  Widget primaryContainer(
      Widget containerChild,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: AppColors.primaryWhiteSmoke,
      child: containerChild,
    );
  }
  Widget primaryAppBar(
      Widget leading,
      Widget title,
      Color backgroundColor,
      PreferredSizeWidget bottom,
      bool centerTile,
      List<Widget> actions,
      ) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      backgroundColor: backgroundColor,
      leading: leading,
      title: title,
      bottom: bottom,
      centerTitle: centerTile,
      actions: actions,
    );
  }

}
