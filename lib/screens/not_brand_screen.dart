import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:bachat_mart/controller/mutations/cart_mutation.dart';
import 'package:bachat_mart/controller/mutations/cat_and_product_mutation.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/models/newmodle/product_data.dart';
import 'package:bachat_mart/repository/productandCategory/category_or_product.dart';
import 'package:bachat_mart/components/sellingitem_component.dart';
import 'package:bachat_mart/rought_genrator.dart';
import 'package:bachat_mart/widgets/simmers/item_list_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../widgets/bottom_navigation.dart';
import '../constants/features.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../providers/branditems.dart';
import '../screens/cart_screen.dart';
import '../providers/notificationitems.dart';
import '../widgets/selling_items.dart';
import '../assets/ColorCodes.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../providers/carouselitems.dart';
import '../main.dart';
import '../screens/searchitem_screen.dart';
import '../utils/prefUtils.dart';
import 'notification_screen.dart';

class NotBrandScreen extends StatefulWidget {
  static const routeName = '/not-brand-screen';

  Map<String, String> routeArgs;

  NotBrandScreen(this.routeArgs);
  @override
  _NotBrandScreenState createState() => _NotBrandScreenState();
}

class _NotBrandScreenState extends State<NotBrandScreen> with Navigations {
  bool _isLoading = true;
  var itemslistData;
  bool _isInit = true;
  bool _checkmembership = false;
  var brandsData;
  ItemScrollController? _scrollController;
  int startItem = 0;
  bool isLoading = true;

  var load = true;
  var brandslistData;
  int previndex = -1;
  var _checkitem = false;

