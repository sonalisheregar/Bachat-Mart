import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bachat_mart/controller/mutations/home_screen_mutation.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/newmodle/home_page_modle.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../screens/searchitem_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../providers/categoryitems.dart';
import '../widgets/expandable_categories.dart';
import '../constants/IConstants.dart';
import 'customer_support_screen.dart';
import 'myorder_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category-screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with Navigations{
  bool _isWeb = false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool checkskip = false;
  bool iphonex = false;
  var name = "", email = "", photourl = "", phone = "";
  GroceStore store = VxState.store;
 // HomePageData homedata;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
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
        name = store.userData.username??"";
        if (PrefUtils.prefs!.containsKey('Email')) {
          email = PrefUtils.prefs!.getString('Email')!;
        } else {
          email = "";
        }

        if (PrefUtils.prefs!.containsKey('mobile')) {
          phone = PrefUtils.prefs!.getString('mobile')!;
        } else {
          phone = "";
        }
        if (!PrefUtils.prefs!.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }

      });
    });
    super.initState();
  }


  /*void launchWhatsapp({required number,required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
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
    queryData = MediaQuery.of(context);
    wid = queryData!.size.width;
    maxwid = wid! * 0.90;

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).pushReplacementNamed(
                    HomeScreen.routeName,
                  );*/
                  /*Navigator.of(context).popUntil(ModalRoute.withName(
                    HomeScreen.routeName,
                  ));*/
                  Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        Images.homeImg,
                          color: ColorCodes.lightgrey,
                        width: 50,
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(  S.of(context).home,
                      //  "Home",
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 7.0,
                    ),
                  CircleAvatar(
                    radius: 13.0,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.categoriesImg,
                     //   color: ColorCodes.greenColor
                      color:IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                      width: 50,
                      height: 30,),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text( S.of(context).categories,
                      //"Categories",
                      style: TextStyle(
                          color:IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                         // color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              if(Features.isWallet)
              Spacer(),
              if(Features.isWallet)
              GestureDetector(
                onTap: () {
                  (!PrefUtils.prefs!.containsKey("apikey"))
                      ? /*Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                        )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      :
                  /* Navigator.of(context).pushReplacementNamed(
                          WalletScreen.routeName,
                          arguments: {"type": "wallet"});*/
                  Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.PushReplacment,qparms: {
                    "type": "wallet"
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
                      child: Image.asset(Images.walletImg,
                        color: ColorCodes.lightgrey,
                        width: 50,
                        height: 30,),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text( S.of(context).wallet,
                        //"Wallet",
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(Features.isMembership)
              Spacer(),
              if(Features.isMembership)
              GestureDetector(
                onTap: () {
                  (!PrefUtils.prefs!.containsKey("apikey"))
                      ? /*Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                        )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      :
                  /*Navigator.of(context).pushReplacementNamed(
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
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text( S.of(context).membership,
                       // "Membership",
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : /*Navigator.of(context).pushReplacementNamed(
                      MyorderScreen.routeName,
                        arguments: {
                          "orderhistory": ""
                        }
                    );*/
                    Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                       /* parms: {
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
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text( S.of(context).my_orders,
                         // "My Orders",
                          style: TextStyle(
                              color:  ColorCodes.lightgrey, fontSize: 10.0)),
                    ],
                  ),
                ),
              if(Features.isShoppingList)
                Spacer(flex: 1),
              if(Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                   /* Navigator.of(context).pushReplacementNamed(
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
                      Text( S.of(context).shopping_list,
                          //"Shopping list",
                          style: TextStyle(
                              color:  ColorCodes.lightgrey,fontSize: 10.0)),
                    ],
                  ),
                ),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip && Features.isLiveChat
                        ? /*Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                    )*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : (Features.isLiveChat && Features.isWhatsapp)?
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    }):
                    (!Features.isLiveChat && !Features.isWhatsapp)?
                    Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)

                        :
                    Features.isWhatsapp?launchWhatsApp()/*launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery")*/:
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
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
                        child: (!Features.isLiveChat && !Features.isWhatsapp)?
                        Icon(
                          Icons.search,
                          color: ColorCodes.lightgrey,
                        )
                            :
                        Image.asset(
                          Features.isLiveChat?Images.chat: Images.whatsapp,
                          width: 50,
                          height: 30,
                          color: Features.isLiveChat?ColorCodes.lightgrey:null,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((!Features.isLiveChat && !Features.isWhatsapp)? S.of(context).search: S.of(context).chat,
                   //   "Search":"Chat",
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              Spacer(),
              if (_isWeb)
                Footer(
                  address: PrefUtils.prefs!.getString("restaurant_address")!,
                ),
            ],
          ),
        ),
      );
    }

    PreferredSizeWidget _appBar() {
      return AppBar(
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        title: Text( S.of(context).all_categories,
          //"All Categories",
          style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                    /*ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
              ])),
        ),
      );
    }

    Widget _webbody() {
     // final categoriesData = Provider.of<CategoriesItemsList>(context,listen: false);
      return  VxBuilder(
          mutations: {HomeScreenController},
          builder: (ctx,store,VxStatus? state)
      {
        final homedata = (store as GroceStore).homescreen;
        return Column(
          children: <Widget>[
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(
                false),
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Container(
                  padding: EdgeInsets.all(10),
                  color: ColorCodes.lightGreyWebColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S
                          .of(context)
                          .all_categories,
                        // ' All Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if(Features.isFilter)
                        Row(
                          children: [
                            Text(S
                                .of(context)
                                .filter,
                                // "Filter",
                                style: TextStyle(
                                    color: ColorCodes.mediumBlackColor,
                                    fontSize: 14.0)),
                            Container(
                                height: 15.0,
                                child: VerticalDivider(
                                    color: ColorCodes.greyColor)),
                            Text(S
                                .of(context)
                                .sort,
                                //"Sort",
                                style: TextStyle(
                                    color: ColorCodes.mediumBlackColor,
                                    fontSize: 14.0)),
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              Images.sortImg,
                              color: ColorCodes.mediumBlackColor,
                              width: 22,
                              height: 16.0,
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                    ],
                  )),
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Divider(),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: (_isWeb &&
                            !ResponsiveLayout.isSmallScreen(context))
                            ? BoxConstraints(maxWidth: maxwid!)
                            : null,
                        child: Column(
                          children: [
                           /* if (categoriesData.items.length > 0)
                              SizedBox(
                                height: 10,
                              ),*/
                           /* if (categoriesData.items.length >
                                0) */
                              ExpansionCategory(homedata),
                            SizedBox(
                              height: 20,
                            ),

                          ],
                        ),
                      ),
                      if (_isWeb)
                        Footer(
                          address: PrefUtils.prefs!.getString(
                              "restaurant_address")!,
                        ),
                    ],
                  )
              ),
            ),
          ],
        );
      });
    }

    return ResponsiveLayout.isSmallScreen(context)
        ? Scaffold(
            appBar: ResponsiveLayout.isSmallScreen(context) ? _appBar() : PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox.shrink()),
            body: _webbody(),
            bottomNavigationBar:
                _isWeb ? SizedBox.shrink() : Container(
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
                      child: bottomNavigationbar()
                  ),
                ),
          )
        : Scaffold(
            body: _webbody(),
          );
  }
}
