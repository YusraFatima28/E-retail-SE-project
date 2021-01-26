import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}
class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar: AppBar(bottom: PreferredSize(child: searchWidget(), preferredSize: Size(56,56),),), //56,56
        body: FutureBuilder<QuerySnapshot>(
          future: docList, builder: (context,snap){
            return snap.hasData ? ListView.builder(
              itemCount: snap.data.documents.length,
              itemBuilder: (context,index){
                ItemModel model= ItemModel.fromJson(snap.data.documents[index].data);
                return sourceInfo(model, context);
              },
            )
                : Text('');
        },
        ),
        drawer: MyDrawer(),


      ),

    );
  }

  Widget BodySearch(){
    return Column(
       children: [
         Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Image.asset('images/serach.png'),
               SizedBox(height: 20,),
             ],
           )
         )
       ],
    );
  }
  Widget searchWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.limeAccent, Colors.lightGreenAccent], // Colors.limeAccent,Colors.lightGreenAccent
              begin : const FractionalOffset(0.0,0.0),
              end : const FractionalOffset(0.0, 0.5),
              stops: [0,1],
              tileMode: TileMode.clamp,
            ),
          ),
          child : Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width-40.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.search, color: Colors.blueGrey,),),
                Flexible(child: Padding(padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value){
                    startSearching(value);
                  },decoration: InputDecoration.collapsed(hintText: 'Search here .... '),
                ),))
              ],
            ),
          ),
        ),SizedBox(
          height: 10,
          width: MediaQuery.of(context).size.width,
        ),

            /*Center(
              child: Container(

                alignment: Alignment.bottomCenter,
                color: Colors.lightGreen,
                height: 99,
                width: MediaQuery.of(context).size.width,
                child: Center(
    child: (
    Padding(padding: EdgeInsets.all(0),
    child: Image.asset('images/search.png', height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,),)
                ),),
              ),
            )*/

      ],
    );

  }
  Future startSearching(String query) async {
    docList= Firestore.instance.collection('items').where('shortInfo', isGreaterThanOrEqualTo: query).getDocuments();
  }
}