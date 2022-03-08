import 'package:flutter/material.dart';
import 'package:bachat_mart/widgets/footer.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../constants/IConstants.dart';
import '../assets/ColorCodes.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../providers/branditems.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import 'customer_support_screen.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet-screen';
  Map<String, String>? wallet;
  String type = "";
  String fromScreen = "";
  WalletScreen(Map<String, String> params){
    this.wallet= params;
    this.type = params["type"]??"" ;
    this.fromScreen = params["fromScreen"]??"";

  }
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with Navigations{
  //SharedPreferences prefs;
  bool _isloading = true;
  bool _iswalletbalance = true;
  bool _iswalletlogs = true;
  var walletbalance = "0";
  bool notransaction = true;
  bool checkskip = false;
  var _address = "";
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  String? screen= "";
  bool iphonex = false;
  var name = "", email = "", photourl = "", phone = "";
  GroceStore store = VxState.store;
  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      // final routeArgs =
      //     ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      // final type = routeArgs['type'];
      // screen  = routeArgs['fromScreen'];
      //print("frommmm......"+screen.toString());

      //prefs = await SharedPreferences.getInstance();
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      setState(() {
         /* if (PrefUtils.prefs!.getString('FirstName') != null) {
            if (PrefUtils.prefs!.getString('LastName') != null) {
              name = PrefUtils.prefs!.getString('FirstName') +
                  " " +
                  PrefUtils.prefs!.getString('LastName');
            } else {
              name = PrefUtils.prefs!.getString('FirstName');
            }
          } else {
            name = "";
          }*/
        name = store.userData.username!;
          if (PrefUtils.prefs!.getString('Email') != null) {
            email = PrefUtils.prefs!.getString('Email')!;
          } else {
            email = "";
          }

          if (PrefUtils.prefs!.getString('mobile') != null) {
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

     // Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {
        setState(() {
          _iswalletbalance = false;
          auth.getuserProfile(onsucsess: (value){
            print("wallet");
            HomeScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("tokenid"), branch: PrefUtils.prefs!.getString("branch") ?? "15", rows: "0",);
            if (widget.type=="wallet"/*Routename.Wallet*/)
              walletbalance = /*PrefUtils.prefs!.getString("wallet_balance")*/(VxState.store as GroceStore).prepaid.prepaid.toString();
            else
              walletbalance = /*PrefUtils.prefs!.getString("loyalty_balance")*/(VxState.store as GroceStore).prepaid.loyalty.toString();
          }, onerror: (){
          });

          print("wallet"+(VxState.store as GroceStore).prepaid.prepaid.toString());
          print("wallet111"+(VxState.store as GroceStore).prepaid.loyalty.toString());
        });
    //  });
      Provider.of<BrandItemsList>(context,listen: false).fetchWalletLogs(widget.type.toString()).then((_) {
        setState(() {
          _iswalletlogs = false;
        });
      });
    });

    super.initState();
  }

 /* void launchWhatsapp({required number,required message})async{
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
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    /*final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final type = routeArgs['type'];*/

    bottomNavigationbar() {
      return SingleChildScrollView(
        child: Container(
          height: 60,
          color: Colors.white,
          //color: Color(0xFFfd8100),
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                  // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      maxRadius: 13.0,
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
                    Text(S .of(context).home,
                        style: TextStyle(
                           color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).pushReplacementNamed(
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
                    Text(S .of(context).categories,
                        style: TextStyle(
                            color: ColorCodes.lightgrey, fontSize: 10.0)),
                  ],
                ),
              ),
              if(Features.isWallet)
              Spacer(),
              if(Features.isWallet)
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 7.0,
                    ),
                  CircleAvatar(
                    maxRadius: 13.0,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.walletImg,
                    //  color: ColorCodes.greenColor,
                      color:IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                      width: 50,
                      height: 30,)
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text((widget.type == "wallet") ? S .of(context).wallet : S .of(context).loyalty,
                      style: TextStyle(
                          color:IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.maphome,
                          //color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              if(Features.isMembership)
              Spacer(),
              if(Features.isMembership)
              GestureDetector(
                onTap: () {
                  checkskip
                      ?/* Navigator.of(context).pushNamed(
                          SignupSelectionScreen.routeName,
                        )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      : /*Navigator.of(context).pushReplacementNamed(
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
                    Text(S .of(context).membership,
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
                      MyorderScreen.routeName,arguments: {
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
                      Text(S .of(context).my_orders,
                          style: TextStyle(
                              color: ColorCodes.lightgrey, fontSize: 10.0)),
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
                    /*Navigator.of(context).pushReplacementNamed(
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
                          width: 50,
                          height: 30,),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(S .of(context).shopping_list,
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
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
                    Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search):
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
                      Text((!Features.isLiveChat && !Features.isWhatsapp)? S .of(context).search : S .of(context).chat,
                          style: TextStyle(
                              color: ColorCodes.grey, fontSize: 10.0)),
                    ],
                  ),
                ),
              Spacer(),
            ],
          ),
        ),
      );
    }

    if (!_iswalletbalance && !_iswalletlogs) {
      _isloading = false;
    }
    final walletData = Provider.of<BrandItemsList>(context,listen: false);
    if (walletData.itemswallet.length <= 0) {
      notransaction = true;
    } else {
      notransaction = false;
    }
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color:IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
            onPressed: () async {
              if (screen=="pushNotification")
                {  print("iffff");

                Navigation(context, navigatore: NavigatoreTyp.homenav);
                }
                else if(screen=="notification"){
                    print("elseee");
                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                  //  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                     return Future.value(false);
                }

              else {
                  print("elseee");
                 // Navigation(context, navigatore: NavigatoreTyp.homenav);
                  Navigation(context, navigatore: NavigatoreTyp.Pop);
                  // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                }
              return Future.value(false);
            }

        ),
        titleSpacing: 0,
        title: Text((widget.type == "wallet") ? S .of(context).wallet : S .of(context).loyalty,
        style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                 /*   ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
                  ]
              )
          ),
        ),
      );
    }
    Widget _bodyMobile(){
      return _isloading
          ? (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
        child: LoyalityorWalletShimmer(),
      ): Center(
        child: LoyalityorWalletShimmer(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (widget.type == "wallet")
                        ? Text(
                      Features.iscurrencyformatalign?
                     double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                      IConstants.currencyFormat + " " + double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold),
                    )
                        : Row(
                      children: <Widget>[
                        Text(
                          double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Image.asset(
                          Images.coinImg,
                          width: 21.0,
                          height: 21.0,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    (widget.type == "wallet")
                        ? Text(
                      S .of(context).wallet_balance,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: ColorCodes.greyColor,
                      ),
                    )
                        : Text(
                      S .of(context).available_points,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: ColorCodes.greyColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100.0,
                ),
                Divider(),
              ],
            ),
          ),
          notransaction
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: Image.asset(
                      (widget.type == 'wallet')
                          ? Images.walletTransImg
                          : Images.loyaltyImg,
                      width: 232.0,
                      height: 168.0,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    S .of(context).there_is_no_transaction,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19.0,
                        color: ColorCodes.greyColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
              : Expanded(
            child: new ListView.builder(
              itemCount: walletData.itemswallet.length,
              itemBuilder: (_, i) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Image.asset(
                        walletData.itemswallet[i].img!,
                        fit: BoxFit.fill,
                        width: 40.0,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            walletData.itemswallet[i].title!,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            walletData.itemswallet[i].time!,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            walletData.itemswallet[i].date!,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            walletData.itemswallet[i].amount!,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          (widget.type == "wallet")
                              ?
                              Features.iscurrencyformatalign?
                              Text(
                                S .of(context).total_balance  +
                                    double.parse(walletData.itemswallet[i]
                                        .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat ,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0),
                              ):
                          Text(
                             S .of(context).total_balance  +
                                IConstants.currencyFormat +
                                " " +
                                double.parse(walletData.itemswallet[i]
                                    .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0),
                          )
                              :
                          Text(
                            S .of(context).total_points +
                                double.parse(walletData.itemswallet[i]
                                    .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 60.0,
                        top: 10.0,
                        right: 10.0,
                        bottom: 10.0),
                    child: Text(
                      walletData.itemswallet[i].note!,
                      style: TextStyle(
                          color: Colors.black54, fontSize: 12.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 60.0,
                        top: 10.0,
                        right: 10.0,
                        bottom: 10.0),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
   Widget  _bodyWeb(){
     return Expanded(
       child: SingleChildScrollView(
           child: Column(
               children: [
                 _isloading
       ? ((Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? Center(
         child: LoyalityorWalletShimmer(),
       ): Center(
         child: LoyalityorWalletShimmer(),
       ))
       :

                 Align(
                   alignment: Alignment.center,
                   child: Container(
                     //constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                     padding: EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0,right: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0 ),

                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         SizedBox(height: 15,),
                         Container(
                           margin: EdgeInsets.only(bottom: 20.0),
                           color: Colors.white,
                           child: Row(
                             children: [
                               Padding(
                                 padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                               ),
                               SizedBox(
                                 width: 30.0,
                               ),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   (widget.type == "wallet")
                                       ? Text(
                                     Features.iscurrencyformatalign?
                                     double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " +  IConstants.currencyFormat:
                                     IConstants.currencyFormat + " " + double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                     style: TextStyle(
                                         color: Theme.of(context).primaryColor,
                                         fontSize: 35.0,
                                         fontWeight: FontWeight.bold),
                                   )
                                       : Row(
                                     children: <Widget>[
                                       Text(
                                         double.parse(walletbalance).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                         style: TextStyle(
                                             color: Theme.of(context).primaryColor,
                                             fontSize: 25.0,
                                             fontWeight: FontWeight.bold),
                                       ),
                                       SizedBox(
                                         width: 5.0,
                                       ),
                                       Image.asset(
                                         Images.coinImg,
                                         width: 21.0,
                                         height: 21.0,
                                         alignment: Alignment.center,
                                       ),
                                     ],
                                   ),
                                   SizedBox(
                                     height: 5.0,
                                   ),
                                   (widget.type == "wallet")
                                       ? Text(
                                     S .of(context).wallet_balance,
                                     style: TextStyle(
                                       fontSize: 21.0,
                                       color: ColorCodes.greyColor,
                                     ),
                                   )
                                       : Text(
                                     S .of(context).available_points,
                                     style: TextStyle(
                                       fontSize: 21.0,
                                       color: ColorCodes.greyColor,
                                     ),
                                   )
                                 ],
                               ),
                               SizedBox(
                                 height: 100.0,
                               ),
                               Divider(),
                             ],
                           ),
                         ),
                         notransaction
                             ? Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 Align(
                                   child: Image.asset(
                                     (widget.type == 'wallet')
                                         ? Images.walletTransImg
                                         : Images.loyaltyImg,
                                     width: 232.0,
                                     height: 168.0,
                                     alignment: Alignment.center,
                                   ),
                                 ),
                                 SizedBox(
                                   height: 10.0,
                                 ),
                                 Text(
                                   S .of(context).there_is_no_transaction,
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       fontSize: 19.0,
                                       color: ColorCodes.greyColor,
                                       fontWeight: FontWeight.bold),
                                 ),
                               ],
                             )

                            : new ListView.builder(
                           itemCount: walletData.itemswallet.length,
                           shrinkWrap: true,
                           itemBuilder: (_, i) => Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 children: <Widget>[
                                   SizedBox(
                                     width: 10.0,
                                   ),
                                   Image.asset(
                                     walletData.itemswallet[i].img!,
                                     fit: BoxFit.fill,
                                     width: 40.0,
                                     height: 40.0,
                                   ),
                                   SizedBox(
                                     width: 10.0,
                                   ),
                                   Column(
                                     crossAxisAlignment:
                                     CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(
                                         walletData.itemswallet[i].title!,
                                       ),
                                       SizedBox(
                                         height: 10.0,
                                       ),
                                       Text(
                                         walletData.itemswallet[i].time!,
                                         style: TextStyle(
                                             color: Colors.black54,
                                             fontSize: 12.0),
                                       ),
                                     ],
                                   ),
                                   Spacer(),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     children: <Widget>[
                                       Text(
                                         walletData.itemswallet[i].date!,
                                         style: TextStyle(
                                             color: Colors.black54,
                                             fontWeight: FontWeight.bold,
                                             fontSize: 14.0),
                                       ),
                                       SizedBox(
                                         height: 5.0,
                                       ),
                                       Text(
                                        walletData.itemswallet[i].amount!,
                                       ),
                                       SizedBox(
                                         height: 5.0,
                                       ),
                                       (widget.type == "wallet")
                                           ?
                                           Features.iscurrencyformatalign?
                                           Text(
                                             S .of(context).total_balance  +
                                                 double.parse(walletData.itemswallet[i]
                                                     .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                                 " " + IConstants.currencyFormat ,
                                             style: TextStyle(
                                                 color: Colors.black54,
                                                 fontSize: 12.0),
                                           ):
                                       Text(
                                         S .of(context).total_balance  +
                                             IConstants.currencyFormat +
                                             " " +
                                             double.parse(walletData.itemswallet[i]
                                                 .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                         style: TextStyle(
                                             color: Colors.black54,
                                             fontSize: 12.0),
                                       )
                                           : Text(
                                         S .of(context).total_points +
                                            double.parse(walletData.itemswallet[i]
                                                .closingbalance!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) ,
                                         style: TextStyle(
                                             color: Colors.black54,
                                             fontSize: 12.0),
                                       )
                                     ],
                                   ),
                                   SizedBox(
                                     width: 10.0,
                                   ),
                                 ],
                               ),
                               Container(
                                 margin: EdgeInsets.only(
                                     left: 60.0,
                                     top: 10.0,
                                     right: 10.0,
                                     bottom: 10.0),
                                 child: Text(
                                   walletData.itemswallet[i].note!,
                                   style: TextStyle(
                                       color: Colors.black54, fontSize: 12.0),
                                 ),
                               ),
                               Container(
                                 margin: EdgeInsets.only(
                                     left: 60.0,
                                     top: 10.0,
                                     right: 10.0,
                                     bottom: 10.0),
                                 child: Divider(),
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),

                 SizedBox(height: 40,),
                 if (Vx.isWeb)
                   Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
           ),
       ),
     );
   }
    return WillPopScope(
      onWillPop: (){
        if (screen=="pushNotification")
        {  print("iffff");
        /*Navigator.of(context).pushNamedAndRemoveUntil(
            '/home-screen', (route) => false);*/
        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
        }
        else if(screen=="notification"){
          print("elseee");
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
          //  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
          return Future.value(false);
        }

        else {
          print("elseee");
          /*Navigator.of(context).popUntil(
              ModalRoute.withName(HomeScreen.routeName,));*/
          //Navigator.of(context).pop();
          //Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
          Navigation(context, navigatore: NavigatoreTyp.Pop);
        }
          return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: Column(
          children: <Widget>[
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            Vx.isWeb? _bodyWeb():Flexible(child: _bodyMobile()),
          ],
        ),
        bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() :
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child:bottomNavigationbar(),
          ),
        ),
      ),
    );
  }
}
