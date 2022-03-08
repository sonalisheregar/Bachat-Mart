import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bachat_mart/components/sellingitem_component.dart';
import 'package:bachat_mart/controller/mutations/cat_and_product_mutation.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../screens/notification_screen.dart';
import '../widgets/bottom_navigation.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../generated/l10n.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../screens/cart_screen.dart';
import '../providers/notificationitems.dart';
import '../widgets/selling_items.dart';
import '../data/calculations.dart';
import '../assets/ColorCodes.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../utils/prefUtils.dart';

class NotProductScreen extends StatefulWidget {
  static const routeName = '/not-product-screen';

  Map<String, String> routeArgs;

  NotProductScreen(this.routeArgs);
  @override
  _NotProductScreenState createState() => _NotProductScreenState();
}

class _NotProductScreenState extends State<NotProductScreen> with Navigations{
  bool _isLoading = true;
  NotificationItemsList itemslistData = NotificationItemsList();
  bool _isInit = true;
  bool _checkmembership = false;
  bool iphonex = false;
  bool _isWeb = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
        });
      }
      setState(() {
        if(PrefUtils.prefs!.getString("membership") == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final productId = widget.routeArgs['productId'];
      //await Provider.of<BrandItemsList>(context, listen: false).fetchPaymentMode();
      if(widget.routeArgs['fromScreen'] == "ClickLink") {
        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" );
      } else {
        if(widget.routeArgs['notificationStatus'] == "0"){
          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" ).then((value){
          });
        }
      }
      ProductController().getcategoryitemlist(productId!).then((_){
        setState(() {
          _isLoading = false;
        });
      });
      // Provider.of<NotificationItemsList>(context,listen: false).fetchProductItems(productId!).then((_) {
      //   itemslistData = Provider.of<NotificationItemsList>(context,listen: false);
      //   if (itemslistData.items.length <= 0) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      // }); // only create the future once.
    });
  }

  @override
  didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });

      Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist();
      // Provider.of<BrandItemsList>(context,listen: false).GetRestaurant().then((value) async {
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 3;
    } else if (deviceWidth > 768) {
      widgetsInRow = 2;
    }
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 180;

    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {ProductMutation},
        builder: (context, GroceStore box, _) {
          if (box.userData!=null)
            return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
                (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
             /*   Navigator.of(context)
                    .pushNamed(CartScreen.routeName,arguments: {
                  "afterlogin": ""
                });*/
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
          // return Container(
          //   width: MediaQuery
          //       .of(context)
          //       .size
          //       .width,
          //   height: 50.0,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       Container(
          //         height:50,
          //         width:MediaQuery.of(context).size.width * 35/100,
          //         child: Column(
          //           children: <Widget>[
          //             SizedBox(
          //               height: 15.0,
          //             ),
          //             _checkmembership
          //                 ?
          //             Text(IConstants.currencyFormat + (Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), style: TextStyle(color: Colors.black),)
          //                 :
          //             Text(IConstants.currencyFormat + (Calculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit), style: TextStyle(color: Colors.black),),
          //             Text(Calculations.itemCount.toString() +
          //                 S .of(context).item,// " item"
          //               style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
          //           ],
          //         ),),
          //       GestureDetector(
          //           onTap: () =>
          //           {
          //             setState(() {
          //               Navigator.of(context).pushNamed(CartScreen.routeName);
          //             })
          //           },
          //           child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
          //               child:Column(children:[
          //                 SizedBox(height: 17,),
          //                 Text(
          //                     S .of(context).view_cart//'VIEW CART'
          //                   , style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          //               ]
          //               )
          //           )
          //       ),
          //     ],
          //   ),
          // );
        },
      );
    }

    bool _isNotification = false;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    if(widget.routeArgs['fromScreen'] == "ClickLink") {
      _isNotification = false;
      Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1" );
    } else {
      _isNotification = true;
    }

    return _isNotification ?
    WillPopScope(
      onWillPop: (){
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        }
        else {
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);

        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
               /* ColorCodes.accentColor,
                ColorCodes.primaryColor*/
              ]
          ),
          elevation: (IConstants.isEnterprise)?0:1,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color:ColorCodes.menuColor),
              onPressed: () {
                if(widget.routeArgs['fromScreen'] == "ClickLink"){
                  Navigator.of(context).pop();
                }
                else {
                  Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);

                }
               // return Future.value(false);
              }
          ),
          title: Text(
            S .of(context).offers,//"Offers",
            style: TextStyle(color: ColorCodes.menuColor),
          ),
        ),

        body: VxBuilder(
          mutations: {ProductMutation},
          builder: (context, GroceStore snapshot,state) {
            debugPrint("notp......"+itemslistData.items.length.toString()+"aaaaaa"+snapshot.productlist.length.toString());
            // switch(state){
            //
            //   case VxStatus.none:
            //     // TODO: Handle this case.
            //     break;
            //   case VxStatus.loading:
            //     // TODO: Handle this case.
            //     break;
            //   case VxStatus.success:
            //     // TODO: Handle this case.
            //     break;
            //   case VxStatus.error:
            //     // TODO: Handle this case.
            //     break;
            // }
            return _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                :
            GridView.builder(
                itemCount: itemslistData.items.length,
                shrinkWrap: true,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  crossAxisSpacing: 3,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SellingItemsv2(
                    "not_product_screen",
                    "",
                    snapshot.productlist[index],
                    "",
                    // itemslistData.items[index].imageUrl,
                    // itemslistData.items[index].brand,
                    // "",
                    //   itemslistData.items[index].veg_type,
                    //   itemslistData.items[index].type,
                    // itemslistData.items[index].eligible_for_express,
                    // itemslistData.items[index].delivery,
                    // itemslistData.items[index].duration,
                    // itemslistData.items[index].durationType,
                    // itemslistData.items[index].note,
                    // itemslistData.items[index].subscribe,
                    // itemslistData.items[index].paymentmode,
                    // itemslistData.items[index].cronTime,
                    // itemslistData.items[index].name,

                  );
                });
          }
        ),
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child:_buildBottomNavigationBar(),
        ),
      ),
    )
        :
    WillPopScope(
      onWillPop: () { // this is the block you need
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        }
        else {
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);

        }

        //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
      child: Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                  IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor,
                 /* ColorCodes.accentColor,
                  ColorCodes.primaryColor*/
                ]
            ),
            title: Text(
              S .of(context).offers, //"Offers",
            ),
          ),

          body:  VxBuilder(
              mutations: {ProductMutation},
              builder: (context, GroceStore snapshot,state) {
                // switch(state){
                //
                //   case VxStatus.none:
                //     // TODO: Handle this case.
                //     break;
                //   case VxStatus.loading:
                //     // TODO: Handle this case.
                //     break;
                //   case VxStatus.success:
                //     // TODO: Handle this case.
                //     break;
                //   case VxStatus.error:
                //     // TODO: Handle this case.
                //     break;
                // }
                return _isLoading
                  ? Center(child: CircularProgressIndicator(),)
                  :
              GridView.builder(
                  itemCount: itemslistData.items.length,
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    crossAxisSpacing: 3,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: 3,
                  ),

                  itemBuilder: (BuildContext context, int index) {
                    return SellingItemsv2(
                      "not_product_screen",
                      "",
                      snapshot.productlist[index],
                      "",
                    );
                  });
            }
          ),
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
        ),
      ),

    );
  }
}