import 'package:flutter/material.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:bachat_mart/assets/images.dart';
import 'package:bachat_mart/constants/IConstants.dart';
import 'package:bachat_mart/constants/features.dart';
import 'package:bachat_mart/generated/l10n.dart';
import 'package:bachat_mart/helper/custome_calculation.dart';
import 'package:bachat_mart/helper/custome_checker.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/models/newmodle/product_data.dart';
import 'package:bachat_mart/utils/ResponsiveLayout.dart';
import 'package:bachat_mart/widgets/custome_stepper.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductInfoWidget extends StatelessWidget {
  final ItemData itemdata;
  late int itemindex;
  final int itemindexs;
  Function() ontap;
  ProductInfoWidget({Key? key,required this.itemdata,required String varid,required this.itemindexs,required this.ontap}){
     this.itemindex = itemdata.priceVariation!.indexWhere((element) => element.id == varid);
   }

  @override
  Widget build(BuildContext context) {
    var _checkmembership = false;
    print("express ..."+VxState.store.userData.membership!.toString());
    if ((VxState.store as GroceStore).userData.membership! == "1") {
        _checkmembership = true;

    } else {
        _checkmembership = false;
      for (int i = 0; i < (VxState.store as GroceStore).CartItemList.length; i++) {
        if ((VxState.store as GroceStore).CartItemList[i].mode == "1") {
            _checkmembership = true;
        }
      }
    }
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?35:0),
      child: Container(
        width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
        MediaQuery.of(context).size.width / 2.03:(MediaQuery.of(context)
            .size
            .width) -
            20 ,
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical:3.0,horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:0),
              child: Row(
                children: [
                  ///Show Brands
                  Text(
                    itemdata.brand.toString(),
                    style: TextStyle(
                      fontSize: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?20:12,
                      fontWeight: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?FontWeight.bold:FontWeight.normal,
                    ),
                  ),
                  Spacer(),
                  ///Show margin
                  if (Calculate().getmargin(itemdata.priceVariation![itemindexs].mrp,
                      VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                      itemdata.priceVariation![itemindexs].discointDisplay! ? itemdata.priceVariation![itemindexs].price : itemdata.priceVariation![itemindexs].mrp
                          : itemdata.priceVariation![itemindexs].membershipDisplay!? itemdata.priceVariation![itemindexs].membershipPrice: itemdata.priceVariation![itemindexs].price)>0)
                    Container(
                      //margin: EdgeInsets.only(right:5.0),
                      padding: EdgeInsets.all(3.0),
                      // color: Theme.of(context).accentColor,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(3.0),
                        color: /*Color(0xff6CBB3C)*/Colors.transparent,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 28,
                        minHeight: 18,
                      ),
                      child: Text(
                        Calculate().getmargin(itemdata.priceVariation![itemindexs].mrp,
                            VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                            itemdata.priceVariation![itemindexs].discointDisplay! ? itemdata.priceVariation![itemindexs].price : itemdata.priceVariation![itemindexs].mrp
                                : itemdata.priceVariation![itemindexs].membershipDisplay!? itemdata.priceVariation![itemindexs].membershipPrice: itemdata.priceVariation![itemindexs].price).toStringAsFixed(2) + S .current.off,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color:ColorCodes.darkgreen,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 3.0,horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Show Product Name
                      Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                          SizedBox(height: 10,):SizedBox.shrink(),
                      Text(
                        itemdata.itemName.toString(),
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?16:17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                      SizedBox(
                        height: 20.0,
                      ):
                      SizedBox(
                        height: 10.0,
                      ),
                      /// Show Product Price
                      Row(
                        children: [
                          if(Features.isMembership)
                            (_checkmembership)?Container(
                              width: 10.0,
                              height: 9.0,
                              margin: EdgeInsets.only(right: 3.0),
                              child: Image.asset(
                                Images.starImg,
                                color: ColorCodes.starColor,
                              ),
                            ):SizedBox.shrink(),
                          RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())

                                new TextSpan(
                                    text: Features.iscurrencyformatalign?
                                    '${Check().checkmembership()?itemdata.priceVariation![itemindexs].membershipPrice:itemdata.priceVariation![itemindexs].price} ' + IConstants.currencyFormat:
                                    IConstants.currencyFormat + '${Check().checkmembership()?itemdata.priceVariation![itemindexs].membershipPrice:itemdata.priceVariation![itemindexs].price} ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                                new TextSpan(
                                    text: itemdata.priceVariation![itemindexs].price!=itemdata.priceVariation![itemindexs].mrp?
                                    Features.iscurrencyformatalign?
                                    '${itemdata.priceVariation![itemindexs].mrp} ' + IConstants.currencyFormat:
                                    IConstants.currencyFormat + '${itemdata.priceVariation![itemindexs].mrp} ':"",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      decoration:
                                      TextDecoration.lineThrough,
                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        S .current.inclusive_of_all_tax,
                        style: TextStyle(
                            fontSize: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?12:8, color: Colors.grey),
                      )
                    ],
                  ),
                  ///Show Loyalty
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(Features.isLoyalty)
                        if(double.parse(itemdata.priceVariation![itemindexs].loyalty.toString()) > 0)
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(Images.coinImg,
                                  height: 15.0,
                                  width: 20.0,),
                                SizedBox(width: 4),
                                Text(itemdata.priceVariation![itemindexs].loyalty.toString()),

                              ],
                            ),
                          ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (itemdata.eligibleForExpress == "0") ?
                      Image.asset(Images.express,
                        height: 20.0,
                        width: 25.0,):
                      SizedBox.shrink(),
                    ],
                  )

                ],
              ),
            ),
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            Row(
              children: [
                Container(
                  //width: (MediaQuery.of(context).size.width / 7) ,
                  padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                  child: ( itemdata.priceVariation!.length > 1)
                      ?
                  GestureDetector(
                    onTap: () {
                      ontap();

                    },
                    child: Container(
                      height: 30,
                      width: (MediaQuery.of(context).size.width / 7),
                      decoration: BoxDecoration(
                        /*border: Border.all(
                                          color: ColorCodes.greenColor,),*/
                          color: ColorCodes.varcolor,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            bottomLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                            bottomRight: const Radius.circular(2.0),
                          )),
                      child: Row(
                        children: [
                          Text(

                            "${itemdata.priceVariation![itemindexs].variationName}"+" "+"${itemdata.priceVariation![itemindexs].unit}",
                            style:
                            TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                          ),
                          // ),
                          Spacer(),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: ColorCodes.varcolor,
                                borderRadius: new BorderRadius.only(
                                  topRight:
                                  const Radius.circular(2.0),
                                  bottomRight:
                                  const Radius.circular(2.0),
                                )),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color:ColorCodes.darkgreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      /* border: Border.all(
                                  color: ColorCodes.greenColor,),*/
                        color: ColorCodes.varcolor,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
                          bottomLeft: const Radius.circular(2.0),
                          bottomRight: const Radius.circular(2.0),
                        )),
                    height: 30,
                    width: (MediaQuery.of(context).size.width / 7),
                    padding: EdgeInsets.fromLTRB(5.0, 4.5, 0.0, 4.5),
                    child: Text(
                      "${itemdata.priceVariation![itemindexs].variationName}"+" "+"${itemdata.priceVariation![itemindexs].unit}",
                      style:
                      TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/7,
                        child: CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],
                        itemdata: itemdata,alignmnt: StepperAlignment.Vertical,height:(Features.isSubscription)?90:60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
