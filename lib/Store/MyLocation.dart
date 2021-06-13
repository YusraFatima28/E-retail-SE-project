import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_svg/svg.dart';

import '../Colors.dart';



class MyLocation extends StatefulWidget {
  // location
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {

  var locationMessage = '';
  var locationAddress = '';
  String latitude;
  String longitude;
  String currentLocationAddress = '';
  bool pressed = false;
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const len = [1,2,3,4,5];

  // function for getting the current location
  // but before that you need to add this permission!
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      locationMessage = "Latitude: $lat and Longitude: $long";
      _getLocation();
      //locationAddress=  " Address : $addresses" ;
    });
  }

  // function for opening it in google maps
  void googleMap() async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else
      throw ("Couldn't open google maps");
  }
  _getLocation() async {
    /*Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      currentLocationAddress = first.addressLine;
    });*/
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      currentLocationAddress = first.addressLine;
    });
    //return currentLocationAddress;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User location application',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child : newAppBar() ),
        drawer: CollapsingNavigationDrawer(),
        backgroundColor: AppColors.primaryWhiteSmoke,
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              //child: Image.asset('images/homelocation.png'),
              Image.asset(
                'images/homelocation.png',
                height: 200,
                width: 250,
              ),

              /* Icon(
                Icons.location_on,
                size: 45.0,
                color: ,
              ),*/
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Get User Location",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              // Text(
              //   locationMessage,
              //   style: TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
              // button for taking the location
              InkWell(
                onTap: () {
                  getCurrentLocation();
                  setState(() {
                    pressed = true;
                  });
                  //Text(currentLocationAddress , style: TextStyle(color : AppColors.textGrey, fontSize: 14.0, fontWeight: FontWeight.bold),),
                  print(currentLocationAddress);
                  print(' currnt address ');
                },
                //currentLocationAddress;
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Get User Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              pressed
                  ? Container(
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
                            height: 0.05,
                          ),
                          //InkWell(),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                child: SvgPicture.asset(
                                  "images/Discovery.svg",
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              SizedBox(width: 23.0),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "Current Location",
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
                            height: 4,
                          ),
                          currentLocationAddress.isEmpty
                              ? Center(
                                  child: progressIndicator(
                                      AppColors.primaryPurple))
                              : GestureDetector(
                                  onTap: () => _showModalSheet(
                                    currentLocationAddress,
                                    true,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 14.0,
                                    ),
                                    child: Text(
                                      currentLocationAddress,
                                      style: TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                          // ignore: deprecated_member_use
                          //GestureDetector(onTap: ()=> _showModalSheet(currentLocationAddress,true )),
                          /* RaisedButton(onPressed : ()=> showModalBottomSheet(context: context, builder:(context){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(Icons.photo),
                              title: new Text('Photo'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.music_note),
                              title: new Text('Music'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.videocam),
                              title: new Text('Video'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.share),
                              title: new Text('Share'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );

                      }),)*/
                          /*  InkWell(onTap: _showModalSheet(currentLocationAddress, true),),
                      GestureDetector(onTap: _showModalSheet(currentLocationAddress,true),),
                      FlatButton(onPressed:showModalBottomSheet(context: context, builder: builder) _showModalSheet(,true), child: Text(''))*/
                        ],
                      ))
                  : Text(''),
              SizedBox(
                height: 10.0,
              ),
              //Text(currentLocationAddress , style: TextStyle(color : AppColors.textGrey, fontSize: 14.0, fontWeight: FontWeight.bold),),
              InkWell(
                onTap: () {
                  googleMap();
                },
                //currentLocationAddress;
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Open GoogleMap',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => AddAddress()); //AddAddress()
                  Navigator.pushReplacement(context, route);
                },
                //currentLocationAddress;
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Fill Address Form',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget progressIndicator(Color color) {
    return Container(
      color: AppColors.dashPurple,
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 12.0,
        ),
      ),
    );
  }

  void _showModalSheet(_address, bool currentLocation) {
    String _streetNameAndNumber;
    String _name;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.9,
          margin: EdgeInsets.only(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            top: 5.0,
          ),
          padding: EdgeInsets.only(
            bottom: 15.0,
            left: 15.0,
            right: 15.0,
            top: 10.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryWhiteSmoke,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Scaffold(
            backgroundColor: AppColors.primaryWhiteSmoke,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    modalBarWidget(),
                    SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        currentLocation == false
                            ? "Please enter your legal name, address name and number, and apt or house number"
                            : "Please enter your name , phone number and pinCode ",
                        style:
                            TextStyle(color: AppColors.textDark, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 30.0,
                      child: SvgPicture.asset(
                        "images/Location.svg",
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        currentLocation == false
                            ? _address.addressLocation
                            : _address,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Full Name",
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 14.0),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: cName, //fullnameTextEditingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                gapPadding: 9,
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Full Name',
                          ),
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            return value.isEmpty
                                ? 'Name cannot be empty'
                                : null;
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              currentLocation == false
                                  ? "Apt or house number and street name and number"
                                  : "Phone Number",
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 14.0),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller:
                                cPhoneNumber, // phonenumberTextEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  gapPadding: 9,
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: validateMobile,
                          ),
                        ]),
                    SizedBox(height: 20.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              currentLocation == false
                                  ? "Apt or house number and street name and number"
                                  : "Pin Code",
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 14.0),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: cPinCode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  gapPadding: 9,
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(Icons.push_pin),
                              labelText: 'PinCode ',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (String value) {
                              return value.isEmpty
                                  ? 'Pin Code cannot be empty'
                                  : null;
                            },
                            //validator: validateMobile,
                          ),
                        ]),
                    /*primaryTextField(
                          null,
                          null,
                          null,
                              (val) => _streetNameAndNumber = val,
                          true,
                              (String value) =>
                          value.isEmpty ? Strings.fieldReq : null,
                          false,
                          _autoValidate,
                          true,
                          currentLocation == false
                              ? TextInputType.text
                              : TextInputType.number,
                          null,
                          null,
                          0.50,
                        ),*/
                    SizedBox(height: 5.0),
                    currentLocation == false
                        ? Container(
                            child: Text(
                                "Please enter information in order stated above!",
                                style: TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontSize: 14.0)
                                //normalFont(MColors.primaryPurple, null),
                                ),
                          )
                        : Container(),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {

      final FormState form = formKey.currentState;
      if (form.validate()) {

        final model = AddressModel(
          name: cName.text.trim(),
          //state: cState.text.trim(),
          pinCode: cPinCode.text.trim(),
          phoneNumber: cPhoneNumber.text.trim(),
          homeAddress : currentLocationAddress,
          //flatNumber: cFlatHomeNumber.text.trim(),
          //city: cCity.text.trim(),
        ).toJson();
        // add to firestore
        EcommerceApp.firestore
            .collection(EcommerceApp.collectionUser)
            .document(EcommerceApp.sharedPreferences
            .getString(EcommerceApp.userUID))
            .collection(EcommerceApp.subCollectionAddress)
            .document(DateTime.now()
            .microsecondsSinceEpoch
            .toString())
            .setData(model)
            .then((value) {
          final snake = SnackBar(
              content:
              Text('New address added successfully '));
          scaffoldKey.currentState.showSnackBar(snake);
          FocusScope.of(context).requestFocus(FocusNode());
          formKey.currentState.reset();
        });

        Route route =
        MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route); }
      } ,
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.primary,
                        ),
                        width: MediaQuery.of(context).size.width - 220.0,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //  }
                // })
              ),
            ),
          ),
        );
      },
    );
  }
  modalBarWidget() {
    return Container(
      height: 6.0,
      child: Center(
        child: Container(
          width: 50.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
