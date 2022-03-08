import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bachat_mart/components/login_web.dart';
import 'package:bachat_mart/helper/custome_checker.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/models/sellingitemsfields.dart';
import 'package:bachat_mart/utils/ResponsiveLayout.dart';
import 'package:bachat_mart/utils/facebook_app_events.dart';
import 'package:bachat_mart/utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/newmodle/cartModle.dart';
import '../../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../constants/features.dart';
import '../controller/mutations/cart_mutation.dart';
import '../generated/l10n.dart';
import '../models/newmodle/product_data.dart';
import '../providers/branditems.dart';

import 'package:provider/provider.dart';

import '../rought_genrator.dart';

enum StepperAlignment{
  Vertical,Horizontal
}

class CustomeStepper extends StatefulWidget {
  PriceVariation? priceVariation;
  String? from;
  ItemData? itemdata;
  bool? checkmembership;
  bool subscription;
  StepperAlignment alignmnt;
  final double fontSize;
  final double height;
  final double width;

  CustomeStepper({Key? key,this.priceVariation,this.itemdata,this.from,this.checkmembership,this.subscription = false,this.alignmnt = StepperAlignment.Vertical,this.fontSize = 12,required this.height ,this.width = double.infinity}) : super(key: key);

  @override
  State<CustomeStepper> createState() => _CustomeStepperState();
}

class _CustomeStepperState extends State<CustomeStepper> with Navigations {

