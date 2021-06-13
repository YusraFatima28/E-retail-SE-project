import 'dart:ui';

import 'package:e_shop/Colors.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}
class _SearchProductState extends State<SearchProduct> {
  bool isEmpty = false;
  Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWhiteSmoke,
        appBar: newAppBar(bottom: PreferredSize(child: searchWidget(), preferredSize: Size(56,56),),),
        //AppBar(bottom: PreferredSize(child: searchWidget(), preferredSize: Size(56,56),),), //56,56
        body:

        buildSearchBody(),

        /*FutureBuilder<QuerySnapshot>(
          future: docList, builder: (context,snap){
          return snap.hasData ? ListView.builder(
            itemCount: snap.data.documents.length,
            itemBuilder: (context,index){
              ItemModel model= ItemModel.fromJson(snap.data.documents[index].data);
              return sourceInfo(model, context);
            },
          )
              :   Text( '');
        },
        ),*/

        drawer: CollapsingNavigationDrawer(),
      ),
    );
  }
  Widget buildSearchBody() {
    FutureBuilder<QuerySnapshot>(
      future: docList, builder: (context,snap){
      return snap.hasData ? ListView.builder(
        itemCount: snap.data.documents.length,
        itemBuilder: (context,index){
          ItemModel model= ItemModel.fromJson(snap.data.documents[index].data);
          return popularFoodCard(model, context);
        },
      )
          : Text('');
    },
    );
    String a= '1';
    if (docList.toString()== 'null') {
      print(docList.toString());
      print(' doclist ');
      return primaryContainer(
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child:
                  SvgPicture.asset(
                    "assets/images/noSearch.svg",
                    height: 220,
                  ),
                ),
                Container(
                  child: Text(
                    "No Search Query",
                    style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),//boldFont(AppColors.textDark, 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Text(
                    "Type a product name in the searchbar above.",
                    style: TextStyle(color: AppColors.textGrey , fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      print(docList);
      print(' doclist ');
      return FutureBuilder<QuerySnapshot>(
        future: docList, builder: (context,snap){
        return snap.hasData ? ListView.builder(
          itemCount: snap.data.documents.length,
          itemBuilder: (context,index){
            ItemModel model= ItemModel.fromJson(snap.data.documents[index].data);
            return popularFoodCard(model, context);
          },
        )
            : Text('');
      },
      );
      /*   return SearchTabWidget(
        key: UniqueKey(),
        prods: searchList,
        cartNotifier: cartNotifier,
        productsNotifier: productsNotifier,
        cartProdID: cartProdID,
      );*/
    }
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
  Widget searchWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 6,),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 65.0,
          decoration: new BoxDecoration(
            color: AppColors.primary,
          ),
          child :
       Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width-30.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: AppColors.dashPurple,
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.search, color: AppColors.primaryPurple,),),
                Flexible(child: Padding(padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    onChanged: (value){
                      startSearching(value);
                    },decoration: InputDecoration.collapsed(hintText: 'Search here '),
                  ),))
              ],
            ),
          ),),
        SizedBox(
          height: 8,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
  Future startSearching(String query) async {
    print(docList);
    print(' doocc ');
    docList= Firestore.instance.collection('items').where('title', isEqualTo: query).getDocuments();
    print(docList );
    print(' doocc ');
  }
}