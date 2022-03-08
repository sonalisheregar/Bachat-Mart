import 'package:flutter/material.dart';
import '../../helper/custome_checker.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../models/newmodle/product_data.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';

class MembershipInfoWidget extends StatelessWidget {
  var _checkmembership = false;
  final ItemData itemdata;
  late int itemindex;
  final int itemindexs;
  final Function() ontap;
   MembershipInfoWidget({Key? key,required this.itemdata,required String varid, required this.itemindexs, required this.ontap}){
     this.itemindex = itemdata.priceVariation!.indexWhere((element) => element.id == varid);
   }

  List<CartItem> productBox = /*Hive.box<Product>(productBoxName)*/(VxState.store as GroceStore).CartItemList;

  @override
  Widget build(BuildContext context)  {
print("member");

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?30:0),
        child: Column(
          children: [
            if(Features.isMembership  && double.parse(itemdata.priceVariation![itemindexs].membershipPrice.toString()) > 0)
              Row(
                children: [
                  !_checkmembership
                      ? itemdata.priceVariation![itemindexs].membershipDisplay!
                      ? GestureDetector(
                    onTap: () {
                      ontap();

                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 5,),
                      height: 35,
                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                      MediaQuery.of(context).size.width / 2.03:(MediaQuery.of(context)
                          .size
                          .width) -
                          20 ,
                      decoration: BoxDecoration(
                          color: ColorCodes.membershipColor),
                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Image.asset(
                            Images.starImg,
                            height: 12,
                          ),
                          SizedBox(width: 2),
                          Text(
                              Features.iscurrencyformatalign ?
                              itemdata.priceVariation![itemindexs].membershipPrice
                                  .toString() + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  itemdata.priceVariation![itemindexs]
                                      .membershipPrice.toString(),
                              style: TextStyle(
                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 11 : 12,)),
                          Spacer(),
                          Icon(
                            Icons.lock,
                            color: Colors.black,
                            size: 10,
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.black,
                            size: 10,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  )
                      : SizedBox.shrink()
                      : SizedBox.shrink(),
                ],
              ),
            !_checkmembership
                ? itemdata.priceVariation![itemindexs].membershipDisplay!
                ? SizedBox(
              height: 1,
            )
                : SizedBox(
              height: 1,
            )
                : SizedBox(
              height: 1,
            ),
          ],
        ),
      );
    }
  }

