
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            image: EcommerceApp
          .sharedPreferences
        .getString(EcommerceApp.adminAvatarUrl),
            name: EcommerceApp.sharedPreferences
                .getString(EcommerceApp.adminName),
            email: EcommerceApp.sharedPreferences
                .getString(EcommerceApp.adminEmail),
          ),
          SizedBox(height: SizeConfig.defaultSize * 2), //20
          Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.dashPurple,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 0.01,
                  ),
                  //InkWell(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Icon(Icons.email, size: 24,),
                      ),
                      SizedBox(width: 23.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: AppColors.dashPurple,
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        children: [
                          SizedBox(width: 55.0),
                          Text(
                          EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.adminEmail.toString()),
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16.0,),
                        ),]),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 15,),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.dashPurple,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 0.01,
                  ),
                  //InkWell(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Icon(Icons.call, size: 24,),
                      ),
                      SizedBox(width: 23.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: AppColors.dashPurple,
                    child: SizedBox(
                      height: 35,
                      child: Row(
                          children: [
                            SizedBox(width: 75.0),
                            Text(
    ( EcommerceApp.sharedPreferences
                                  .getInt(EcommerceApp.adminPhoneNumber)).toString(),
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16.0,)
                                  //fontWeight: FontWeight.bold),
                            ),]),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 15,),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.dashPurple,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 0.01,
                  ),
                  //InkWell(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Icon(Icons.home, size: 26,),
                      ),
                      SizedBox(width: 21.0),
                      Expanded(
                        child: Container(
                          child: Text(
                          'Address',
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore.collection(EcommerceApp.collectionAdmin).document(
                        EcommerceApp.sharedPreferences.getString(EcommerceApp.adminUID)
                    ).collection(EcommerceApp.subCollectionAddress).snapshots(),
                    builder: (context, snapshot){
                      return !snapshot.hasData ? Center(
                        child: circularProgress(),
                      ) : snapshot.data.documents.length==0 ? noAddressCard() : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index) {
                            return AddressCard(
                                currentIndex: index, //address.count,
                                value: index,
                                addressID: snapshot.data.documents[index].documentID,
                                model: AddressModel.fromJson(snapshot.data.documents[index].data)
                            );
                          });
                    }
                ),),
                  /*Text(
                    (EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.collectionUser)),
                        style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),*/
                ],
              )),

        ],
      ),
    );
  }
}
class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final String addressID;
  final int value;
  AddressCard({
    Key key, this.currentIndex,this.model,this.addressID,this.value}) : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}
class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
        color: AppColors.dashPurple,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.5,
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                //KeyText(msg: 'Flat Number'),
                                Text(widget.model.homeAddress),]),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    this.name,
    this.email,
    this.image,
  }) : super(key: key);
  final String name, email, image;
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 24, // 240
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 15, //150
              color: AppColors.primary,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end , //end
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: 120,
                  width: 120,
                  //height: defaultSize * 14, //140
                 // width: defaultSize * 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.4, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.adminAvatarUrl),
                      ),
                      //AssetImage(image),
                    ),
                  ),
                ),
               // SizedBox(height: 17,),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24, // 22
                    color: AppColors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: defaultSize / 2), //5
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key key,
    this.iconSrc,
    this.title,
    this.press,
  }) : super(key: key);
  final String iconSrc, title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2, vertical: defaultSize * 3),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(iconSrc),
              SizedBox(width: defaultSize * 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: defaultSize * 1.6, //16
                  color: AppColors.black,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: defaultSize * 1.6,
                color: AppColors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child : newAppBar() ),
      body: Body(),
      drawer: CollapsingNavigationDrawer(),
    );
  }
}
noAddressCard() {
  return Card(
    color: AppColors.dashPurple,
    child: Container(
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_listed_location, color: Colors.white,),
          SizedBox(height: 10,),
          Text('There is no address saved '),
        ],
      ),
    ),
  );
}


class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    // On iPhone 11 the defaultSize = 10 almost
    // So if the screen size increase or decrease then our defaultSize also vary
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}