  bool endOfProduct = false;
  bool _isOnScroll = false;
  String brandId = "";
  //SharedPreferences prefs;
  bool _isNotification = true;
  bool _isWeb =false;

  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool iphonex = false;
  Future<List<ItemData>>?  futurebrand ;
  ProductController productController = ProductController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((value) async {
      // });

      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist();
    }
    _isInit = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
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
        if (PrefUtils.prefs!.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final brandsId = widget.routeArgs['brandsId'].toString();
      brandId = widget.routeArgs['brandsId'].toString();

      if(widget.routeArgs['fromScreen'] == "Banner"){
        debugPrint("banner..");
        Provider.of<CarouselItemsList>(context, listen: false).fetchBrandsItems(brandsId).then((_) {
          debugPrint("banner1..");
          final brandsData = Provider.of<CarouselItemsList>(context, listen: false);
          setState(() {
            if (brandsData.brands.length > 0) {
              for (int i = 0; i < brandsData.brands.length; i++) {
                if (i != 0) {
                  brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                  brandsData.brands[i].textcolor = ColorCodes.blackColor;
                } else {
                  brandsData.brands[i].boxbackcolor = ColorCodes.mediumBlueColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.mediumBlueColor;
                  brandsData.brands[i].textcolor = ColorCodes.whiteColor;
                }
              }
              setState(() {
                _isLoading = false;
              });
              ProductController productController = ProductController();
              productController.getbrandprodutlist(brandId, 0,(isendofproduct){
                setState(() {
                  isLoading =false;
                });
              });
            /*  Provider.of<BrandItemsList>(context, listen: false).fetchBrandItems(brandsData.brands[0].id, startItem, "initialy").then((_) {
                setState(() {
                  brandslistData = Provider.of<BrandItemsList>(context, listen: false);
                  startItem = brandslistData.branditems.length;
                  load = false;
                  if (brandslistData.branditems.length <= 0) {
                    _checkitem = false;
                  } else {
                    _checkitem = true;
                  }
                });
              });*/

            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        });
      } else if (widget.routeArgs['fromScreen'] == "ClickLink") {
        _isNotification  = false;
        Provider.of<NotificationItemsList>(context, listen: false)
            .updateNotificationStatus(widget.routeArgs['notificationId']!, "1");
      } else {
        _isNotification = true;
        print("in....");
        if (widget.routeArgs['notificationStatus'] == "2") {
          print("in1....");
          Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1").then((value) {
            final brandsData = Provider.of<NotificationItemsList>(context, listen: false);
            setState(() {
              if (brandsData.brands.length > 0) {
                for (int i = 0; i < brandsData.brands.length; i++) {
                  if (i != 0) {
                    brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                    brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                    brandsData.brands[i].textcolor = ColorCodes.blackColor;
                  } else {
                    brandsData.brands[i].boxbackcolor = ColorCodes.mediumBlueColor;
                    brandsData.brands[i].boxsidecolor = ColorCodes.mediumBlueColor;
                    brandsData.brands[i].textcolor = ColorCodes.whiteColor;
                  }
                }
                setState(() {
                  _isLoading = false;
                });
                ProductController productController = ProductController();
                productController.getbrandprodutlist(brandId, 0,(isendofproduct){
                  print("in....");
                  setState(() {
                    isLoading =false;
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          });
        }
      }

      if(widget.routeArgs['fromScreen'] != "Banner")
        Provider.of<NotificationItemsList>(context, listen: false).fetchBrandsItems(brandsId).then((_) {
          final brandsData = Provider.of<NotificationItemsList>(context, listen: false);
          setState(() {
            if (brandsData.brands.length > 0) {
              for (int i = 0; i < brandsData.brands.length; i++) {
                if (i != 0) {
                  brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                  brandsData.brands[i].textcolor = ColorCodes.blackColor;
                } else {
                  brandsData.brands[i].boxbackcolor = ColorCodes.mediumBlueColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.mediumBlueColor;
                  brandsData.brands[i].textcolor = ColorCodes.whiteColor;
                }
              }
              setState(() {
                _isLoading = false;
              });
              ProductController productController = ProductController();
              productController.getbrandprodutlist(brandId, 0,(isendofproduct){
                setState(() {
                  isLoading =false;
                });
              });
        /*      Provider.of<BrandItemsList>(context, listen: false).fetchBrandItems(brandsData.brands[0].id, startItem, "initialy").then((_) {
                setState(() {
                  brandslistData = Provider.of<BrandItemsList>(context, listen: false);
                  startItem = brandslistData.branditems.length;
                  load = false;
                  if (brandslistData.branditems.length <= 0) {
                    _checkitem = false;
                  } else {
                    _checkitem = true;
                  }
                });
              })*/;
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        });// only create the future once.
    });
    super.initState();
  }

  _displayitem(String brandid, int index) {
    // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      brandId = brandid;
      endOfProduct = false;
      load = true;
      _checkitem = false;
      startItem = 0;
      if(widget.routeArgs['fromScreen'] == "Banner"){
        brandsData = Provider.of<CarouselItemsList>(context, listen: false);
      } else {
        brandsData = Provider.of<NotificationItemsList>(context, listen: false);
      }
      for (int i = 0; i < brandsData.brands.length; i++) {
        if (index != i) {
          brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
          brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
          brandsData.brands[i].textcolor = ColorCodes.blackColor;
        } else {
          brandsData.brands[i].boxbackcolor = ColorCodes.mediumBlueColor;
          brandsData.brands[i].boxsidecolor = ColorCodes.mediumBlueColor;
          brandsData.brands[i].textcolor = ColorCodes.whiteColor;
        }
      }

   /*   Provider.of<BrandItemsList>(context, listen: false)
          .fetchBrandItems(brandId, startItem, "initialy")
          .then((_) {
        brandslistData = Provider.of<BrandItemsList>(context, listen: false);
        startItem = brandslistData.branditems.length;
        setState(() {
          load = false;
          if (brandslistData.branditems.length <= 0) {
            _checkitem = false;
          } else {
            _checkitem = true;
          }
        });
      });*/
      productController.getbrandprodutlist(brandid, 0,(isendofproduct){
        setState(() {
          isLoading = false;
          /*indexvalue =  index.toString();
          indvalue =  index.toString();*/
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final widget.routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if(widget.routeArgs['fromScreen'] == "Banner"){
      brandsData = Provider.of<CarouselItemsList>(context, listen: false);
    } else {
      brandsData = Provider.of<NotificationItemsList>(context, listen: false);
    }

    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    // double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    double aspectRatio =   (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 330:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;

    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {SetCartItem},
        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context,GroceStore store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          if (box.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
                (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
             /*   Navigator.of(context)
                    .pushNamed(CartScreen.routeName, arguments: {
                  "afterlogin": ""
                });*/
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
        },
      );
    }
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color:IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
            onPressed: () async{
              if(widget.routeArgs['fromScreen'] == "ClickLink"){
                Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
                // Navigator.of(context).pushReplacementNamed(
                //     NotificationScreen.routeName);
              }
              else {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/home-screen', (Route<dynamic> route) => false);
                });
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(
          S .of(context).brands,// "Brands",
          style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                   /* ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
                  ]
              )
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

            },
            child: Icon(
              Icons.search,
              size: 30.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
       /* SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        });*/
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
        }
        else {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);
          });
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            SizedBox(
              height: 15.0,
            ),
            (!_isLoading)?
              Container(
              //  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                child: SizedBox(
                  height: 60,
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: brandsData.brands.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _displayitem(brandsData.brands[i].id, i);
                          },
                          child: Container(
                            height: 40,
//                      width:150,
                            // constraints: BoxConstraints(maxWidth: 850),
                            margin: EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                                color: brandsData.brands[i].boxbackcolor,
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: brandsData.brands[i].boxsidecolor,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: brandsData.brands[i].boxsidecolor,
                                  ),
                                  left: BorderSide(
                                    width: 1.0,
                                    color: brandsData.brands[i].boxsidecolor,
                                  ),
                                  right: BorderSide(
                                    width: 1.0,
                                    color: brandsData.brands[i].boxsidecolor,
                                  ),
                                )),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    brandsData.brands[i].title,
//                            textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: brandsData.brands[i].textcolor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ):
             Container(height:60),
            isLoading
                ? Center(
              child: ItemListShimmer(),
            )
                :
               /* ? */Flexible(
              fit: FlexFit.loose,
              child: NotificationListener<ScrollNotification>(
                // ignore: missing_return
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!endOfProduct) if (!_isOnScroll &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      setState(() {
                        _isOnScroll = true;
                      });
                 /*     Provider.of<BrandItemsList>(context, listen: false)
                          .fetchBrandItems(
                          brandId, startItem, "scrolling")
                          .then((_) {
                        setState(() {
                          startItem = brandslistData.branditems.length;
                          if (PrefUtils.prefs!.getBool("endOfProduct")) {
                            _isOnScroll = false;
                            endOfProduct = true;
                          } else {
                            _isOnScroll = false;
                            endOfProduct = false;
                          }
                        });
                      });*/
                      productController.getbrandprodutlist(brandId, (VxState.store as GroceStore).productlist.length,(isendofproduct){
                        if(endOfProduct){
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = true;
                          });
                        }else {
                          setState(() {
                            _isOnScroll = false;
                            endOfProduct = false;

                          });
                        }
                      });
                      // start loading data
                      /* setState(() {
                          isLoading = true;
                        });*/
                    }
                    return true;
                  },
                  child: VxBuilder (
                      mutations: {ProductMutation},
                      builder: (ctx,GroceStore? store,VxStatus? state) {
                        final productlist = (store as GroceStore).productlist;
                    return (productlist.length>0)?SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //   constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
              child: Column(
                children: <Widget>[
                  GridView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(
                          keepScrollOffset: false),
                      itemCount:productlist.length,
                      //brandslistData.branditems.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 3,
                        childAspectRatio: aspectRatio,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder:
                          (BuildContext context, int index) {
                        return SellingItemsv2( "brands_screen",
                            "",
                            productlist[index],
                          "",
                        );
                            /*SellingItems(
                          "brands_screen",
                          brandslistData.branditems[index].id,
                          brandslistData
                              .branditems[index].title,
                          brandslistData
                              .branditems[index].imageUrl,
                          brandslistData
                              .branditems[index].brand,
                          "",
                          brandslistData.branditems[index].veg_type,
                          brandslistData.branditems[index].type,
                          brandslistData.branditems[index].eligible_for_express,
                          brandslistData.branditems[index].delivery,
                          brandslistData.branditems[index].duration,
                          brandslistData.branditems[index].durationType,
                          brandslistData.branditems[index].note,
                          brandslistData.branditems[index].subscribe,
                          brandslistData.branditems[index].paymentmode,
                          brandslistData.branditems[index].cronTime,
                          brandslistData.branditems[index].name,

                        );*/
                      }),
                  if (endOfProduct)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.only(
                          top: 25.0, bottom: 25.0),
                      child: Text(
                        S
                            .of(context)
                            .thats_all_folk, // "That's all folks!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),


                ],
              ),
            ),
            if(_isWeb) Footer(
                address: PrefUtils.prefs!.getString("restaurant_address")!)
          ],
        ),

      ):
                    SingleChildScrollView(
                    child: Container(
                    child: Column(
                    children: [
                    Align(
                    alignment: Alignment.center,
                    child: new Image.asset(
                    Images.noItemImg, fit: BoxFit.fill,
                    height: 250.0,
                    width: 200.0,
//                    fit: BoxFit.cover
                    ),
                    ),
                    if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                    ],
                    ),
                    ),
                    );
                     })
                ),
            ),
                /*: Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: new Image.asset(
                          Images.noItemImg, fit: BoxFit.fill,
                          height: 250.0,
                          width: 200.0,
//                    fit: BoxFit.cover
                        ),
                      ),
                      if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address"))
                    ],
                  ),
                ),
              ),
            ),*/
            if(!_isWeb)Container(
              height: _isOnScroll ? 50 : 0,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),

          ],
        ),
        bottomNavigationBar:  _isWeb ? SizedBox.shrink() : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
