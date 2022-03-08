import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:bachat_mart/constants/features.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import '../assets/images.dart';

class OrderhistoryDisplay extends StatefulWidget {
  final String itemname;
  final String varname;
  final String price;
  final String qty;
  final String subtotal;
  final String itemImage;
  final String extraAmount;

  OrderhistoryDisplay(
      this.itemname,
      this.varname,
      this.price,
      this.qty,
      this.subtotal,
      this.itemImage,
      this.extraAmount,
      );

  @override
  _OrderhistoryDisplayState createState() => _OrderhistoryDisplayState();
}

class _OrderhistoryDisplayState extends State<OrderhistoryDisplay> {
  var extraAmount;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Theme.of(context).buttonColor),
      child:
        Row(
          children: [
            Container(
                child:widget.extraAmount == "888"? Image.asset(Images.membershipImg,
                  color: Theme.of(context).primaryColor,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ): CachedNetworkImage(
                  imageUrl: widget.itemImage,
                  placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    widget.itemname,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5,),
                Text(widget.varname, style: TextStyle(color: ColorCodes.skygrey,fontSize: 9),),
                SizedBox(height: 5,),
                Text( S .of(context).qty
                  //"Qty:"
                      +" " +widget.qty, style: TextStyle(color: ColorCodes.skygrey,fontSize: 9),),
                SizedBox(height: 5,),
                Text( S .of(context).price
                 // "Price:"
                    +" " +double.parse(widget.price).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), style: TextStyle(color: ColorCodes.skygrey,fontSize: 9),),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  Features.iscurrencyformatalign?
                  double.parse(widget.subtotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                  IConstants.currencyFormat + " " + double.parse(widget.subtotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
        ],
        ),

    );
  }
}