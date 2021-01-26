import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:firebase_core/firebase_core.dart';

class UploadPage extends StatefulWidget   {
@override
  _UploadPageState createState() => _UploadPageState();
}
class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {
  //UploadFormState createState() => UploadFormState();
//with AutomaticKeepAliveClientMixin<UploadPage>
  bool get wantKeepAlive => true;
  File file;
  bool dede= false;
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController shortInfoTextEditingController = TextEditingController();
  String productID = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    //File file;
    return file == null ? displayAdminHomeScreen(): displayAdminUploadFormScreen();}
    displayAdminHomeScreen(){
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.limeAccent, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 0.5),
                    stops: [0, 1],
                    tileMode: TileMode.clamp,
                  )
              )
          ),
          leading: IconButton(
            icon: Icon(Icons.border_color, color: Colors.white), onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },),
          actions: [
            FlatButton(child: Text('logout', style: TextStyle(
                color: Colors.pink,
                fontSize: 16,
                fontWeight: FontWeight.bold),),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },)
          ],
        ),body: displayAdminHomeScreenBody());}
        displayAdminHomeScreenBody(){
    return
      Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.limeAccent, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ), child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shop_two, color: Colors.white, size: 200),
              Padding(padding: EdgeInsets.only(top: 20,),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),),
                    child: Text('add new item',
                      style: TextStyle(fontSize: 20, color: Colors.white),),
                    color: Colors.green,
                    onPressed: () { takeImage(context);}))])));}
    takeImage(mContext) {
      return showDialog(context: mContext, builder: (con) {
        return SimpleDialog(
            title: Text('Item Image', style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                  child: Text('select from gallery',
                      style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context,pickPhotoFromGallery());
                  }
              ),
              SimpleDialogOption(
                  child: Text('capture with camera',
                      style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context, capturePhotoWithCamera());
                  }
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },),
            ]
        );
      });
    }
    capturePhotoWithCamera() async {
      //final picker = ImagePicker();
      //Navigator.pop(context);
      File imageFile = await ImagePicker.pickImage( source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
      setState(() {
        file = imageFile;
        displayAdminUploadFormScreen();
      });
        //Route route=MaterialPageRoute(builder: (c)=> UploadFormState());
        //Navigator.pushReplacement(context, route);
        //Navigator.pop(context,displayAdminUploadFormScreen());
    }
    pickPhotoFromGallery() async {
      //final picker = ImagePicker();
      //Navigator.pop(context);
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery,);
      setState(() {
        file = imageFile;
        displayAdminUploadFormScreen();
      });
        //Navigator.pop(context,displayAdminUploadFormScreen());
    }
  displayAdminUploadFormScreen(){
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
        leading: IconButton(icon: Icon(Icons.arrow_back, color:Colors.white) ,onPressed:(){clearFormInfo();}),
        title: Text( 'New product' ,style: TextStyle(color:Colors.white, fontSize: 24.0,fontWeight: FontWeight.bold),),
        actions: [
          FlatButton(
            onPressed: uploading ? null :()=> uploadImageAndSaveitemInfo(),
            child: Text('Add',style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold)),)
        ],
      ),
      body: ListView(
        children:[
        uploading ? linearProgress(): Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file) , fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_information,color:Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: 'short info',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.perm_device_information,color:Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: titleTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.perm_device_information,color:Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.perm_device_information,color:Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: priceTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),]
      ),
    );
  }
  clearFormInfo()
  {
   setState(() {
     file= null;
     descriptionTextEditingController.clear();
     priceTextEditingController.clear();
     shortInfoTextEditingController.clear();
     titleTextEditingController.clear();
     UploadPage();
     //displayAdminHomeScreen();
     //Route route=MaterialPageRoute(builder: (c)=> displayAdminHomeScreen());
     //Navigator.pushReplacement(context, route);
     //Navigator.pop(context,displayAdminUploadFormScreen());
   });
  }
  uploadImageAndSaveitemInfo()async{
    setState(() {
      uploading= true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async{
    final StorageReference storageReference= FirebaseStorage.instance.ref().child('items');
    StorageUploadTask uploadTask= storageReference.child("product_$productID.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl){
    final itemRef = Firestore.instance.collection('items');
    itemRef.document(productID).setData({
      "shortInfo": shortInfoTextEditingController.text.trim(),
    "longDescription": descriptionTextEditingController.text.trim(),
    "price": int.parse(priceTextEditingController.text),
    "publishedDate": DateTime.now(),
    "status": "available",
    "thumbnailUrl": downloadUrl,
    "title": titleTextEditingController.text.trim(),
    });
    setState(() {
      file=null;
      uploading= false;
      productID= DateTime.now().microsecondsSinceEpoch.toString();
      descriptionTextEditingController.clear();
      titleTextEditingController.clear();
      shortInfoTextEditingController.clear();
      priceTextEditingController.clear();
    });
  }
}







