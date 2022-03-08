import 'package:flutter/material.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:bachat_mart/assets/images.dart';
import 'package:bachat_mart/generated/l10n.dart';

class ItemBadge extends StatelessWidget {

  Widget child;
  OutOfStock? outOfStock;
  BadgeDiscounts? badgeDiscount;
  WidgetBadge? widgetBadge;
   ItemBadge({Key? key,required this.child,this.outOfStock,this.badgeDiscount,this.widgetBadge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        outOfStock!=null?outOfStock!:SizedBox.shrink(),
        badgeDiscount!=null?badgeDiscount!:SizedBox.shrink(),
        widgetBadge!=null?widgetBadge!:SizedBox.shrink()
      ],
    );
  }
}
class OutOfStock extends StatelessWidget {
  bool singleproduct;
   OutOfStock({Key? key,this.singleproduct= false,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(

        padding:
        EdgeInsets.only(left: 2.0, right: 2.0, top:10.0,),
        // color: Theme.of(context).accentColor,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.circular(3.0),
        //   color: Theme.of(context).buttonColor,
        // ),
        // constraints: BoxConstraints(
        //   //maxWidth: singleproduct ? 5.0 : 30.0,
        //   minHeight: 20,
        // ),
        child: Center(

          child:   Image.asset(Images.outofStock,height:45,width: 310,),
        ),
      ),
    );
  }
}
class BadgeDiscounts extends StatelessWidget {
  const BadgeDiscounts({
    Key? key,
     this.value ="0",
    this.color,
    this.textcolor ,
  }) : super(key: key);

  final String? value ;
  final Color? color;
  final Color? textcolor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: value!="0"?Container(
        padding: EdgeInsets.all(3.0),
        // color: Theme.of(context).accentColor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.0),
          ),
          color: color??Colors.transparent,
        ),
        constraints: BoxConstraints(
          minWidth: 26,
          minHeight: 16,
        ),
        child: Text(
          value! + S .of(context).off,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12,
              color: ColorCodes.darkgreen,
              fontWeight: FontWeight.bold
          ),
        ),
      ):SizedBox.shrink(),
    );
  }
}
class WidgetBadge extends StatelessWidget {
  bool isdisplay;
  Widget child;
   WidgetBadge({Key? key,this.isdisplay = false,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: isdisplay?child:SizedBox.shrink(),
    );
  }
}


