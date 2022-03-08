import 'package:flutter/material.dart';
import 'package:bachat_mart/widgets/footer.dart';
import 'package:bachat_mart/widgets/productWidget/item_variation.dart';
import '../../assets/ColorCodes.dart';
import '../../rought_genrator.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import '../../widgets/header.dart';
import '../../components/ItemList/item_component.dart';
import '../../components/singleItemComponents/single_item_mobile.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/home_screen.dart';
import '../../screens/membership_screen.dart';
import '../../screens/signup_selection_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../../widgets/productWidget/item_detais_widget.dart';
import '../../widgets/productWidget/membership_info_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../models/newmodle/product_data.dart';
import '../../widgets/productWidget/product_info_widget.dart';
import '../../widgets/productWidget/product_sliding_image_widget.dart';
import '../login_web.dart';

class SingleItemWebComponent extends StatefulWidget {
  final Future<ItemModle>? similarProduct;
  final ItemData product;
  final String variationId;

  const SingleItemWebComponent({Key? key, this.similarProduct, required this.product,required this.variationId}) : super(key: key);


  @override
  _SingleItemWebComponentState createState() => _SingleItemWebComponentState();
}

class _SingleItemWebComponentState extends State<SingleItemWebComponent> with Navigations{
  int itemindex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _checkmembership = false;
  String page ="SingleProduct";

  @override
  Widget build(BuildContext context) {

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
print("similar products..."+widget.similarProduct.toString());
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorCodes.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Header(false),
            SizedBox(
              height: 20.0,
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: SlidingImage(productdata: widget.product,varid:widget.variationId,ontap: (){},)),
                      Expanded(
                        flex: 2,
                        child: Column(
                          //mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProductInfoWidget(itemdata: widget.product,varid:widget.variationId ,itemindexs:itemindex,ontap: (){
                              print("popup,,,,");
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(builder: (context, setState) {
                                      return  Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3.0)),
                                        child: Container(
                                          width: 800,
                                          //height: 200,
                                          padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                                          child:  ItemVariation(widget.product,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                                            //for changing color
                                            //  itemindex1 = i;
                                            setState(() {
                                              //for changing product price
                                              itemindex = i;
                                              print("apppp..."+itemindex.toString()+"index..");
                                              // Navigator.of(context).pop();
                                            });
                                          },)
                                        ),
                                      );
                                    });
                                  }).then((_) => setState(() { }));
                              // (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return StatefulBuilder(builder: (context, setState) {
                              //         return  Dialog(
                              //           shape: RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.circular(3.0)),
                              //           child: Container(
                              //             width: 800,
                              //             //height: 200,
                              //             padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                              //             child: ItemVariation(widget.product,ismember: VxState.store.userData.membership,selectedindex: widget.product.priceVariation!.indexWhere((element) => element.id == widget.variationId),onselect: (i){
                              //               setState(() {
                              //                 widget.product.priceVariation!.indexWhere((element) => element.id == widget.variationId) == i;
                              //                 // Navigator.of(context).pop();
                              //               });
                              //             },),
                              //           ),
                              //         );
                              //       });
                              //     })
                              //     .then((_) => setState(() { }))
                              //     :showModalBottomSheet<dynamic>(
                              //     isScrollControlled: true,
                              //     context: context,
                              //     builder: (context) {
                              //       return ItemVariation(widget.product,ismember: VxState.store.userData.membership,selectedindex: widget.product.priceVariation!.indexWhere((element) => element.id == widget.variationId),onselect: (i){
                              //         setState(() {
                              //           widget.product.priceVariation!.indexWhere((element) => element.id == widget.variationId) == i;
                              //           // Navigator.of(context).pop();
                              //         });
                              //       },);
                              //     })
                              //     .then((_) => setState(() { }));
                            },),
                            if(Features.isMembership)
                              MembershipInfoWidget(itemdata: widget.product,varid:widget.variationId ,itemindexs:itemindex,ontap:(){
                                (!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                // _dialogforSignIn() :
                                LoginWeb(context,result: (sucsess){
                                  if(sucsess){
                                    Navigator.of(context).pop();
                                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                                    /*Navigator.pushNamedAndRemoveUntil(
                                        context, HomeScreen.routeName, (route) => false);*/
                                  }else{
                                    Navigator.of(context).pop();
                                  }
                                })
                                    :
                                (!PrefUtils.prefs!.containsKey("apikey") && !Vx.isWeb)?
                                /*Navigator.of(context).pushReplacementNamed(
                                    SignupSelectionScreen.routeName)*/
                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.PushReplacment)
                                    :/*Navigator.of(context).pushNamed(
                                  MembershipScreen.routeName,
                                );*/
                                Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                              }),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                            return  snapshot.data!.data!.length > 0?Container(
                              width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width,
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
                                      (Features.isSubscription)?410:310 :
                                      ResponsiveLayout.isMediumScreen(context) ?
                                      (Features.isSubscription)?380:350 : (Features.isSubscription)?400:380,

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
                            ):SizedBox.shrink();
                      }
                    },
                  ),

                  if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
