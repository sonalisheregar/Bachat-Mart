

import 'package:flutter/material.dart';
import 'package:bachat_mart/widgets/footer.dart';
import '../../rought_genrator.dart';
import '../../utils/prefUtils.dart';
import '../../assets/ColorCodes.dart';
import '../../components/ItemList/item_component.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../widgets/custome_stepper.dart';
import '../../widgets/productWidget/item_detais_widget.dart';
import '../../widgets/productWidget/membership_info_widget.dart';
import '../../widgets/productWidget/product_info_widget.dart';
import '../../widgets/productWidget/product_sliding_image_widget.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/productWidget/item_variation.dart';

import '../login_web.dart';

class SingleItemMobileComponent extends StatefulWidget {
  final Future<ItemModle>? similarProduct;
  final ItemData product;
  final String variationId;
  final bool iphonex = false;

  const SingleItemMobileComponent({Key? key, this.similarProduct, required this.product,required this.variationId, required bool iphonex}) : super(key: key);

  @override
  _SingleItemMobileComponentState createState() => _SingleItemMobileComponentState();
}

class _SingleItemMobileComponentState extends State<SingleItemMobileComponent> with Navigations{
  int itemindex = 0;
  int itemindex1 = 0;
  String page ="SingleProduct";
  var _checkmembership = false;


  @override
  Widget build(BuildContext context,) {
    if ((VxState.store as GroceStore).userData.membership=="1") {
      setState(() {
        _checkmembership = true;
      });
    } else {
      setState(() {
        _checkmembership = false;
      });
      for (int i = 0; i < (VxState.store as GroceStore).CartItemList.length; i++) {
        if ((VxState.store as GroceStore).CartItemList[i].mode == "1") {
          setState(() {
            _checkmembership = true;
          });
        }
      }
    }
   print("sp,,,"+Features.isMembership.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      key: Key("single_mobile"),
      body: SafeArea(
        child:
        SingleChildScrollView(
          child:
          Column(
            children: <Widget>[
              SlidingImage(productdata: widget.product,varid:widget.variationId,ontap: (){},),
               ProductInfoWidget(itemdata: widget.product,varid:widget.variationId,itemindexs:itemindex,ontap: (){},),
              if(Features.isMembership)
                MembershipInfoWidget(itemdata: widget.product,varid:widget.variationId ,itemindexs:itemindex,ontap:(){
                  (!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                  // _dialogforSignIn() :
                  LoginWeb(context,result: (sucsess){
                    if(sucsess){
                      Navigator.of(context).pop();
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                     /* Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);*/
                    }else{
                      Navigator.of(context).pop();
                    }
                  })
                      :
                  (!PrefUtils.prefs!.containsKey("apikey") && !Vx.isWeb)?
                 /* Navigator.of(context).pushReplacementNamed(
                      SignupSelectionScreen.routeName)*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                      :/*Navigator.of(context).pushNamed(
                    MembershipScreen.routeName,
                  );*/
                  Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                }),//TODO:Add Variation Widget
              ItemVariation(widget.product,ismember: _checkmembership,selectedindex: itemindex,page:page,onselect: (i){
                //for changing color
                itemindex1 = i;
               setState(() {
                 //for changing product price
                  itemindex = i;
                  print("apppp..."+itemindex.toString()+"index.."+itemindex1.toString());
                  // Navigator.of(context).pop();
                });
              },),
              ItemDetailsWidget(itmdata: widget.product,ontap: (){},),
              if(widget.similarProduct!=null)
              FutureBuilder<ItemModle>(
                future: widget.similarProduct, // async work
                builder: (BuildContext context, AsyncSnapshot<ItemModle> snapshot) {
                  switch (snapshot.connectionState) {

                    case ConnectionState.waiting:
                      return  SingelItemOfList();
                  // TODO: Handle this case.

                    default:
                    // TODO: Handle this case.
                      if (snapshot.hasError)
                        return SizedBox.shrink();
                      else

                        return
                          snapshot.data!.data!.length > 0?
                          Container(
                          width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                          //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                          padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
                          color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/ColorCodes.whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:10.0,right:10),
                                child: Text(
                                  snapshot.data!.label!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveLayout.isSmallScreen(context) ?
                                  (Features.isSubscription)?392:310 :
                                  ResponsiveLayout.isMediumScreen(context) ?
                                  (Features.isSubscription)?350:360 : (Features.isSubscription)?380:380,

                                  // height: (Vx.isWeb)?380:360,
                                  child: new ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.data!.length,
                                    itemBuilder: (_, i) => Column(
                                      children: [
                                        Itemsv2(
                                          "Forget",
                                          snapshot.data!.data![i],
                                          (VxState.store as GroceStore).userData,
                                          //sellingitemData.items[i].brand,
                                        ),  /* Itemsv2(
                                                        "Forget",
                                                        snapshot.data.data[i],
                                                        (VxState.store as GroceStore).userData,
                                                        //sellingitemData.items[i].brand,
                                                      ),*/
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ):
                        SizedBox.shrink();
                  }
                },
              ),
              if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ),
        ),
      ),
      bottomNavigationBar:/*(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? SizedBox.shrink():
      BuildBottomNavigationBar(widget.product,widget.variationId,widget.iphonex),*/
      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? SizedBox.shrink():
      Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: widget.iphonex ? 16.0 : 5.0),
          child:BuildBottomNavigationBar(widget.product,widget.variationId,widget.iphonex,itemindex),
        ),
      ),
    );
  }
}
BuildBottomNavigationBar(ItemData product,String VariationId,bool iphonex,int itemindex) {
  print("DISPLAYING BOTTEM NAVIGATION BAR");
  // singleitemData = Provider.of<ItemsList>(context, listen: false);

 return CustomeStepper(priceVariation:product.priceVariation![/*product.priceVariation!.indexWhere((element) => element.id==VariationId)*/itemindex],itemdata: product,alignmnt: StepperAlignment.Horizontal,height:(Features.isSubscription)?40:60);
}