  bool loading = false;
  //var _checkmembership = false;
  bool _isNotify = false;
  List<CartItem> productBox=[];
  List<Widget> stepperButtons = [];
  final item =(VxState.store as GroceStore).CartItemList;
  @override
  Widget build(BuildContext context) {

    updateCart(int qty,CartStatus cart,String varid){
      //debugPrint("decrement"+qty.toString());
      switch(cart){
        case CartStatus.increment:
          print("qunty and stock"+qty.toString()+"...."+widget.priceVariation!.stock.toString()+",,,"+widget.priceVariation!.maxItem.toString());
          // if(qty <double.parse(widget.priceVariation!.stock.toString())) {
          //   if(qty <double.parse(widget.priceVariation!.maxItem.toString())) {
          //     cartcontroller.update((done) {
          //       print("done value in calling update " + done.toString());
          //       setState(() {
          //         loading = !done;
          //         print("value of loading in update cart increment case: " +
          //             loading.toString());
          //       });
          //     }, price: widget.priceVariation!.price.toString(),
          //         quantity: (qty + 1).toString(),
          //         var_id: varid);
          // }else {
          //     Fluttertoast.showToast(
          //         msg:
          //         S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
          //         fontSize: MediaQuery.of(context).textScaleFactor *13,
          //         backgroundColor: Colors.black87,
          //         textColor: Colors.white);
          //   }
          // }else{
          //   Fluttertoast.showToast(
          //       msg: S
          //           .of(context)
          //           .sorry_outofstock, //"Sorry, Out of Stock!",
          //       fontSize: MediaQuery
          //           .of(context)
          //           .textScaleFactor * 13,
          //       backgroundColor: Colors.black87,
          //       textColor: Colors.white);
          // }

          List<SellingItemsFields> list = [];
          item.forEach((element) {
            debugPrint("ggggg....22..." + element.itemId.toString() + "..." + widget.itemdata!.id.toString()+".."+element.quantity!);
            if(element.itemId== widget.itemdata!.id) {
              //fetchItemData = Provider.of<ItemsList>(context, listen: false).fetchItems();
              for(int i = 0; i < widget.itemdata!.priceVariation!.length; i++){
                if(widget.itemdata!.priceVariation![i].id == element.varId) {
                  list.add(SellingItemsFields(weight: double.parse(widget.itemdata!.priceVariation![i].weight!),varQty:int.parse(element.quantity.toString())));}
              }
            }
          });
          print("increment to : ${widget.priceVariation!.minItem}....${widget.priceVariation!.maxItem}");
          print("increment to : ${widget.priceVariation!.quantity}....${widget.priceVariation!.stock}");
          if (Features.btobModule?Check().isOutofStock(widget.priceVariation!, double.parse(widget.priceVariation!.stock.toString()),widget.itemdata!.type!,qty.toString())
              :Check().isOutofStock(widget.priceVariation!, double.parse(widget.priceVariation!.stock.toString()),
              widget.itemdata!.type!,qty.toString(),/*widget.itemdata!*/ list)) {
            Fluttertoast.showToast(
                msg: S.of(context).sorry_outofstock,//"Sorry, Out of Stock!",
                fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
          } else {
            if (qty < double.parse(widget.priceVariation!.maxItem!)) {
              cartcontroller.update((done) {
                      print("done value in calling update " + done.toString());
                      setState(() {
                        loading = !done;
                        print("value of loading in update cart increment case: " +
                            loading.toString());
                      });
                    }, price: widget.priceVariation!.price.toString(),
                        quantity: (qty + 1).toString(),
                        var_id: varid);
            } else {
              Fluttertoast.showToast(
                  msg:
                  S.of(context).cant_add_more_item,//"Sorry, you can\'t add more of this item!",
                  fontSize: MediaQuery.of(context).textScaleFactor *13,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white);
            }
          }
          // TODO: Handle this case.
          break;
        case CartStatus.remove:
          cartcontroller.update((done){
            setState(() {
              loading = !done;
              print("value of loading in remove cart remove case: "+loading.toString());
            });
          },price: widget.priceVariation!.price.toString(),quantity:"0",var_id: varid);
          // TODO: Handle this case.
          break;
        case CartStatus.decrement:
          cartcontroller.update((done){
            setState(() {
              loading = !done;
              print("value of loading in decrement cart decrement case: "+loading.toString());
            });
          },price: widget.priceVariation!.price.toString(),quantity:((qty)<= int.parse(widget.priceVariation!.minItem!))?"0":(qty-1).toString(),var_id: varid);
          // TODO: Handle this case.
          break;
      }
    }
    addToCart() async {
      debugPrint("add to cart......");
      cartcontroller.addtoCart(widget.priceVariation!,widget.itemdata!,(isloading){
        setState(() {
          debugPrint("add to cart......1");
          loading = isloading;
          print("value of loading in add cart fn "+loading.toString());
        });
      });
      if(Features.isfacebookappevent)
        FaceBookAppEvents.facebookAppEvents.logAddToCart(id: int.parse(widget.itemdata!.id!).toString(), type: widget.itemdata!.itemName!, currency: IConstants.currencyFormat, price: double.parse(widget.priceVariation!.price.toString()));
    }

    _notifyMe() async {
      setState(() {
        _isNotify = true;
      });
      //_notifyMe();
      debugPrint("resposne........1");
      int resposne = await Provider.of<BrandItemsList>(context, listen: false).notifyMe(widget.itemdata!.id.toString(),widget.priceVariation!.id.toString(),widget.itemdata!.type!);
      debugPrint("resposne........"+resposne.toString());
      if(resposne == 200) {
        setState(() {
          _isNotify = false;
        });
        //_isWeb?_Toast("You will be notified via SMS/Push notification, when the product is available"):
        Fluttertoast.showToast(msg: S .of(context).you_will_notify,//"You will be notified via SMS/Push notification, when the product is available" ,
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor:
            Colors.black87,
            textColor: Colors.white);

      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong" ,
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor:
            Colors.black87,
            textColor: Colors.white);
        setState(() {
          _isNotify = false;
        });
      }
    }

    return VxBuilder(
        mutations: {SetCartItem},
        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context,GroceStore store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          // if(loading){
          //   print("inside loading");
          //   stepperButtons.clear();
          //stepperButtons.add(Loading(context));
          // stepperButtons.add(Expanded(
          //     flex: 1,
          //     child: SizedBox.shrink())) ;
          // }else{
          stepperButtons.clear();
          if (widget.priceVariation!.stock! <= 0){
            stepperButtons.add(NotificationStepper(
                context, alignmnt: widget.alignmnt,
                fontsize: widget.fontSize,
                onTap: () {

                  if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    LoginWeb(context,result: (sucsess){
                      if(sucsess){
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                        /* Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);*/
                      }else{
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  else{
                    if (!PrefUtils.prefs!.containsKey("apikey")) {
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                    }
                    else {
                      _notifyMe();
                    }
                  }
                }, isnotify: _isNotify));
        }
            else{
              if(widget.alignmnt == StepperAlignment.Vertical) {
                stepperButtons.add(AddSubsciptionStepper(
                    context, itemdata: widget.itemdata!,
                    alignmnt: widget.alignmnt,
                    fontsize: widget.fontSize,
                    onTap: () {

                      if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                        LoginWeb(context,result: (sucsess){
                          if(sucsess){
                            Navigator.of(context).pop();
                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                            /* Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);*/
                          }else{
                            Navigator.of(context).pop();
                          }
                        });
                      }
                      else{
                        if (!PrefUtils.prefs!.containsKey("apikey")) {
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                        }
                        else {
                          Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                              qparms: {
                                "itemid": widget.itemdata!.id,
                                "itemname": widget.itemdata!.itemName,
                                "itemimg": widget.itemdata!.itemFeaturedImage,
                                "varname": widget.itemdata!.priceVariation![0].variationName !+ widget.itemdata!.priceVariation![0].unit!,
                                "varmrp":widget.itemdata!.priceVariation![0].mrp.toString(),
                                "varprice":  (VxState.store as GroceStore).userData.membership=="1" ? widget.itemdata!.priceVariation![0].membershipPrice.toString()
                                    :widget.itemdata!.priceVariation![0].discointDisplay! ?widget.itemdata!.priceVariation![0].price.toString()
                                    :widget.itemdata!.priceVariation![0].mrp.toString(),
                                "paymentMode": widget.itemdata!.paymentMode,
                                "cronTime": widget.itemdata!.subscriptionSlot![0].cronTime,
                                "name": widget.itemdata!.subscriptionSlot![0].name,
                                "varid":widget.itemdata!.priceVariation![0].id,
                                "brand": widget.itemdata!.brand
                              });
                        }
                      }


                    }));
                if (box
                    .where((element) =>
                element.varId == widget.priceVariation!.id)
                    .length <= 0 || int.parse(box
                    .where((element) =>
                element.varId == widget.priceVariation!.id).first.quantity!) <= 0)
                  stepperButtons.add(AddItemSteppr(
                      context, fontSize: widget.fontSize,alignmnt: widget.alignmnt, onTap: () {
                    addToCart();
                  }, isloading: loading));
                else
                  stepperButtons.add(
                      UpdateItemSteppr(context, quantity: int.parse(box.where((element) => element.varId == widget.priceVariation!.id).first.quantity!),
                          fontSize: widget.fontSize,
                          onTap: (cartStatus) {
                            updateCart(int.parse(box
                                .where((element) =>
                            element.varId == widget.priceVariation!.id)
                                .first
                                .quantity!), cartStatus,
                                widget.priceVariation!.id!);
                          },alignmnt: widget.alignmnt,isloading: loading));
              }
              else{
                if (box.where((element) => element.varId == widget.priceVariation!.id).length <= 0 || int.parse(box.where((element) => element.varId == widget.priceVariation!.id).first.quantity!) <= 0)
                  stepperButtons.add(AddItemSteppr(
                      context, fontSize: widget.fontSize,alignmnt: widget.alignmnt,onTap: () {
                    addToCart();
                  },isloading: loading));
                else
                  stepperButtons.add(
                      UpdateItemSteppr(context, quantity: int.parse(box
                          .where((element) =>
                      element.varId == widget.priceVariation!.id)
                          .first
                          .quantity!),
                          fontSize: widget.fontSize,
                          onTap: (cartStatus) {
                            updateCart(int.parse(box
                                .where((element) =>
                            element.varId == widget.priceVariation!.id)
                                .first
                                .quantity!), cartStatus,
                                widget.priceVariation!.id!);
                          },alignmnt: widget.alignmnt,isloading: loading));

                stepperButtons.add(AddSubsciptionStepper(
                    context, itemdata: widget.itemdata!,
                    alignmnt: widget.alignmnt,
                    fontsize: widget.fontSize,
                    onTap: () {
                      if(!PrefUtils.prefs!.containsKey("apikey") &&Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                        LoginWeb(context,result: (sucsess){
                          if(sucsess){
                            Navigator.of(context).pop();
                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                            /* Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);*/
                          }else{
                            Navigator.of(context).pop();
                          }
                        });
                      }
                      else{
                        if (!PrefUtils.prefs!.containsKey("apikey")) {
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);

                        }
                        else {
                          Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                              qparms: {
                                "itemid": widget.itemdata!.id,
                                "itemname": widget.itemdata!.itemName,
                                "itemimg": widget.itemdata!.itemFeaturedImage,
                                "varname": widget.itemdata!.priceVariation![0].variationName !+ widget.itemdata!.priceVariation![0].unit!,
                                "varmrp":widget.itemdata!.priceVariation![0].mrp.toString(),
                                "varprice":  (VxState.store as GroceStore).userData.membership=="1" ? widget.itemdata!.priceVariation![0].membershipPrice.toString()
                                    :widget.itemdata!.priceVariation![0].discointDisplay! ?widget.itemdata!.priceVariation![0].price.toString()
                                    :widget.itemdata!.priceVariation![0].mrp.toString(),
                                "paymentMode": widget.itemdata!.paymentMode,
                                "cronTime": widget.itemdata!.subscriptionSlot![0].cronTime,
                                "name": widget.itemdata!.subscriptionSlot![0].name,
                                "varid":widget.itemdata!.priceVariation![0].id,
                                "brand": widget.itemdata!.brand
                              });
                        }
                      }


                    }));
              }

            }
          //}
          print("height"+widget.height.toString());
          return widget.alignmnt == StepperAlignment.Vertical
              ? SizedBox(
               //height: widget.priceVariation!.stock!<=0?33:widget.height,
              height: widget.height,
              width: widget.width,
              child:Column(
                children: stepperButtons,
              ))
              : Container(
              height: widget.height,
              width: widget.width,
              child:
              Row(
                children: stepperButtons,

              ));
        });
  }
}

