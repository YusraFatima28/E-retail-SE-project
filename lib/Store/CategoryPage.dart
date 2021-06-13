
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';

import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:e_shop/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  const CategoryPage(this.title);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  int selectedFoodCard = 0;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  //_CategoryPageState({Key key, this.title }) : super(Key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
    backgroundColor: Colors.white,
    appBar: PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child : newAppBar() ),
    drawer: CollapsingNavigationDrawer(),
    body: ListView(
      children: [
    Padding(
    padding: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 10),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: PrimaryText(
                text: widget.title,
                fontWeight: FontWeight.w700,
                size: 22),
          ),
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('items').where("title" , isEqualTo: widget.title).snapshots(),
                //Firestore.instance.collection("items").documents
                //document(widget.title).collection('1').limit(1)
            //  .orderBy("publishedDate", descending: true)
             // .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? Center(
                    child: circularProgress(),
                  )
                      : SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(children: <Widget>[
                      ListView.builder(
                          physics:
                          NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataSnapshot
                              .data.documents.length,
                          itemBuilder: (context, index) {
                            ItemModel model =
                            ItemModel.fromJson(dataSnapshot
                                .data
                                .documents[index]
                                .data);
                            // ignore: unnecessary_statements
                            return popularFoodCard(
                                model, context);
                          })
                    ]),
                  );
                },
              ),
            ],
          ),
      ],
    ),),] )),) ;}
  Widget popularFoodCard(
      ItemModel model, BuildContext context ,{Color background, removeCartFunction}) {
    return InkWell( // gesture detector
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(itemModel: model)))
      },
      child: Container(
        margin: EdgeInsets.only(right: 25, left: 20, top: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.lighterGray)],
          color: AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          PrimaryText(
                              text: model.title,
                              size: 20,
                              fontWeight: FontWeight.w700
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: PrimaryText(
                            text: model.shortInfo, size: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10,),
                      PrimaryText(
                        text: "Rs " + model.price.toString(),
                        size: 18,
                        fontWeight: FontWeight.w700, color: Colors.pinkAccent,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 6), // vertical: 20
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: removeCartFunction == null
                            ? IconButton(
                          iconSize: 10,
                          icon: Icon(Icons.add_shopping_cart,
                            color: Colors.pinkAccent, size: 20,),
                          onPressed: () {
                            checkItemInCart(model.shortInfo, context);
                          },
                        )
                            : IconButton(
                          icon: Icon(Icons.remove_shopping_cart,
                            color: Colors.pinkAccent, size: 20,),
                          onPressed: () {
                            removeCartFunction();
                            Route route = MaterialPageRoute(
                                builder: (c) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          },
                        )
                      //Icon(Icons.add_shopping_cart, size: 20),
                    ),
                    SizedBox(width: 10),
                    /*  SizedBox(
                    child: Row(
                      children: [
                        PrimaryText(
                          text: "Rs " + model.price.toString(),
                          size: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),*/
                  ],
                ),
              ],
            ),
            Container(
              /*  transform: Matrix4.translationValues(30.0, 25.0, 0.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[400], blurRadius: 20)
                  ]),*/
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    model.thumbnailUrl,
                    width: 140.0,
                    height: 170.0,
                  ),
                  /*  Hero(
                    tag: imagePath,
                    child: Image.network(imagePath,
                        width: MediaQuery.of(context).size.width / 2.5),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
