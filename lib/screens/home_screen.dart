import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bachat_mart/controller/mutations/cart_mutation.dart';
import 'package:bachat_mart/repository/authenticate/AuthRepo.dart';
import '../../rought_genrator.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../widgets/simmers/HomeScreenShimmerweb.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/home_page_modle.dart';
import '../models/newmodle/user.dart';
import '../components/ItemList/item_component.dart';
import '../rought_genrator.dart';
import '../widgets/simmers/home_screen_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../widgets/websiteSmallbanner.dart';
import '../screens/customer_support_screen.dart';
import '../widgets/CarouselSliderimageWidget.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/categoryOne.dart';
import '../widgets/categoryThree.dart';
import '../widgets/expandable_categories.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/websiteSlider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_drawer.dart';
import '../widgets/brands_items.dart';
import '../widgets/advertise1_items.dart';
import '../constants/features.dart';
import '../widgets/floatbuttonbadge.dart';
import '../providers/advertise1items.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../widgets/categoryTwo.dart';
import '../data/calculations.dart';
import '../utils/prefUtils.dart';

enum SingingCharacter { english, arabic }
 GlobalKey<ScaffoldState> get scaffoldKeys => GlobalKey();
class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
 static  GlobalKey<ScaffoldState> scaffoldKey = scaffoldKeys;

  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Navigations{
  var _address = "";
  bool iphonex = false;
  bool _isDelivering = true;
  bool _isinternet = true;
  bool _isInit = true;
  var _carauselslider = false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool _isRestaurant = false;

  var name = "",
      email = "",
      photourl = "",
      phone = "";
  int count =0;

  DateTime? currentBackPressTime;
  Future<void> _refreshProducts(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {_isinternet = true;});
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {_isinternet = true;});
    } else {
      Fluttertoast.showToast(
        msg: "No internet connection!!!", fontSize: MediaQuery
          .of(context)
          .textScaleFactor * 13,);
      setState(() {
        _isinternet = false;
      });
    }

    auth.getuserProfile(onsucsess: (value){
      debugPrint("getuserprofile.....onsucsess");
      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
          PrefUtils.prefs!.getString("ftokenid"),
        branch: PrefUtils.prefs!.getString("branch") ?? "15",
        rows: "0",);
    }, onerror: (){
    });
  }

  @override
  void initState() {
    debugPrint("its here........2");
    super.initState();
  }

  // @override
  // void initState() {
  //
  //   Future.delayed(Duration.zero, () async {
  //
  //     await Provider.of<Advertise1ItemsList>(context, listen: false)
  //         .fetchPopupBanner()
  //         .then((_) {
  //       final bannerpopup = Provider.of<Advertise1ItemsList>(
  //           context, listen: false);
  //       if (!PrefUtils.prefs!.containsKey("descriptionCount")) {
  //         PrefUtils.prefs!.setString("descriptionCount", "0");
  //       }
  //       if (bannerpopup.popupbanner.length > 0) {
  //         if (PrefUtils.prefs!.getString("descriptionCount") !=
  //             bannerpopup.popupbanner[0].description) {
  //           count = int.parse(PrefUtils.prefs!.getString("descriptionCount")!);
  //           ShowPopupforbanner();
  //         }
  //       }
  //     });
  //     PrefUtils.prefs!.setString("addressbook", "");
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.mobile ||
  //         connectivityResult == ConnectivityResult.wifi) {
  //       _apiCalls();
  //       setState(() {
  //         _isinternet = true;
  //       });
  //       // I am connected to a mobile network.
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "No internet connection!!!", fontSize: MediaQuery
  //           .of(context)
  //           .textScaleFactor * 13,);
  //       setState(() {
  //         _isinternet = false;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  _apiCalls() async {
    // homedata = (VxState.store as GroceStore).homescreen;
  }

  Widget _sliderShimmer()  {
    return Vx.isWeb ?
    SizedBox.shrink()
        :
    Shimmer.fromColors(
        baseColor: /*Color(0xffd3d3d3)*/Colors.grey[200]!,
        highlightColor: ColorCodes.lightGreyWebColor,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              height: 150.0,
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 20.0,
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget _bannerMain1(HomePageData homedata) {
    // final banner1Data = Provider.of<Advertise1ItemsList>(context,listen: false);
    if (homedata.data!.mainslideradd != null)
      if (homedata.data!.mainslideradd!.length >= 0) {
        _carauselslider = true;
      } else {
        _carauselslider = false;
      }

    return _carauselslider ? Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
              // height:ResponsiveLayout.isSmallScreen(context)? MediaQuery.of(context).size.height*0.28:150.0,
              child: new ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.only(right: 10),
                itemCount: homedata.data!.mainslideradd!.length,
                itemBuilder: (_, i) =>
                    Column(
                      children: [
                        Advertise1Items(
                          homedata.data!.mainslideradd![i],
                          "home",
                        ),
                      ],
                    ),
              ),
            )),
      ],
    ) : SizedBox.shrink();
  }

   _advertiseCategoryOne(homedata) {
    if (Features.isAdsCategoryOne) if (MediaQuery
        .of(context)
        .size
        .width <= 600)
      return (homedata.data.featuredCategories1.length > 0) ? Row(
        children: <Widget>[
          Expanded(
              child: SizedBox(
                height: 135.0,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0.0),
                  itemCount: homedata.data.featuredCategories1.length,
                  itemBuilder: (_, i) =>
                      Column(
                        children: [Advertise1Items(
                          homedata.data.featuredCategories1[i],
                          "top",),
                        ],
                      ),
                ),
              )),
        ],
      ) : SizedBox.shrink(); else
      return SizedBox.shrink();
  }

   _featuredItemweb(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    // homedata.data!.featuredByCart!.data!.forEach((element) {
    // });
    if (Features.isSellingItems)
      if(homedata.data!.featuredByCart!.data!.length>0)
      return Container(
        // padding: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 20,right: 20):null,
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
            left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0,
            right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0),
        color: /* Color(0xFFFFE8E8).withOpacity(0.7)*/ColorCodes.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.featuredByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                   /*   Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "featured",
                        'title': homedata.data!.featuredByCart!.label,
                      });*/
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "featured",});
                    },
                    child: Text(
                      S
                          .of(context)
                          .view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              //  padding: EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:null,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:null ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: ResponsiveLayout.isSmallScreen(context)?Features.btobModule?420:
                             (Features.isSubscription) ? 392 : 340
                            : ResponsiveLayout.isMediumScreen(context)
                            ? Features.btobModule?420:(Features.isSubscription) ? 392 : 380
                            : Features.btobModule?420:(Features.isSubscription) ? 392 : 380,

                        child: MouseRegion(
                          cursor: MouseCursor.defer,
                          child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: homedata.data!.featuredByCart!.data!.length,
                              itemBuilder: (_, i) {
                                return Column(
                                  children: [
                                    Itemsv2(
                                      "home_screen",
                                      homedata.data!.featuredByCart!.data![i],
                                      homedata.data!.customerDetails!.length > 0
                                          ? homedata.data!.customerDetails!.first
                                          : UserData(membership: "0"),
                                      // homedata.data.featuredByCart.data[i].itemFeaturedImage,
                                      // homedata.data.featuredByCart.data[i].brand,
                                      // homedata.data.featuredByCart.data[i].vegType,
                                      // homedata.data.featuredByCart.data[i].type,
                                      // homedata.data.featuredByCart
                                      //     .data[i].eligibleForExpress,
                                      // homedata.data.featuredByCart.data[i].delivery,
                                      // homedata.data.featuredByCart.data[i].duration,
                                      // homedata.data.featuredByCart.data[i].deliveryDuration.durationType,
                                      // homedata.data.featuredByCart.data[i].deliveryDuration.note,
                                      // homedata.data.featuredByCart.data[i].eligibleForSubscription,
                                      // homedata.data.featuredByCart.data[i].paymentMode,
                                      // homedata.data.featuredByCart.data[i].subscriptionSlot[0].cronTime,
                                      // homedata.data.featuredByCart.data[i].subscriptionSlot[0].deliveryTime,

                                      //sellingitemData.items[i].brand,
                                    ),
                                  ],
                                );
                              }
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      else return SizedBox.shrink();
  }

//continue
   _featuredItemMobile(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    if (Features.isSellingItems)
      if(homedata.data!.featuredByCart!.data!.length > 0)
      return Container(
        padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
        color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.featuredByCart!.label!,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                  /*    Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "featured",
                        'title': homedata.data!.featuredByCart!.label,
                      });*/
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "featured",});
                    },
                    child: Text(
                      S
                          .of(context)
                          .view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ?
                Features.btobModule?420:(Features
                    .isSubscription) ? 392 : 340 : ResponsiveLayout
                    .isMediumScreen(context) ?
                Features.btobModule?420:(Features.isSubscription)
                    ? 340
                    : 360 : Features.btobModule?420:(Features.isSubscription) ? 388 : 360,

                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.featuredByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "home_screen",
                          homedata.data!.featuredByCart!.data![i],
                          homedata.data!.customerDetails!.length > 0 ? homedata
                              .data!.customerDetails!.first : UserData(
                              membership: "0"),
                          //sellingitemData.items[i].brand,
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
      else return SizedBox.shrink();
  }

  Widget _featuredAdsOne(HomePageData homedata) {
    /* return StreamBuilder(
      stream: bloc.featuredAdsOne,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/

    /*  if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {*/
    if (homedata.data!.featureditems1!.length > 0) {
      double deviceWidth = MediaQuery
          .of(context)
          .size
          .width;
      int widgetsInRow = (Vx.isWeb &&
          !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
      if (deviceWidth > 1200) {
        widgetsInRow = 2;
      } else if (deviceWidth < 768) {
        widgetsInRow = 1;
      }
      double aspectRatio = (Vx.isWeb &&
          !ResponsiveLayout.isSmallScreen(context)) ?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
          350 :
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
          170;
      return GridView.builder(

        //scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widgetsInRow,
          crossAxisSpacing: 3,
          childAspectRatio: aspectRatio,

        ),
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        itemCount: homedata.data!.featureditems1!.length,
        itemBuilder: (_, i) =>
            Advertise1Items(
              homedata.data!.featureditems1![i],
              "horizontal",
            ),
      );
    } else {
      return /*_sliderShimmer()*/SizedBox.shrink();
    }

    /* }
          else return SizedBox.shrink();
        }else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else if(!snapshot.hasData) {
          return SizedBox.shrink();
        }*/

    /* },
    );*/


  }

   _featuredAdsTwo(HomePageData homedata) {
    if (Features.isAdsCategoryTwo)
      /*return StreamBuilder(
      stream: bloc.featuredAdsTwo,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
      /* if (snapshot.hasData) {*/
      if (homedata.data!.featuredCategories2!.length > 0) {
        double deviceWidth = MediaQuery
            .of(context)
            .size
            .width;
        int widgetsInRow = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
        if (deviceWidth > 1200) {
          widgetsInRow = 2;
        } else if (deviceWidth < 768) {
          widgetsInRow = 1;
        }
        double aspectRatio = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            350 :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            170;
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widgetsInRow,
              crossAxisSpacing: 4,
              childAspectRatio: aspectRatio

          ),
          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          itemCount: homedata.data!.featuredCategories2!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (_, i) =>
              Column(
                children: [
                  Advertise1Items(
                    homedata.data!.featuredCategories2![i],
                    "horizontal",
                  ),
                ],
              ),
        );
      }
      else
        /*return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
        }
        Platform platform;*/
        return /*_sliderShimmer()*/SizedBox.shrink();
    /*},
    );*/
  }

  Widget _categoryThree(HomePageData homedata) {
    if (Features.isCategoryThree)
      return /*isCategoryThree
        ? */CategoryThree(homedata); else
      /* : _isCategoryThreeShimmer
        ? _horizontalshimmerslider()*/
      return SizedBox.shrink();
  }

   _featuredAdsVertical(HomePageData homedata) {
    if (Features.isVerticalSlider)
      if (MediaQuery
          .of(context)
          .size
          .width <= 600)
        /* return StreamBuilder(
      stream: bloc.featuredAdsThree,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
        /* if (snapshot.hasData) {*/
        if (homedata.data!.verticalSlider!.length > 0)
          return new SizedBox(
            height: 290.0,
            child: new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: homedata.data!.verticalSlider!.length,
              itemBuilder: (_, i) =>
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Advertise1Items(
                        homedata.data!.verticalSlider![i],
                        "bottom"),
                  ),
            ),
          );
        else
          return SizedBox.shrink();
      else
        /*if (snapshot.hasError) {
          //return _sliderShimmer();
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
          return _sliderShimmer();
        }
        Platform platform;*/
        return _sliderShimmer();
    /* },
    );*/ else
      SizedBox.shrink();

    /*return _isFeaturedAdsVertical
      ? SizedBox(
          height: 290.0,
          child: new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: advertise1Data.item3.length,
            itemBuilder: (_, i) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Advertise1Items(
                  advertise1Data.item3[i].imageUrl,
                  advertise1Data.item3[i].bannerFor,
                  advertise1Data.item3[i].bannerData,
                  advertise1Data.item3[i].clickLink,
                  advertise1Data.item3[i].displayFor,
                  "bottom"),
            ),
          ),
        )
      : _isFeaturedAdsVerticalShimmer
          ? _sliderShimmer()
          : SizedBox.shrink();*/
  }

  Widget _featuredAdsThree(HomePageData homedata) {
    if (Features.isFeatureAdsThree)
      /*return StreamBuilder(
      stream: bloc.featuredAdsFour,
      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
      /*if (snapshot.hasData) {*/
      if (homedata.data!.featuredCategories3!.length > 0) {
        double deviceWidth = MediaQuery
            .of(context)
            .size
            .width;
        int widgetsInRow = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
        if (deviceWidth > 1200) {
          widgetsInRow = 2;
        } else if (deviceWidth < 768) {
          widgetsInRow = 1;
        }
        double aspectRatio = (Vx.isWeb &&
            !ResponsiveLayout.isSmallScreen(context)) ?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            350  :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
            170;
        return GridView.builder(

          shrinkWrap: true,
          controller: new ScrollController(keepScrollOffset: false),
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widgetsInRow,
              crossAxisSpacing: 4,
              childAspectRatio: aspectRatio

          ),
          itemCount: homedata.data!.featuredCategories3!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (_, i) =>
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Advertise1Items(
                      homedata.data!.featuredCategories3![i],
                      "horizontal",
                    ),
                  ],
                ),
              ),
        );
      }
    /*else return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text("snap error . . . . .." + snapshot.error.toString());
        } else {
        }
        Platform platform;*/
    return /*_sliderShimmer()*/SizedBox.shrink();
    /* },
    );*/

  }

   _category(HomePageData homedata) {
    if (Features.isCategory) return Container(
      padding: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? EdgeInsets.only(left: 20, right: 20)
          : null,
      child: Column(
        children: [
          /*(IConstants.isEnterprise)?*/Container(
            margin: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 3.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S
                    .of(context)
                    .explore_by_cat, //"Explore by Category",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)
                        ? 18.0
                        : 24.0,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ) /*:SizedBox.shrink()*/,
          SizedBox(
            height: 5,
          ),
          //TODO:Expandable Cat Bloc
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

  Widget _categoryweb(HomePageData homedata) {
    return Container(
      padding: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
          ? EdgeInsets.only(left: 18, right: 18)
          : null,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 3.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                S
                    .of(context)
                    .explore_by_cat, //"Explore by Category",
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)
                        ? 18.0
                        : 24.0,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ExpansionCategory(homedata),
        ],
      ),
    );
  }

   _brands(HomePageData homedata) {
    if (Features.isBrands)
      // return StreamBuilder(
      //     stream: bloc.brandfiledBloc,
      //     builder: (context, AsyncSnapshot<List<BrandsFieldModel>> snapshot) {

      //  if(snapshot.hasData) {
      if (homedata.data!.allBrands!.length > 0)
        return Container(
          color: /*Color(0xffE1EFFC)*/Colors.white,
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.only(
              left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Container(
            padding:
            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? EdgeInsets.only(left: 20, right: 20)
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S
                      .of(context)
                      .shop_by_brands, //"Shop by Brands",
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .primaryColor),
                ),
                SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  height: 70,
                  child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: homedata.data!.allBrands!.length,
                    itemBuilder: (_, i) =>
                        Column(
                          children: [
                            BrandsItems(
                              homedata.data!.allBrands![i],
                              i,
                            ),
                          ],
                        ),
                  ),
                ),
                //SizedBox(height: 15.0,),
              ],
            ),
          ),
        );
      else
        return SizedBox.shrink();
    // } else if(snapshot.hasError)return SizedBox.shrink();
    // else{
    //   return _sliderShimmer();
    // }
    // });
  }

  Widget _discountItem(HomePageData homedata) {
    // final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);

    if (homedata.data!.discountByCart!.data!.length > 0) {
      return Container(
        //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
            left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0,
            right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0),
        color: /*Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.discountByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                 /*     Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "discount",
                        'title': homedata.data!.discountByCart!.label,
                      });*/
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "discount"});
                    },
                    child: Text(
                      S
                          .of(context)
                          .view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ? Features.btobModule?420:(Features
                    .isSubscription) ? 392 : 340 : ResponsiveLayout
                    .isMediumScreen(context) ? Features.btobModule?420:(Features.isSubscription)
                    ? 340
                    : 360 : Features.btobModule?420:(Features.isSubscription) ? 388 : 360,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.discountByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "Discount",
                          homedata.data!.discountByCart!.data![i],
                          homedata.data!.customerDetails!.length > 0 ? homedata
                              .data!.customerDetails!.first : UserData(
                              membership: "0"),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _offersItem(HomePageData homedata) {
    //  final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    /* return  StreamBuilder<List<SellingItemsFields>>(
     stream: bloc.offerItemStream,
     builder: (context,  snapshot){*/

    if (homedata.data!.offerByCart!.data!.length > 0) {
      return Container(
        //padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
        padding: EdgeInsets.only(top: 15.0,
            bottom: 10.0,
            left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0,
            right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                ? 20
                : 0),
        color: /* Color(0xFFFFE8E8).withOpacity(0.7)*/Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  homedata.data!.offerByCart!.label!,
                  style: TextStyle(
                      fontSize: ResponsiveLayout.isSmallScreen(context)
                          ? 18.0
                          : 24.0,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                   /*   Navigator.of(context)
                          .pushNamed(SellingitemScreen.routeName, arguments: {
                        'seeallpress': "offers",
                        'title': homedata.data!.offerByCart!.label,
                      });*/
                      Navigation(context, name: Routename.SellingItem, navigatore: NavigatoreTyp.Push,
                          parms: {"seeallpress": "offers",});
                    },
                    child: Text(
                      S
                          .of(context)
                          .view_all, //'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
                height: ResponsiveLayout.isSmallScreen(context) ?
                Features.btobModule?420
                    :(Features.isSubscription) ? 392
                    : 340
                    : ResponsiveLayout.isMediumScreen(context) ?
                (Features.isSubscription) ? 340
                    : 360
                    : Features.btobModule?420
                    :(Features.isSubscription) ? 388
                    : 360,
                child: new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homedata.data!.offerByCart!.data!.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Itemsv2(
                          "offers",
                          homedata.data!.offerByCart!.data![i],
                          // homedata.data.customerDetails[0],
                          homedata.data!.customerDetails!.length > 0 ? homedata
                              .data!.customerDetails!.first : UserData(
                              membership: "0"),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      );
    }
    /*else if(snapshot.hasError){
         return SizedBox.shrink();
       }else {
         return _horizontalshimmerslider();
       }*/
    else {
      return SizedBox.shrink();
    }

    /*},

   );*/
  }

  Widget _footer(HomePageData homedata) {
    /*return StreamBuilder(
      stream: bloc.footer,

      builder: (context, AsyncSnapshot<List<BrandsFields>> snapshot) {*/
    if (homedata.data!.footerImage!.length > 0) {
      return new ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: homedata.data!.footerImage!.length,
        itemBuilder: (_, i) =>
            Container(
              child: CachedNetworkImage(
                imageUrl: homedata.data!.footerImage![i].bannerImage,
                fit: BoxFit.fill,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                placeholder: (context, url) =>
                    Image.asset(Images.defaultSliderImg),
                errorWidget: (context, url, error) =>
                    Image.asset(Images.defaultSliderImg),
              ),
            ),
      );
    } else {
      return SizedBox.shrink();
    }
    /* },
    );*/

  }

  Widget _body() {
    return VxBuilder(
      mutations: {HomeScreenController,SetPrimeryLocation},
      builder: (ctx,GroceStore? store, VxStatus? state) {
       //  switch (state!) {
       //   case VxStatus.none:
       //     return loadhomeScreen();
       //    case VxStatus.loading:
       //      return HomeScreenShimmer();
       //      // TODO: Handle this case.
       //      break;
       //    case VxStatus.success:
       //    // TODO: Handle this case.
       //  return loadhomeScreen();
       //      break;
       //    // case VxStatus.error:
       //    // // TODO: Handle this case.
       //    //   break;
       //    default:
       //      return HomeScreenShimmer();
       //      break;
       // }
    print("enum: ${describeEnum(state!)}");
       if(VxStatus.success==state)
         return loadhomeScreen();
       else if(state==VxStatus.none){
         print("error loading screen");
         if((VxState.store as GroceStore).homescreen.toJson().isEmpty) {
            HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "15", rows: "0",);
            return HomeScreenShimmer();
          }else{
           return loadhomeScreen();
         }
       }
         return HomeScreenShimmer();
      },
    );
  }

  /*void launchWhatsapp({required number, required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print('can\'t open whatsapp');
  }*/
  void launchWhatsApp() async {
    String phone = /*"+918618320591"*/IConstants.secondaryMobile;
    debugPrint("Whatsapp . .. . . .. . .");
    String url() {
      if (Platform.isIOS) {
        debugPrint("Whatsapp1 . .. . . .. . .");
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
        const url = "https://wa.me/?text=YourTextHere";

      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    IConstants.isEnterprise ? SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: ColorCodes
              .primaryColor, //Theme.of(context).accentColor, // status bar color
        )) :
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey,
    ));
    queryData = MediaQuery.of(context);
    wid = queryData!.size.width;
    maxwid = wid! * 0.90;

    bottomNavigationbar() {
      return _isDelivering
          ? SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Spacer(),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  CircleAvatar(
                    radius: 13.0,
                    // minRadius: 50,
                    // maxRadius: 50,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.homeImg,
                      //  color:ColorCodes.greenColor,
                      color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,

                      width: 50,
                      height: 30,
                    ),

                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      S.of(context).home,
                      // "Home",
                      style: TextStyle(
                          color: IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                          //  color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Spacer(),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget) {
                    return GestureDetector(
                      onTap: () {
                        if (value != S
                            .of(context)
                            .not_available_location)
                          /*Navigator.of(context).pushNamed(
                            CategoryScreen.routeName,
                          );*/
                        Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 7.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(Images.categoriesImg,
                              color: ColorCodes.lightgrey,
                              width: 50,
                              height: 30,),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                              S
                                  .of(context)
                                  .categories, //"Categories",
                              style: TextStyle(
                                  color: ColorCodes.grey, fontSize: 10.0)),
                        ],
                      ),
                    );
                  }),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                            Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                            qparms: {"type": "wallet"} );
                          /*Navigator.of(context).pushNamed(
                                WalletScreen.routeName,
                                arguments: {"type": "wallet"});*/
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(Images.walletImg,
                                color: ColorCodes.lightgrey,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S .of(context)
                                    .wallet, //"Wallet",
                                style: TextStyle(
                                    color: ColorCodes.grey, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),

              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                : /*Navigator.of(context).pushNamed(
                              MembershipScreen.routeName,
                            );*/
                            Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.bottomnavMembershipImg,
                                color: ColorCodes.lightgrey,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).membership, //"Membership",
                                style: TextStyle(
                                    color: ColorCodes.grey, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),


              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                : /*Navigator.of(context).pushNamed(
                                MyorderScreen.routeName, arguments: {
                              "orderhistory": ""
                            }
                            );*/
                            Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                                /*parms: {
                              "orderhistory": ""
                            }*/);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.bag,
                                color: ColorCodes.lightgrey,
                                width: 50,
                                height: 30,),
                            ),

                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S
                                    .of(context)
                                    .my_orders, //"My Orders",
                                style: TextStyle(
                                    color: ColorCodes.grey, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),
              if(Features.isShoppingList)
                Spacer(flex: 1),
              if(Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                :
                            /*Navigator.of(context).pushNamed(
                              ShoppinglistScreen.routeName,
                            );*/
                            Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(Images.shoppinglistsImg,
                                color: ColorCodes.lightgrey,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S
                                    .of(context)
                                    .shopping_list, //"Shopping list",
                                style: TextStyle(
                                    color: ColorCodes.grey, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget) {
                      return GestureDetector(
                        onTap: () {
                          if (value != S
                              .of(context)
                              .not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey") &&
                                Features.isLiveChat
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                            )*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                : (Features.isLiveChat && Features.isWhatsapp) ?
                            Navigator.of(context)
                                .pushNamed(
                                CustomerSupportScreen.routeName, arguments: {
                              'name': name,
                              'email': email,
                              'photourl': photourl,
                              'phone': phone,
                            }) :
                            (!Features.isLiveChat && !Features.isWhatsapp) ?
                            Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)

                                :
                            Features.isWhatsapp ?/* launchWhatsapp(
                                number: IConstants.countryCode +
                                    IConstants.secondaryMobile,
                                message: "I want to order Grocery") */launchWhatsApp():
                            Navigator.of(context)
                                .pushNamed(
                                CustomerSupportScreen.routeName, arguments: {
                              'name': name,
                              'email': email,
                              'photourl': photourl,
                              'phone': phone,
                            });
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: (!Features.isLiveChat &&
                                  !Features.isWhatsapp) ?
                              Icon(
                                Icons.search,
                                color: ColorCodes.lightgrey,

                              )
                                  :
                              Image.asset(
                                Features.isLiveChat ? Images.chat : Images
                                    .whatsapp,
                                width: 50,
                                height: 30,
                                color: Features.isLiveChat ? ColorCodes
                                    .lightgrey : null,

                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text((!Features.isLiveChat && !Features.isWhatsapp)
                                ? S
                                .of(context)
                                .search
                                : S
                                .of(context)
                                .chat,
                                style: TextStyle(
                                    color: ColorCodes.grey, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(child: Container());
    }

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final sliderData = Provider.of<Advertise1ItemsList>(context, listen: false);
    return Scaffold(
      key: HomeScreen.scaffoldKey,
      // appBar: ,
      drawer: ResponsiveLayout.isSmallScreen(context) ? AppDrawer() : SizedBox.shrink(),
      backgroundColor: Colors.white /*Theme.of(context).primaryColor*/,
      body: SafeArea(bottom: true,
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                // if(_isRestaurant || !Vx.isWeb)
                  Header(true),
                if (sliderData.websiteItems.length <= 0) SizedBox(height: 5),
                Expanded(
                  child: Vx.isWeb ? Align(child: _body()) : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: _body(),
                  ),
                ),

              ],
            )
        ),
      ),
      bottomNavigationBar: Vx.isWeb ? SizedBox.shrink() : Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: iphonex ? 16.0 : 0.0),
            child: bottomNavigationbar()
        ),
      ),
      floatingActionButton: Vx.isWeb
          ? SizedBox.shrink()
          : Container(
        padding: EdgeInsets.only(
          left: MediaQuery
              .of(context)
              .size
              .width - 80,
          bottom: 80,
        ),
        //margin: EdgeInsets.all(10),
        child: customfloatingbutton(),
      ),
    );
  }

  customfloatingbutton() {
    return ValueListenableBuilder(
        valueListenable: IConstants.currentdeliverylocation,
        builder: (context, value, widget){return VxBuilder(
          // valueListenable: Hive.box<Product>(productBoxName).listenable(),
          builder: (context, GroceStore box, index) {
            if (CartCalculations.itemCount <= 0)
      return GestureDetector(
        onTap: () {

          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        },
        child: Container(
          margin: EdgeInsets.only(left: 80.0, top: 80.0, bottom: 10.0),
          width: 50,
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme
                .of(context)
                .primaryColor,
          ),
          child: GestureDetector(
            onTap: () {

              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            },
            child: Image.asset(
              Images.fcartImg,
              height: 12,
              fit: BoxFit.contain,
              // width: 3,
            ),
          ),
        ),
      );
            return Consumer<CartCalculations>(
              builder: (_, cart, ch) =>
                  FloatButtonBadge(
                    child: ch!,
                    color: Colors.green,
                    value: CartCalculations.itemCount.toString(),
                  ),
              child: GestureDetector(
                onTap: () {

                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                },
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                    },
                    child: Image.asset(
                      Images.fcartImg,
                      height: 12,
                      fit: BoxFit.contain,
                      // width:3,
                      // fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            );
          },mutations: {SetCartItem},
        );});
    /*if (CartCalculations.itemCount <= 0)
      return GestureDetector(
        onTap: () {
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        },
        child: Container(
          margin: EdgeInsets.only(left: 80.0, top: 80.0, bottom: 10.0),
          width: 50,
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme
                .of(context)
                .primaryColor,
          ),
          child: GestureDetector(
            onTap: () {
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            },
            child: Image.asset(
              Images.fcartImg,
              height: 12,
              fit: BoxFit.contain,
              // width: 3,
            ),
          ),
        ),
      );*/
    // return Consumer<CartCalculations>(
    //   builder: (_, cart, ch) =>
    //       FloatButtonBadge(
    //         child: ch!,
    //         color: Colors.green,
    //         value: CartCalculations.itemCount.toString(),
    //       ),
    //   child: GestureDetector(
    //     onTap: () {
    //       Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
    //     },
    //     child: Container(
    //       width: 50,
    //       height: 50,
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(100),
    //         color: Theme
    //             .of(context)
    //             .primaryColor,
    //       ),
    //       child: GestureDetector(
    //         onTap: () {
    //           Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
    //         },
    //         child: Image.asset(
    //           Images.fcartImg,
    //           height: 12,
    //           fit: BoxFit.contain,
    //           // width:3,
    //           // fit: BoxFit.fill,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  ShowpopupforHoliday() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async{
             DateTime now = DateTime.now();
             if (currentBackPressTime == null ||
                 now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
               currentBackPressTime = now;
               Fluttertoast.showToast(
                 msg: "Press Again to Exit!", fontSize: MediaQuery
                   .of(context)
                   .textScaleFactor * 13,);
               return Future.value(false);
             }
             return Future.value(true);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(IConstants.holydayNote),
            actions: <Widget>[
              Vx.isWeb ? SizedBox.shrink() : FlatButton(
                child: Text(
                  S.of(context).ok, //'Ok'
                ),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text(
                  S.of(context).change_location, //'Change'
                ),
                onPressed: () async {
                  PrefUtils.prefs!.setString("formapscreen", "homescreen");
                  Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                  //Navigator.of(context).pushNamed(MapScreen.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ShowPopupforbanner() {
    final bannerpopup = Provider.of<Advertise1ItemsList>(
        context, listen: false);
    // PrefUtils.prefs!.setString("count", )
    setState(() {
      count++;
    });
    PrefUtils.prefs!.setString("descriptionCount", count.toString());
    showDialog(
      context: context,
      barrierDismissible: (Vx.isWeb) ? true : false,
      builder: (BuildContext context) {
        return

          WillPopScope(

            onWillPop: () {
              //SystemNavigator.pop();
              Navigator.of(context).pop();
              return Future.value(false);
            },
            child:
            Center(
              child: Container(
                height: 250,
                width: 300,

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        bannerpopup.popupbanner[0].imageUrl!, height: 250,
                        width: 300,
                        fit: BoxFit.fill,),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          );
      },
    );
  }

  Widget loadhomeScreen() {
    final homedata = (VxState.store as GroceStore).homescreen;

    if (homedata.data != null)
      return SingleChildScrollView(
          child: _isinternet
              ?
          VxBuilder(
              mutations: {SetPrimeryLocation},
              builder: (context, GroceStore value, widget) {
                return !value.userData.delevrystatus! ?
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 80.0, right: 80.0),
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 200.0,
                              child: new Image.asset(
                                  Images.notDeliveringImg)),
                          SizedBox(
                            height: 10.0,
                          ),
                          if(value.userData.area!=null)
                          Text(
                              S.of(context)
                                  .sorry_wedidnt_deliever +
                                  // "Sorry, we don't deliver in " +
                                  value.userData.area.toString()),
                          GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString(
                                  "formapscreen", "homescreen");
                              /*Navigator.of(context)
                                  .pushNamed(MapScreen.routeName);*/
                              Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push);
                            },
                            child: Container(
                              width: 100.0,
                              height: 40.0,
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                borderRadius:
                                BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                    S
                                        .of(context)
                                        .change_location,
                                    //'Change Location',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          if (Vx.isWeb)Footer(
                            address: PrefUtils.prefs!.getString("restaurant_address")!,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    :
                _isDelivering
                    ? homedata != null ?
                Column(
                  children: [
                    if (!PrefUtils.prefs!.containsKey("apikey") && !Vx.isWeb)(Features.isMembership) ? Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.green),
                      width: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                          ? MediaQuery.of(context).size.width * 0.20 : MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(S .of(context).get_membership_and_other,
                            //"Get membership & other benefits",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                /*Navigator.of(context).pushNamed(
                                  SignupSelectionScreen.routeName,
                                );*/
                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                              },
                              child: Text(
                                S
                                    .of(context)
                                    .login_register,
                                //"LOGIN / REGISTER",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(width: 10),
                        ],
                      ),
                    ) : SizedBox.shrink(),
                    if(Features.isWebsiteSlider) if(Vx.isWeb &&
                        !ResponsiveLayout.isSmallScreen(
                            context)) WebsiteSlider(homedata),
                    if(Vx.isWeb && !ResponsiveLayout.isLargeScreen(
                        context))_bannerMain1(homedata),
                    if(!Vx.isWeb)_bannerMain1(homedata),
                    SizedBox(height: 8),
                    if(Features.isCarousel) if (ResponsiveLayout.isSmallScreen(context)) CarouselSliderimage(homedata),
                    SizedBox(height: 5),
                    //TODO: Pending Mutation Intigration
                    if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(
                        context)) WebsiteSmallbanner(homedata),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      //  constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO:Category one mutation i pending due its linked with another page
                          if(Features.isCategoryOne)CategoryOne(
                              homedata),
                          SizedBox(
                            height: 10,
                          ),
                          if(Features.isAdsCategoryOne)
                            (MediaQuery
                                .of(context)
                                .size
                                .width <= 600)
                                ? _advertiseCategoryOne(homedata)
                                : SizedBox.shrink(),
                          if(Features.isBulkUpload)(MediaQuery
                              .of(context)
                              .size
                              .width <= 600) ?
                          Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 8.0),
                              child: Text(
                                S
                                    .of(context)
                                    .for_your_convenience,
                                //"For Your Convenience",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                          )
                              :
                          SizedBox.shrink(),
                          if(Features.isBulkUpload)(MediaQuery
                              .of(context)
                              .size
                              .width <= 600) ? Container(
                            width: MediaQuery.of(context).size
                                .width,
                            margin: EdgeInsets.only(left: 10.0,
                                top: 8.0,
                                right: 10.0,
                                bottom: 15.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // checkskip ?
                                    !PrefUtils.prefs!.containsKey(
                                        "apikey") ?
                                    /*Navigator.of(context).pushNamed(
                                      SignupSelectionScreen.routeName,)*/
                                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                        :
                                        Navigation(context, name: Routename.MultipleImagePicker, navigatore:  NavigatoreTyp.Push);
                                   /* Navigator.of(context).pushNamed(
                                        MultipleImagePicker.routeName,
                                        arguments: {
                                          'subject': "Click & Send",
                                          'type': "click",
                                        });*/
                                  },
                                  child: Image.asset(
                                    Images.bulkImg,
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2) - 15,
                                  ),

                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    launch("tel: " +
                                        IConstants.primaryMobile);
                                  },
                                  child: Image.asset(
                                    Images.supportImg,
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2) - 15,
                                  ),
                                )

                              ],
                            ),
                          ) : SizedBox.shrink(),
                          if(Features.isSellingItems) Vx.isWeb
                                ? _featuredItemweb(homedata)
                                : _featuredItemMobile(homedata),
                          if(Features
                              .isAdsItemsOne) // Advertisement for Featured Items 1_featuredAdsOne(),
                            _featuredAdsOne(homedata),
                          if(Features.isCategoryTwo)
                            CategoryTwo(homedata),
                          /*if(Features.isCategoryTwo)SizedBox(
                      height: 5,
                    ),*/
                          if(Features.isAdsCategoryTwo)
                            _featuredAdsTwo(homedata),
                          if(Features.isAdsCategoryTwo)
                          // SizedBox(
                          //   height: 10,
                          // ),

                            if(Features.isCategoryThree)
                              _categoryThree(homedata),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          if(Features.isVerticalSlider)
                            (MediaQuery
                                .of(context)
                                .size
                                .width <= 600)
                                ? _featuredAdsVertical(homedata)
                                : SizedBox.shrink(),
                          if(Features.isFeatureAdsThree)
                            _featuredAdsThree(homedata),
                          if(Features.isOffersForHomepage)
                            _offersItem(homedata),
                          if(Features.isCategory)
                            (Vx.isWeb)
                                ? _categoryweb(homedata)
                                : _category(homedata),
                          //Categories
                          SizedBox(
                            height: 5,
                          ),
                          // Brands items

                          if(Features.isBrands)
                            _brands(homedata),
                          if(Features.isDiscountItems)
                            _discountItem(homedata),
                        ],
                      ),
                    ),
                    if(Features.isFooter)
                      if (!Vx.isWeb)
                        _footer(homedata),
                    if (Vx.isWeb/* && _isRestaurant*/) Footer(address: _address),
                  ],)
                    : SizedBox.shrink() :
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 80.0, right: 80.0),
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 200.0,
                              child: new Image.asset(
                                  Images.notDeliveringImg)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                              S
                                  .of(context)
                                  .sorry_wedidnt_deliever +
                                  // "Sorry, we don't deliver in " +
                                  PrefUtils.prefs!.getString(
                                      "deliverylocation")!),
                          GestureDetector(
                            onTap: () {
                              PrefUtils.prefs!.setString(
                                  "formapscreen", "homescreen");
                             /* Navigator.of(context)
                                  .pushNamed(MapScreen.routeName);*/
                              Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push);
                            },
                            child: Container(
                              width: 100.0,
                              height: 40.0,
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                borderRadius:
                                BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                    S
                                        .of(context)
                                        .change_location,
                                    //'Change Location',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          if (Vx.isWeb)Footer(
                            address: PrefUtils.prefs!.getString(
                                "restaurant_address")!,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }) :
          SingleChildScrollView(
            child: Center(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 80.0, right: 80.0),
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 200.0,
                        child: new Image.asset(
                            Images.notDeliveringImg)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        S.of(context)
                            .sorry_wedidnt_deliever +
                            // "Sorry, we don't deliver in " +
                            PrefUtils.prefs!.getString(
                                "deliverylocation")!),
                    GestureDetector(
                      onTap: () {
                        PrefUtils.prefs!.setString(
                            "formapscreen", "homescreen");
                        /*Navigator.of(context)
                            .pushNamed(MapScreen.routeName);*/
                        Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push);
                      },
                      child: Container(
                        width: 100.0,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .accentColor,
                          borderRadius:
                          BorderRadius.circular(3.0),
                        ),
                        child: Center(
                            child: Text(
                              S
                                  .of(context)
                                  .change_location, //'Change Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    if (Vx.isWeb)Footer(
                      address: PrefUtils.prefs!.getString(
                          "restaurant_address")!,
                    ),
                  ],
                ),
              ),
            ),
          )

      );
    else {
      HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ??
          PrefUtils.prefs!.getString("tokenid"),
        branch: PrefUtils.prefs!.getString("branch") ?? "15",
        rows: "0",);
      return (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
          ? HomeScreenShimmerWeb()
          : HomeScreenShimmer();
    }
  }

  @override
  onloaddata() {
    // TODO: implement onloaddata
    print("Home Screen Loaded In Singel product screen");
    // throw UnimplementedError();
  }

}