Widget Loading(BuildContext context) {
  return  Container(
      decoration: BoxDecoration(color: (Features.isSubscription)? ColorCodes.whiteColor:ColorCodes.whiteColor,),
      height: 30,
      child: Center(
        child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: new CircularProgressIndicator(
              color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome :IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
              strokeWidth: 2.0,
              valueColor: new AlwaysStoppedAnimation<Color>(/*Theme.of(context).primaryColor*/(Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome :IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome),
            )
        ),
      ),
    );
}

Widget AddItemSteppr(BuildContext context,{required double fontSize,required Function() onTap, required StepperAlignment alignmnt, isloading}) {
  debugPrint("testing..." + isloading.toString());
  return (Features.isSubscription)?
  Expanded(
    flex: 1,
    child: GestureDetector(
      onTap: ()=>onTap(),
      child: Padding(
        padding: EdgeInsets.only(/*left:alignmnt == StepperAlignment.Horizontal?10:0,*/bottom: alignmnt == StepperAlignment.Vertical?10:0),
        child: Container(
          height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:30.0,
          decoration: new BoxDecoration(
              color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome :IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
              borderRadius:
              new BorderRadius
                  .all(
                const Radius.circular(
                    2.0),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isloading?
              /*CircularProgressIndicator(
                color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                strokeWidth: 2.0,
                valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),
              )*/ Center(
                child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: new CircularProgressIndicator(
                      color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                      strokeWidth: 2.0,
                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),
                    )
                ),
              )
                  : Text(
                S.current.buy_once,
                style:
                TextStyle(
                    color: ColorCodes.whiteColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold
                ),

                textAlign:
                TextAlign
                    .center,
              ),
            ],
          ),
        ),
      ),
    ),
  )
      :Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: ()=>onTap(),
        child: Padding(
          padding: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?20:0,bottom: alignmnt == StepperAlignment.Vertical?10:0),
          child: Container(
            height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:40.0,
            // margin:  EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.only(left:8),
            decoration: BoxDecoration(
                color:IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                borderRadius:
                new BorderRadius.all(const Radius.circular(2.0))
            ),
            child:
            isloading?
            /*CircularProgressIndicator(
                color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                strokeWidth: 2.0,
                valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),
              )*/ Center(
              child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: new CircularProgressIndicator(
                    color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.primaryColor,
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),
                  )
              ),
            )
                :Row(
              children: [

                Text(
                  S.current.add,//'ADD',
                  style: TextStyle(
                      color: Theme.of(context)
                          .buttonColor,
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Container(
                  height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:40.0,
                  width: 25,
                  decoration: BoxDecoration(
                    color:IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.maphome,

                  ),
                  child: Icon(
                    Icons.add,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
  );
}

Widget UpdateItemSteppr(BuildContext context,{required int quantity,required double fontSize,required Function(CartStatus) onTap,required StepperAlignment alignmnt,isloading}) {

  return  Expanded(
    flex: 1,
      child: Container(
        height: (Features.isSubscription)?40:30,
        padding: EdgeInsets.only(/*left:alignmnt == StepperAlignment.Horizontal?10:0,*/top:alignmnt == StepperAlignment.Vertical?Features.isSubscription?0:20:0,bottom: alignmnt == StepperAlignment.Vertical?10:0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () =>onTap(CartStatus.decrement),
              child: Container(
                  width: alignmnt == StepperAlignment.Vertical?40:35,
                  height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?33:40:30,
                  decoration:
                  new BoxDecoration(
                      color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/ IConstants.isEnterprise?Theme.of(context).primaryColor:ColorCodes.maphome:IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                      // border: Border
                      //     .all(
                      //   color:(Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.cartgreenColor,
                      // ),
                      borderRadius:
                      new BorderRadius.only(
                        bottomLeft:
                        const Radius.circular(2.0),
                        topLeft:
                        const Radius.circular(2.0),
                      )),
                  child: Center(
                    child:
                    Text(
                      "-",
                      textAlign:
                      TextAlign
                          .center,
                      style:
                      TextStyle(
                        color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.whiteColor,
                      ),
                    ),
                  )),
            ),
            Expanded(
              child:(isloading)? Loading(context)
              :Container(
                  decoration:
                  BoxDecoration(
                    color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.whiteColor,
                  ),
                  height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:30,
                  child: Center(
                    child: Text(
                      quantity.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome :IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.maphome,
                      ),
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () =>onTap(CartStatus.increment),
              child: Container(
                  width: alignmnt == StepperAlignment.Vertical?40:35,
                  height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?33:40:30,
                  decoration:
                  new BoxDecoration(
                      color: (Features.isSubscription)?/*ColorCodes.subscribeColor*/ IConstants.isEnterprise?Theme.of(context).primaryColor:ColorCodes.maphome:IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                      // border: Border
                      //     .all(
                      //   color:(Features.isSubscription)?ColorCodes.primaryColor :ColorCodes.cartgreenColor,
                      // ),
                      borderRadius:
                      new BorderRadius.only(
                        bottomRight:
                        const Radius.circular(2.0),
                        topRight:
                        const Radius.circular(2.0),
                      )),
                  child: Center(
                    child: Text(
                      "+",
                      textAlign:
                      TextAlign
                          .center,
                      style:
                      TextStyle(
                        color: (Features.isSubscription)?ColorCodes.whiteColor :ColorCodes.whiteColor,
                      ),
                    ),
                  )),
            ),
          ],
        ),

      ),

  );
}

Widget AddSubsciptionStepper(BuildContext context,{required StepperAlignment alignmnt,required ItemData itemdata,required Function() onTap,required double fontsize, }) {
  return (Features.isSubscription)?
  itemdata.eligibleForSubscription =="0" ?
  Expanded(
    flex: 1,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ()=>onTap(),
        child: Padding(
          padding:  EdgeInsets.only(left:alignmnt == StepperAlignment.Horizontal?10:0,top: alignmnt == StepperAlignment.Vertical?10:0,bottom: alignmnt == StepperAlignment.Vertical?8:0),
          child: Container(
            height: (Features.isSubscription)?alignmnt == StepperAlignment.Vertical?30:40:30.0,

            decoration: new BoxDecoration(
                color: ColorCodes.whiteColor,
                border: Border.all(color: Theme
                    .of(context)
                    .primaryColor),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(2),
                  topRight:
                  const Radius.circular(2),
                  bottomLeft:
                  const Radius.circular(2),
                  bottomRight:
                  const Radius.circular(2),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(

                  S.current.subscribe,
                  style: TextStyle(
                      fontSize: fontsize,
                      color: Theme.of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ) ,
          ),
        ),
      ),
    ),
  ):alignmnt == StepperAlignment.Vertical?Expanded(
      flex: 1,
      child: SizedBox.shrink()):SizedBox.shrink():SizedBox.shrink();
}

Widget NotificationStepper(BuildContext context,{required StepperAlignment alignmnt,required Function() onTap, required double fontsize,required bool isnotify}) {
  return Features.isSubscription?Expanded(
    flex: 1,
    child:
    MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?45:0,bottom: alignmnt == StepperAlignment.Vertical?10:0),
                //height: 30.0,
                decoration: new BoxDecoration(
                  // border: Border.all(
                  //     color:  (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor),
                    color:  (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome:IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
                    borderRadius:
                    new BorderRadius.all(const Radius.circular(3.0),)),
                child: isnotify ?
                Center(
                  child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: new CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation<
                            Color>(Colors.white),)),
                ):
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Center(
                        child: Text(S.current.notify_me,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors
                                  .white,
                              fontSize: fontsize),
                          textAlign: TextAlign.center,)),
                    Spacer(),
                    Container(
                      height: 30,
                      width: 25,
                      decoration: BoxDecoration(
                        color:Features.isSubscription?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome:
                        IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.maphome,

                      ),
                      child: Icon(
                        Icons.add,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),),
    ):Expanded(
    flex: 1,
    child:
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
         margin: EdgeInsets.only(top:alignmnt == StepperAlignment.Vertical?20:0,bottom: alignmnt == StepperAlignment.Vertical?10:0),
          //height: 30.0,
          decoration: new BoxDecoration(
            // border: Border.all(
            //     color:  (Features.isSubscription)?ColorCodes.primaryColor:ColorCodes.greenColor),
              color:  (Features.isSubscription)?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome:IConstants.isEnterprise?ColorCodes.greenColor:ColorCodes.maphome,
              borderRadius:
              new BorderRadius.all(const Radius.circular(3.0),)),
          child:
          isnotify ?
                Center(
                  child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: new CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation<
                            Color>(Colors.white),)),
                ):
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Center(
                  child: Text(S.current.notify_me,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors
                            .white,
                        fontSize: fontsize),
                    textAlign: TextAlign.center,)),
              Spacer(),
              Container(
                height: 30,
                width: 25,
                decoration: BoxDecoration(
                  color:Features.isSubscription?IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome:
                  IConstants.isEnterprise?ColorCodes.cartgreenColor:ColorCodes.maphome,

                ),
                child: Icon(
                  Icons.add,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

    ),

  );
















}