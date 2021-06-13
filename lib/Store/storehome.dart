import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';


import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';

import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:e_shop/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'CategoryPage.dart';
import 'cart.dart';
double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  int selectedFoodCard = 0;
  static const productCategoryList = [
    {
      'imagePath': 'images/bags.png',
      'name': 'Bags',
    },
    {
      'imagePath': 'assets/sea-food.svg',
      'name': 'Shoes',
    },
    {
      'imagePath': 'assets/coke.svg',
      'name': 'Perfumes',
    },
    {
      'imagePath': 'assets/pizza.svg',
      'name': 'Watches',
    },
    {
      'imagePath': 'assets/pizza.svg',
      'name': 'Sun Glasses',
    },
  ];

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
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Icon(
                          Icons.search,
                          color: AppColors.secondary,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: AppColors.lighterGray)),
                                hintText: 'Search..',
                                hintStyle: TextStyle(
                                    color: AppColors.lightGray,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: PrimaryText(
                          text: 'Categories',
                          fontWeight: FontWeight.w700,
                          size: 22),
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productCategoryList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 25 : 0),
                          child: foodCategoryCard(
                              productCategoryList[index]['imagePath'],
                              productCategoryList[index]['name'],
                              index),
                        ),
                      ),
                      /*StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("items")
                              .limit(5)
                              //.orderBy("publishedDate", descending: true)
                              .snapshots(),
                          builder: (context, dataSnapshot) {
                            return !dataSnapshot.hasData
                                ? Center(
                                    child: circularProgress(),
                                  )
                                : ListView.builder(
                                    //physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        dataSnapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      print( dataSnapshot.data.documents[index].documentID); //[index].documentID
                                      print(' pata to chale');
                                      ItemModel model = ItemModel.fromJson(
                                          dataSnapshot
                                              .data.documents[index].data);
                                      return Padding(
                                          padding: EdgeInsets.only(
                                              left: index == 0 ? 7 : 0),
                                          child: foodCategoryCard(
                                              model.thumbnailUrl,
                                              model.title,
                                              index));
                                    });
                            ;
                          }),*/
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: PrimaryText(
                          text: 'Popular',
                          fontWeight: FontWeight.w700,
                          size: 22),
                    ),
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(stream:Firestore.instance.collection("items").limit(25).orderBy("publishedDate", descending: true).snapshots(),
                          builder: (context, dataSnapshot) {
                            final docs = dataSnapshot.data.documents..shuffle();
                            //print(docs);
                            print(' docs hai ye ');
                            print(dataSnapshot.hasData);
                            print(dataSnapshot.data);
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
                                    itemCount : docs.length,
                                    //       itemCount: dataSnapshot
                                    //         .data.documents.length,
                                    itemBuilder: (context, index) {
                                      print(docs[index].data);
                                      print(' index');
                                      ItemModel model =
                                      ItemModel.fromJson(docs[index].data);
                                      //  ItemModel.fromJson(dataSnapshot
                                      //   .data
                                      //   .documents[index]
                                      //   .data);
                                      // ignore: unnecessary_statements
                                      return popularFoodCard(
                                          model, context);
                                    })
                              ]),
                            );
                          },
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }


  Widget foodCategoryCard(String imagePath, String name, int index) {
    return GestureDetector(
      onTap: () => {
        // if (name == "Stalls"){
        setState(
              () => {
            print(index),
            print('selectedFoodCard'),
            selectedFoodCard = index,
          },
        )
      },
      /*   Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(name)))*/
      //}

      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
            selectedFoodCard == index ? AppColors.primary : AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.lighterGray,
                blurRadius: 15,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Image.asset(imagePath, width: 60, height: 80,),
            PrimaryText(text: name, fontWeight: FontWeight.w800, size: 16),
            RawMaterialButton(
                onPressed: () {
                  if (selectedFoodCard == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(name)));
                  }
                  if (selectedFoodCard == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(name)));
                  }
                  if (selectedFoodCard == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(name)));
                  }
                  if (selectedFoodCard == 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(name)));
                  }
                  if (selectedFoodCard == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(name)));
                  }
                },
                fillColor: selectedFoodCard == index
                    ? AppColors.white
                    : AppColors.tertiary,
                shape: CircleBorder(),
                child: Icon(Icons.chevron_right_rounded,
                    size: 20,
                    color: selectedFoodCard == index
                        ? AppColors.black
                        : AppColors.white))
          ],
        ),
      ),
    );
  }
  Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
    return Container(
      height: 150,
      width: width* 0.34,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(offset: Offset(0,5), blurRadius: 10.0,color: Colors.grey[200])
          ]
      ),child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(imgPath,
        height: 150,
        width: width* 0.34,
        fit: BoxFit.fill,
      ),
    ),
    );
  }

}
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

void checkItemInCart(String shortInfoAsId, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsId)?
  Fluttertoast.showToast(msg: 'Item is already in cart')
      : addItemToCart(shortInfoAsId,context);}
addItemToCart(String shortInfoAsId, BuildContext context){
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsId);
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).
  updateData({EcommerceApp.userCartList: tempCartList}).then((v) { Fluttertoast.showToast(msg: 'Item added to Cart successfully');
  EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
  Provider.of<CartItemCounter>(context,listen: false).displayResult();
  });
}