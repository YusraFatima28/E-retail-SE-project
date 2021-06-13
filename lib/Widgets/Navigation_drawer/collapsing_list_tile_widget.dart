

import 'package:e_shop/Colors.dart';
import 'package:flutter/material.dart';

class CollapsingListTile extends StatefulWidget {

  Color selectedColor = Colors.pinkAccent;//Color(0xFF4AC8EA);
  Color drawerBackgroundColor = AppColors.primary;//Color(0xFF272D34);
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  CollapsingListTile(
      {  @required this.title,
        @required this.icon,
        @required this.animationController,
        this.isSelected = false,
        this.onTap});
  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}
class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;
  TextStyle listTitleDefaultTextStyle = TextStyle(color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.w600);
  TextStyle listTitleSelectedTextStyle = TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);
  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 200, end: 70).animate(widget.animationController); //200, 70
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController); //10 , 0
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3) //0.3
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.isSelected ? Colors.pinkAccent : Colors.white,
              size: 38.0,
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                style: widget.isSelected
                    ? listTitleSelectedTextStyle
                    : listTitleDefaultTextStyle)
                : SizedBox( height: 40,),
           // Container()
          ],
        ),
      ),
    );
  }
}