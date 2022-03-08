import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bachat_mart/controller/mutations/address_mutation.dart';
import 'package:bachat_mart/controller/mutations/cart_mutation.dart';
import 'package:bachat_mart/controller/mutations/cat_and_product_mutation.dart';
import 'package:bachat_mart/controller/mutations/home_screen_mutation.dart';
import 'package:bachat_mart/controller/mutations/login.dart';
import 'package:bachat_mart/models/newmodle/category_modle.dart';
import 'package:bachat_mart/models/newmodle/user.dart';
import 'package:bachat_mart/repository/authenticate/AuthRepo.dart';
import 'package:bachat_mart/screens/login_screen.dart';
import 'package:bachat_mart/components/login_web.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../constants/api.dart';
import '../controller/mutations/languagemutations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
import '../screens/MySubscriptionScreen.dart';
import '../widgets/header/bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/controlled_scroll_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import '../screens/items_screen.dart';

import '../providers/itemslist.dart';
import '../screens/singleproduct_screen.dart';
import '../utils/prefUtils.dart';
import '../screens/addressbook_screen.dart';
import '../screens/customer_support_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/myorder_screen.dart';
import '../screens/shoppinglist_screen.dart';
import '../screens/wallet_screen.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../screens/home_screen.dart';
import '../screens/policy_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../providers/branditems.dart';
import '../providers/categoryitems.dart';
import '../utils/ResponsiveLayout.dart';
import '../data/calculations.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../providers/notificationitems.dart';
import '../providers/sellingitems.dart';
import '../screens/cart_screen.dart';
import '../screens/category_screen.dart';
import '../screens/map_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/searchitem_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../widgets/badge.dart';
import "package:http/http.dart" as http;
import '../assets/images.dart';
import 'CoustomeDailogs/slectlanguageDailogBox.dart';
import 'package:permission_handler/permission_handler.dart';

//enable this for web
//import 'dart:js' as js;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Header extends StatefulWidget {
  bool _isHome = false;
  Function(String,String,int,int)? onSubcatClick;
  Function(String)? onsearchClick;
  Header(this._isHome,{this.onsearchClick,this.onSubcatClick });
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with Navigations {

  final _form = GlobalKey<FormState>();
  String brandsName = "";
  bool _isDelivering = true;
  bool _isSkip = false;
  String _deliverLocation = "";
  bool checkSkip = false;
  bool _isshow = true;
  String photourl = "";
  String name = "";
  String phone = "";
  // String countryName = "${CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name}";
  bool _isAvailable = false;
  TextEditingController controller = TextEditingController();
  bool _showOtp = false;
  int _timeRemaining = 30;
  Timer? _timer;
  String apple = "";
  String email = "";
  String mobile = "";
  String tokenid = "";
  GlobalKey? actionKey;
  double? height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  bool isDropdownSearch = false;
  OverlayEntry? floatingDropdown;
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  final _lnameFocusNode = FocusNode();
  String fn = "";
  String ln = "";
  String ea = "";
  // bool Vx.isWeb = false;
  bool _isIOs = false;
  bool _isAndroid = false;
  StreamController<int>? _events;
  FocusNode _focus = new FocusNode();
  ItemsList searchData = ItemsList();
  List searchDispaly = [];
  String searchValue = "";
  bool _isSearchShow = false;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();



  String? otp1, otp2, otp3, otp4;

  var otpvalue = "";

  final _debouncer = Debouncer(milliseconds: 500);

  MediaQueryData? queryData;
  double? hig;
  double? maxhig;
  double? hig1;
  double? maxhig2;

  ScrollController cstscrollcontroller = ScrollController();

  bool lbtn = true;

  bool rbtn = true;
  GroceStore store = VxState.store;
  //String _deliveryLocmain = "";
  //String _deliverySubloc = "";
  BuildContext? dailogcontext;
  StateSetter? searchliststate;
  bool issearchloading = false;
  CategoriesItemsList? subNestedcategoryData;
  double? _lat, _lng;

  Position? position;
  int count = 0;
  Timer? timer;

  String _appletoken = "";
  String channel = "";
  Auth _auth = Auth();
  @override
  void initState() {
    print("calling header");

    // Hive.openBox<Product>(productBoxName);
    _events = new StreamController<int>.broadcast();
    _events!.add(30);
  /*  try {
      if (Platform.isIOS) {
        setState(() {
          Vx.isWeb = false;
          _isIOs = true;
        });
      } else {
        setState(() {
          Vx.isWeb = false;
          _isAndroid = true;
        });
      }
    } catch (e) {
      setState(() {
        Vx.isWeb = true;
      });
    }*/
    Future.delayed(Duration.zero, () async {
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        _appletoken = PrefUtils.prefs!.getString('apple')!;
      } else {
        _appletoken = "";
      }
      try {
        if (Platform.isIOS) {
          userappauth.login(AuthPlatform.ios,onSucsess: (SocialAuthUser value,_){
            if(value.newuser!){
              userappauth.register(data:RegisterAuthBodyParm(
                username: value.name,
                email: value.email,
                branch: PrefUtils.prefs!.getString("branch"),
                tokenId:PrefUtils.prefs!.getString("ftokenid"),
                guestUserId:PrefUtils.prefs!.getString("tokenid"),
                device:"IOS",
                referralid:PrefUtils.prefs!.getString("referCodeDynamic")!,
                path: _appletoken ,
                mobileNumber: ((PrefUtils.prefs!.getString('Mobilenum'))??""),
              ),onSucsess: (UserData response){
                //  PrefUtils.prefs!.setString('FirstName', response.username);
                //  PrefUtils.prefs!.setString('LastName', "");
                //  PrefUtils.prefs!.setString('Email', response.email);

                /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/


                if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
                  addprimarylocation();
                }
                else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
                  // Navigator.of(context).pop();
                  addprimarylocation();
                }
                else {
                  //Navigator.of(context).pop();

                  PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
                  PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
                  PrefUtils.prefs!.setString("ismap", "true");
                  PrefUtils.prefs!.setString("isdelivering", "true");
                  addprimarylocation();
                  //prefs.setString("formapscreen", "homescreen");
                  //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
                  /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
                }
              },onerror: (message){
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: message);
              });
            }
            else{
              PrefUtils.prefs!.setString("apikey",value.id!);
              _auth.getuserProfile(onsucsess: (value){
               /* Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);*/
                Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);

              },onerror: (){

              });

              /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
              ///navigatev to home page
            }

          },onerror:(message){
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: message);
          });
        }
      } catch (e) {}
      if (!Vx.isWeb) _listenotp();
      PrimeryLocation().fetchPrimarylocation();
      // fetchPrimary();
      // SetPrimeryLocation();
      if(PrefUtils.prefs!.getString("referCodeDynamic") == "" || PrefUtils.prefs!.getString("referCodeDynamic") == null){
        _referController.text = "";
      }else{
        _referController.text = PrefUtils.prefs!.getString("referCodeDynamic")!;
      }
      debugPrint("checkSkip...."+PrefUtils.prefs!.containsKey('apikey').toString());
      checkSkip = !PrefUtils.prefs!.containsKey('apikey');
      setState(() {

          if (PrefUtils.prefs!.getString('applesignin') == "yes") {
            apple = PrefUtils.prefs!.getString('apple')!;
          } else {
            apple = "";
          }

          name = (VxState.store as GroceStore).userData.username??"";
          debugPrint("yes....."+name+",,,,"+(VxState.store as GroceStore).userData.username.toString());
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')??"";
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')??"";
          tokenid = PrefUtils.prefs!.getString('tokenid')??"";

        if (PrefUtils.prefs!.getString('mobile') != null) {
          phone = PrefUtils.prefs!.getString('mobile')!;
        } else {
          phone = "";
        }
        if (PrefUtils.prefs!.getString('photoUrl') != null) {
          photourl = PrefUtils.prefs!.getString('photoUrl')!;
        } else {
          photourl = "";
        }

        if (!PrefUtils.prefs!.containsKey("apikey")) {
          _isSkip = true;
        } else {
          _isSkip = false;
        }


      setState(() {
        _deliverLocation = PrefUtils.prefs!.getString("restaurant_location")!;
      });
       if ((!PrefUtils.prefs!.containsKey("welcomeSheet") && !PrefUtils.prefs!.containsKey('apikey') ) && !Vx.isWeb)
          welcomeSheet();
      });
    });
    _googleSignIn.signInSilently();
    // _focus.addListener(_onFocusChange);
    super.initState();
  }
  void onremovedDrpDown(){
    if (isDropdownSearch) {
      floatingDropdown!.remove();
      floatingDropdown = null;
      isDropdownSearch = false;
    }
  }
  void onadddDrpDown(){
    if (floatingDropdown==null) {
      floatingDropdown = _searchBar();
      Overlay.of(context)!.insert(floatingDropdown!);
      isDropdownSearch = true;
    }
  }
  void _onFocusChange() {
    setState(() {
      //drop
      if (isDropdownSearch) {
        floatingDropdown!.remove();
        floatingDropdown = null;
      } else {
        floatingDropdown = _searchBar();
        Overlay.of(context)!.insert(floatingDropdown!);
      }
      isDropdownSearch = !isDropdownSearch;
    });
  }

  search(String value) async {
    debugPrint("search things....");
    issearchloading = true;
    await Provider.of<ItemsList>(context, listen: false).fetchsearchItems(value).then((isempty) {
      searchData = Provider.of<ItemsList>(context, listen: false);
      Future.delayed(Duration(milliseconds: 100), () {
        searchliststate!(() {
          issearchloading = false;
          searchDispaly = searchData.searchitems.toList();

          //searchDispaly = searchData.searchitems.title;
          /*searchData = Provider.of<ItemsList>(context, listen: false);
        searchDispaly = searchData.searchitems
            .where((elem) =>
            elem.title
                .toString()
                .toLowerCase()
                .contains(searchValue.toLowerCase()))
            .toList();
        _isSearchShow = true;*/
        });
      });
    });
  }

  onSubmit(String value) async {
    debugPrint("onsubmit.."+value.toString());
    //FocusScope.of(context).requestFocus(_focus);

    // await Provider.of<ItemsList>(context, listen: false).fetchsearchItems(value,true).then((_) {
    //   searchData = Provider.of<ItemsList>(context, listen: false);
    //   searchDispaly = searchData.searchitems.toList();
    //   Navigator.of(context).pushNamed(SearchitemScreen.routeName, arguments: {
    //     "itemname": value,
    //   });
    // });
    if(widget.onsearchClick==null)
      Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search,qparms: {
        "itemname": value,
      });
    else{
      _focus = new FocusNode();
      FocusScope.of(context).requestFocus(_focus);
      widget.onsearchClick!(value);}
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_timeRemaining > 0) ? _timeRemaining-- : _timer!.cancel();
      //});
      _events!.add(_timeRemaining);
    });
  }

  void _listenotp() async {
    await SmsAutoFill().listenForCode;
  }

  welcomeSheet() {
    PrefUtils.prefs!.setBool("welcomeSheet", true);
    _deliverLocation = PrefUtils.prefs!.getString("deliverylocation")??IConstants.currentdeliverylocation.value;
    //debugPrint("_deliverLocation ...." + _deliverLocation);
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              color: ColorCodes.whiteColor,
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new RichText(
                        text: new TextSpan(
                          style: new TextStyle(

                          ),
                          children: <TextSpan>[
                            new TextSpan(text: S .of(context).welcome + " ", style: TextStyle(fontSize: 18.0, color: ColorCodes.greyColor, fontWeight: FontWeight.bold)),
                            new TextSpan(text: IConstants.APP_NAME, style: TextStyle(fontSize: 20.0, color: ColorCodes.darkgreen, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      FlatButton(
                        height: 0,
                        minWidth: 0,
                        padding: EdgeInsets.all(0),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: ColorCodes.grey,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(Images.cancelImg))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Text(
                      S .of(context).product_and_location_specified,
                      style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold,fontSize: 14.0)
                    //'Product catalogue and offers are location specific'
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Images.otherConfirm, height: 20, width: 20,),
                      Container(
                        width:  MediaQuery.of(context).size.width * 0.45,
                        child: FlatButton(
                          height: 0,
                          minWidth: 0,
                          padding: EdgeInsets.only(left: 3, top: 0, right: 0.0, bottom: 0),
                          textColor: ColorCodes.darkgreen,
                          child: Text(S .of(context).explore + " " + (PrefUtils.prefs!.getString("restaurant_location")??""), textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,maxLines: 1,

                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                         ,

                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Center(child: Text(S .of(context).or, style: TextStyle(fontSize: 13.0, color: ColorCodes.darkGrey))),
                      Container(
                        child: FlatButton(
                          height: 0,
                          minWidth: 0,
                          padding: EdgeInsets.only(left: 3.0, top: 0, right: 0.0, bottom: 0),
                          textColor: ColorCodes.darkgreen,
                          child: Text(S .of(context).change_location, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
                          onPressed: () {
                            PrefUtils.prefs!.setString("formapscreen", "homescreen");
                            Navigator.pop(context);
                           /* Navigator.of(context).pushNamed(MapScreen.routeName,
                                arguments: {
                                  "valnext": "",
                                });*/
                            Navigation(context, name: Routename.MapScreen,navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "valnext": "",
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S .of(context).existing_customer,
                          style: TextStyle(color: ColorCodes.greyColor, fontWeight: FontWeight.bold,fontSize:17)
                        //'Existing customer?'
                      ),
                      FlatButton(
                        //height: 5,
                        // minWidth: 0,
                        //padding: EdgeInsets.only(right:0.0),
                        textColor:ColorCodes.greenColor,
                        child: Text(S .of(context).login_small, style: TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                        onPressed: () {
                          /*Navigator.of(context).pushReplacementNamed(
                            SignupSelectionScreen.routeName,);*/
                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  if(store.language.languages.length > 1)
                    Container(

                      //color: ColorCodes.mediumgren,
                      // padding: EdgeInsets.only(top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(store.language.languages.length > 1)
                            Text(S .of(context).chose_your_preferred_language,   //'Choose your preferred language' ,
                                style: TextStyle(
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold,fontSize: 14)),
                          GridView.builder(
                            shrinkWrap: true,
                            controller: new ScrollController(keepScrollOffset: false),
                            itemCount: store.language.languages.length,
                            padding: ResponsiveLayout.isSmallScreen(context)? const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0):
                            const EdgeInsets.only(bottom:10.0),
                            itemBuilder: (ctx, i) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  textColor: ColorCodes.darkgreen,
                                  child: Row(

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Padding( padding: EdgeInsets.only(left:5.0),),
                                      Text(store.language.languages[i].localName!,
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16,
                                              fontWeight: store.language.languages[i].code == store.language.language.code ? FontWeight.bold : FontWeight.normal)),
                                       SizedBox(width: 30.0,),
                                      store.language.languages[i].code == store.language.language.code ?
                                      Container(

                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          //margin: EdgeInsets.all(5.5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.check,
                                              color: Theme.of(context).primaryColor,
                                              size: 15.0),
                                        ),
                                      )
                                          :
                                      Icon(
                                          Icons.radio_button_off_outlined,
                                          color: Theme.of(context).primaryColor)
                                    ],
                                  ),
                                  onPressed: () {
                                    SetLanguage(code: store.language.languages[i].code!);
                                    Navigator.pop(dailogcontext!);
                                    Navigator.of(context).pop();
                                    Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                                    //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                                  },
                                ),
                              ],
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.0,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 1,
                            ),
                          )
                        ],
                      ),
                    ),

                  /*if(store.language.languages.length > 1)
                   Text(S .of(context).chose_your_preferred_language,   //'Choose your preferred language' ,
                      style: TextStyle(color: Color(0xD2020226),fontWeight: FontWeight.bold,fontSize: 16)),
                  if(store.language.languages.length > 1)
                    // SizedBox((height:3,))
                  Container(
                    //height:5,
                    width: double.infinity,
                    //color: ColorCodes.lightBlueColor.withOpacity(0.44),
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: VxBuilder(
                      mutations:{SetLanguage},
                      builder: (BuildContext, dynamic,VxStatus){
                        return VStack([
                          ...store.language.languages.map((e) => HStack([e.localName.text.bold.size(16).color(e.code==store.language.language.code?ColorCodes.primaryColor:ColorCodes.blackColor).make().p12(),
                            Icon(Icons.check,
                                color: e.code==store.language.language.code? Theme.of(context).primaryColor: ColorCodes.whiteColor,
                                size: 24),
                          ],alignment: MainAxisAlignment.spaceBetween,).box.color(e.code==store.language.language.code?ColorCodes.lightColor:ColorCodes.whiteColor).make().px4().cornerRadius(12).onTap(() {
                            SetLanguage(code: e.code);
                            Navigator.pop(dailogcontext);
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                          })).toList()
                        ],crossAlignment: CrossAxisAlignment.stretch,).centered().px32().py12();
                      },
                    ),
                  ),*/
                  /*     Container(
                    height: 40,
                    width: double.infinity,
                    color: Theme.of(context).accentColor,
                    child: Center(
                      child: Container(
                        width: 32.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: ColorCodes.whiteColor,
                          border: Border.all(color: ColorCodes.whiteColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )*/
                  // SizedBox(height: 30,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //for login dropdown
  OverlayEntry _createLoginDropdown() {
    return OverlayEntry(builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 220.0,
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: _loginDropdown(),
            )),
      );

    });
  }

  //for search bar
  OverlayEntry _searchBar() {
    // RenderBox renderBox = context.findRenderObject();
    // var size = renderBox.size;
    return OverlayEntry(builder: (context) {
      return Positioned(
        width: MediaQuery.of(context).size.width/3,
        top: 70,
        right: 340,
        child: Container(
          color: ColorCodes.whiteColor,
          child: searchList(),
        ),
      );
    });
  }

  Widget searchList() {
    final popularSearch = (VxState.store as GroceStore).homescreen.data!.featuredByCart;
    return StatefulBuilder(
      builder: (context,setState){
        this.searchliststate = setState;
        return  Column(
          children: [
            Material(
              elevation: 35,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(8.0),
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if(issearchloading)
                        Container(
                          margin: EdgeInsets.all(20),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            //color: ColorCodes.primaryColor,
                            minHeight: 5,
                          ),
                        ),
                      if (_isSearchShow)
                        SizedBox(
                          child: new ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: searchDispaly.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, i) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final variationdate = searchData.findByIdsearch(searchDispaly[i].id.toString());
                                    /// onclick remove popub search list
                                    onremovedDrpDown();
                                    Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":variationdate.first.varid!});
                                    // Navigator.of(context).pushNamed(
                                    //     SingleproductScreen.routeName,
                                    //     arguments: {
                                    //       "itemid": searchDispaly[i].id.toString(),
                                    //       "itemname":
                                    //       searchDispaly[i].title.toString(),
                                    //       "itemimg":
                                    //       searchDispaly[i].imageUrl.toString(),
                                    //       "eligibleforexpress": searchDispaly[i].eligible_for_express.toString(),
                                    //       "delivery":searchDispaly[i].delivery.toString(),
                                    //       "duration":searchDispaly[i].duration.toString(),
                                    //       "durationType": searchDispaly[i].durationType.toString(),
                                    //       "note": searchDispaly[i].note.toString(),
                                    //     });

                                    //onSubmit(searchValue);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: ColorCodes.whiteColor,
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.0,
                                            color:
                                            Theme.of(context).backgroundColor,
                                          ),
                                        )),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      searchDispaly[i].title,
                                      style: TextStyle(
                                          color: ColorCodes.blackColor, fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.all(14.0),
                        child: Text(
                          S .of(context).popular_search,
                          //"Popular Searches"
                        ),
                      ),
                      SizedBox(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: popularSearch!.data!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) => Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ///remove dropdown for popular search list
                                  onremovedDrpDown();
                                  Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":popularSearch.data![i].priceVariation!.first.id!});
                                  // Navigator.of(context).pushNamed(
                                  //     SingleproductScreen.routeName,
                                  //     arguments: {
                                  //       "itemid":
                                  //       popularSearch.data![i].id.toString(),
                                  //       "itemname":
                                  //       popularSearch.data![i].itemName.toString(),
                                  //       "itemimg": popularSearch.data![i].itemFeaturedImage??""
                                  //           .toString(),
                                  //       "eligibleforexpress": popularSearch.data![i].eligibleForExpress.toString(),
                                  //       "delivery":popularSearch.data![i].delivery.toString(),
                                  //       "duration":popularSearch.data![i].duration.toString(),
                                  //       "durationType": popularSearch.data![i].deliveryDuration.durationType.toString(),
                                  //       "note": "",
                                  //     });
                                  // FocusScope.of(context)
                                  //     .requestFocus(new FocusNode());
                                  // onSubmit(popularSearch.data[i].itemName);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(14.0),
                                  decoration: BoxDecoration(
                                      color: ColorCodes.whiteColor,
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2.0,
                                          color: Theme.of(context).backgroundColor,
                                        ),
                                      )),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    popularSearch.data![i].itemName!,
                                    style: TextStyle(
                                        color: ColorCodes.blackColor, fontSize: 12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _timer?.cancel();
    _focus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapUp: (TapUpDetails details) => onTapDown(context, details),
      child: Container(
        color: ColorCodes.whiteColor,
        child: ResponsiveLayout.isSmallScreen(context) || !Vx.isWeb
            ? createHeaderForMobile()
            : createHeaderForWeb(),
      ),
    );
  }

  addFirstnameToSF(String value) async {
    PrefUtils.prefs!.setString('FirstName', value);
  }

  addLastnameToSF(String value) async {
    PrefUtils.prefs!.setString('LastName', value);
  }

  addEmailToSF(String value) async {
    PrefUtils.prefs!.setString('Email', value);
  }

  Future<void> checkemail() async {
    try {
      final response = await http.post(Api.emailCheck, body: {
        "email": PrefUtils.prefs!.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
          Navigator.of(context).pop();
          (Vx.isWeb)?Navigator.of(context).pop():null;
           Fluttertoast.showToast(
              msg:  S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);
        } else if (responseJson['type'].toString() == "new") {
          return SignupUser();
        }
      } else {
         Fluttertoast.showToast(msg:  S .of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }

  addMobilenumToSF(String value) async {
    PrefUtils.prefs!.setString('Mobilenum', value);
  }

  addReferralToSF(String value)async{
    PrefUtils.prefs!.setString('referid', value);
  }
  _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();

    Provider.of<BrandItemsList>(context, listen: false).LoginUser();
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    _dialogforOtp();
  }

  Future<void> checkMobilenum() async {
    try {

      final response = await http.post(Api.mobileCheck, body: {
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
           Fluttertoast.showToast(msg:  S .of(context).mobile_exists,//"Mobile number already exists!!!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,);
        } else if (responseJson['type'].toString() == "new") {
          Provider.of<BrandItemsList>(context, listen: false).LoginUser();
          Navigator.of(context).pop();
           _dialogforOtp;
        }
      } else {
         Fluttertoast.showToast(msg:  S .of(context).something_went_wrong,//"Something went wrong!!!",
          fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _handleSignIn() async {
    try {
      final response = await _googleSignIn.signIn();
      response!.email.toString();
      response.displayName.toString();
      response.photoUrl.toString();
      PrefUtils.prefs!.setString('FirstName', response.displayName.toString());
      PrefUtils.prefs!.setString('LastName', "");
      PrefUtils.prefs!.setString('Email', response.email.toString());
      PrefUtils.prefs!.setString("photoUrl", response.photoUrl.toString());

      PrefUtils.prefs!.setString('prevscreen', "signingoogle");
      checkusertype("Googlesigin");
    } catch (error) {
      Navigator.of(context).pop();

      Fluttertoast.showToast(
          msg:  S .of(context).sign_in_failed,//"Sign in failed!",
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
  }

  void initiateFacebookLogin() async {
    //web.......
    final facebookSignIn = FacebookLoginWeb();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    //app........
    /*final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    final result = await facebookLogin.logIn(['email']);*/
    switch (result.status) {
      case FacebookLoginStatus.error:
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_failed,//"Sign in failed!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: ColorCodes.blackColor,
            textColor: ColorCodes.whiteColor);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S .of(context).sign_in_cancelledbyuser,//"Sign in cancelled by user!",
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: ColorCodes.blackColor,
            textColor: ColorCodes.whiteColor);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);

        PrefUtils.prefs!.setString("FBAccessToken", token);

        PrefUtils.prefs!.setString('FirstName', profile['first_name'].toString());
        PrefUtils.prefs!.setString('LastName', profile['last_name'].toString());
        PrefUtils.prefs!.setString('Email', profile['email'].toString());

        final pictureencode = json.encode(profile['picture']);
        final picturedecode = json.decode(pictureencode);

        final dataencode = json.encode(picturedecode['data']);
        final datadecode = json.decode(dataencode);

        PrefUtils.prefs!.setString("photoUrl", datadecode['url'].toString());

        PrefUtils.prefs!.setString('prevscreen', "signinfacebook");
        checkusertype("Facebooksigin");
        //onLoginStatusChanged(true);
        break;
    }
  }

  Future<void> addprimarylocation() async {

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs!.containsKey("apikey")? PrefUtils.prefs!.getString("apikey"): PrefUtils.prefs!.getString("ftokenid"),
        "latitude": PrefUtils.prefs!.getString("latitude"),
        "longitude":PrefUtils.prefs!.getString("longitude"),
        "area": IConstants.deliverylocationmain.value.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      if (responseJson["data"].toString() == "true") {
        if(PrefUtils.prefs!.getString("ismap").toString()=="true") {
          if(PrefUtils.prefs!.getString("fromcart").toString()=="cart_screen"){
            // Navigator.of(context).pop();
           /* Navigator.of(context)
                .pushNamed(LoginScreen.routeName,);*/
            Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push);

          }
          else{
            /* Navigator.of(context).pop();
            return Navigator.of(context).pushReplacementNamed(
              HomeScreen.routeName,
            );*/
          /*  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
            Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);

          }


        }
        else if(PrefUtils.prefs!.getString("isdelivering").toString()=="true"){


        /*  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);


        }
        else {
          PrefUtils.prefs!.setString("formapscreen", "homescreen");
          PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
          PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
          PrefUtils.prefs!.setString("ismap", "true");
          PrefUtils.prefs!.setString("isdelivering", "true");
          /*Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);

          //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
          /* Navigator.of(context).pushReplacementNamed(
            LocationScreen.routeName,
          );*/
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }


  Future<void> appleLogIn() async {
    PrefUtils.prefs!.setString('applesignin', "yes");
    _dialogforProcessing();
    PrefUtils.prefs!.setString('skip', "no");
    userappauth.login(AuthPlatform.ios,onSucsess: (SocialAuthUser value,_){
      if(value.newuser!){
        userappauth.register(data:RegisterAuthBodyParm(
          username: value.name,
          email: value.email,
          branch: PrefUtils.prefs!.getString("branch"),
          tokenId:PrefUtils.prefs!.getString("ftokenid"),
          guestUserId:PrefUtils.prefs!.getString("tokenid"),
          device:channel,
          referralid:_referController.text,
          path: _appletoken ,
          mobileNumber: ((PrefUtils.prefs!.getString('Mobilenum'))??""),
        ),onSucsess: (UserData response){
          //  PrefUtils.prefs!.setString('FirstName', response.username);
          //  PrefUtils.prefs!.setString('LastName', "");
          //  PrefUtils.prefs!.setString('Email', response.email);

          /* Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);*/


          if (PrefUtils.prefs!.getString("ismap").toString() == "true") {
            addprimarylocation();
          }
          else if (PrefUtils.prefs!.getString("isdelivering").toString() == "true") {
            // Navigator.of(context).pop();
            addprimarylocation();
          }
          else {
            //Navigator.of(context).pop();

            PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
            PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
            PrefUtils.prefs!.setString("ismap", "true");
            PrefUtils.prefs!.setString("isdelivering", "true");
            addprimarylocation();
            //prefs.setString("formapscreen", "homescreen");
            //Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            /* Navigator.of(context).pushReplacementNamed(
              LocationScreen.routeName,
            );*/
          }
        },onerror: (message){
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: message);
        });
      }
      else{
        PrefUtils.prefs!.setString("apikey",value.id!);
        _auth.getuserProfile(onsucsess: (value){
          /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);

        },onerror: (){

        });

        /*Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);*/
        ///navigatev to home page
      }

    },onerror:(message){
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: message);
    });
  }

  Future<void> checkusertype(String prev) async {
    try {
      var response;
      if (prev == "signInApple") {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs!.getString('Email'),
          "tokenId": PrefUtils.prefs!.getString('tokenid'),
          "apple":PrefUtils. prefs!.getString('apple'),
        });
      } else {
        response = await http.post(Api.emailLogin, body: {
          "email": PrefUtils.prefs!.getString('Email'),
          "tokenId": PrefUtils.prefs!.getString('tokenid'),
        });
      }

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['type'].toString() == "old") {
        if (responseJson['data'] != "null") {
          final data = responseJson['data'] as Map<String, dynamic>;

          if (responseJson['status'].toString() == "true") {
            PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
            PrefUtils.prefs!.setString('userID', data['userID'].toString());
            PrefUtils.prefs!.setString('membership', data['membership'].toString());
            PrefUtils. prefs!.setString("mobile", data['mobile'].toString());
            PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
            PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          } else if (responseJson['status'].toString() == "false") {}
        }

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkSkip = false;
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
          //name = prefs.getString('FirstName') + " " + prefs.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone =PrefUtils. prefs!.getString('mobile')!;
          } else {
            phone = "";
          }
          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        // _getprimarylocation();
        PrimeryLocation().fetchPrimarylocation();
      } else {
        Navigator.of(context).pop();
        _dialogforRefer(context);
        // SignupUser();
        //   Navigator.of(context).pop();
        /* Navigator.of(context).pushReplacementNamed(
          LoginScreen.routeName,
        );*/
      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  _dialogforRefer(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 200.0,
                  width:200,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S .of(context).refer_earn,//"Refer And Earn",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: _referController,
                        decoration: InputDecoration(
                          hintText: S .of(context).refer_earn,//"Refer and Earn (optional)",//"Reasons (Optional)",
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                        ),
                        minLines: 2,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          _dialogforProcessing();
                          SignupUser();
                        },
                        child: Text(
                          S .of(context).next ,//translate('forconvience.Next'), // "Next",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  )),
            );
          });
        });
  }


  Future<void> facebooklogin() async {
    PrefUtils.prefs!.setString('skip', "no");
    PrefUtils.prefs!.setString('applesignin', "no");
    initiateFacebookLogin();
  }

  _verifyOtp() async {
    //var otpval = otp1 + otp2 + otp3 + otp4;


    if (controller.text == PrefUtils.prefs!.getString('Otp')) {


      if (PrefUtils.prefs!.getString('type') == "old") {
        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkSkip = false;
          /*if (PrefUtils.prefs!.getString('FirstName') != null) {
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
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;


          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        // _getprimarylocation();
        // PrimeryLocation().fetchPrimarylocation();
      } else {
        if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signupselectionscreen' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signInApple' ||
            PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {
          return signupUser();
        } else {
          PrefUtils.prefs!.setString('prevscreen', "otpconfirmscreen");
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          _dialogforAddInfo();
        }
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      //_customToast();
      Fluttertoast.showToast(msg: S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!! " ,
          backgroundColor: Colors.black87, textColor: Colors.white,
          fontSize:MediaQuery.of(context).textScaleFactor *13);

    }
  }

  Future<void> Otpin30sec() async {
    try {
      final response = await http.post(Api.resendOtp30, body: {
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {

      throw error;
    }
  }

  Future<void> otpCall() async {
    try {

      final response = await http.post(Api.resendOtpCall, body: {
        "resOtp": PrefUtils.prefs!.getString('Otp'),
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
      });
    } catch (error) {

      throw error;
    }
  }

  Future<void> SignupUser() async {
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }
    try {
      String apple = "";
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        apple = PrefUtils.prefs!.getString('apple')!;
      } else {
        apple = "";
      }

      String name = PrefUtils.prefs!.getString('FirstName').toString() + " " + PrefUtils.prefs!.getString('LastName').toString();

      final response = await http.post(Api.register, body: {
        "username": name,
        "email": PrefUtils.prefs!.getString('Email'),
        "mobileNumber": PrefUtils.prefs!.containsKey("Mobilenum") ? PrefUtils.prefs!.getString('Mobilenum') : "",
        "path": apple,
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "branch": PrefUtils.prefs!.getString('branch'),
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        final data = responseJson['data'] as Map<String, dynamic>;
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString("mobile", PrefUtils.prefs!.getString('Mobilenum')!);
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('referid', _referController.text);

        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkSkip = false;
          /*if (PrefUtils.prefs!.getString('FirstName') != null) {
            if (PrefUtils.prefs!.getString('LastName') != null) {
              name = PrefUtils.prefs!.getString('FirstName'.toString()) +
                  " " +
                  PrefUtils.prefs!.getString('LastName'.toString());
            } else {
              name = PrefUtils.prefs!.getString('FirstName'.toString());
            }
          } else {
            name = "";
          }*/
          name = store.userData.username!;
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email'.toString())!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum'.toString())!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;


          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });
        Navigator.of(context).pop();
        PrefUtils.prefs!.setString("formapscreen", "");
        /* Navigator.of(context).pushReplacementNamed(MapScreen.routeName,arguments: {
          "valnext": "",
        });*/
        Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push,qparms: {
          "valnext": "",
        });

        /* return Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);*/

        /*Navigator.of(context).pushReplacementNamed(
          HomeScreen.routeName,
        );*/

      } else if (responseJson['status'].toString() == "false") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: responseJson['data'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: ColorCodes.blackColor,
            textColor: ColorCodes.whiteColor);
      }
    } catch (error) {
      setState(() {});
      throw error;
    }
  }

  _saveAddInfoForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _form.currentState!.save();
    _dialogforProcessing();
    if(PrefUtils.prefs!.getString('Email') == "" || PrefUtils.prefs!.getString('Email') == "null") {
      return SignupUser();
    } else {
      checkemail();
    }
  }

  Future<void> signupUser() async {
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }
    try {

      final response = await http.post(Api.register, body: {
        "username": name,
        "email": email,
        "mobileNumber": mobile,
        "path": apple,
        "tokenId": tokenid,
        "branch": PrefUtils.prefs!.getString('branch') /*'999'*/,
        "signature":
        PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        "referralid": _referController.text,
        "device": channel.toString(),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
        PrefUtils.prefs!.setString('userID', responseJson['userId'].toString());
        PrefUtils.prefs!.setString('membership', responseJson['membership'].toString());
        PrefUtils.prefs!.setString('referral', PrefUtils.prefs!.getString('referralCode')!);
        PrefUtils.prefs!.setString('referid', _referController.text);
        PrefUtils.prefs!.setString('LoginStatus', "true");
        setState(() {
          checkSkip = false;
          /* if (PrefUtils.prefs!.getString('FirstName') != null) {
            if (PrefUtils.prefs!.getString('LastName') != null) {
              name = PrefUtils.prefs!.getString('FirstName'.toString()) +
                  " " +
                  PrefUtils.prefs!.getString('LastName'.toString());
            } else {
              name = PrefUtils.prefs!.getString('FirstName'.toString());
            }
          } else {
            name = "";
          }*/
          name = store.userData.username!;
          //name = PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
          if (PrefUtils.prefs!.getString('prevscreen') == 'signInAppleNoEmail') {
            email = "";
          } else {
            email = PrefUtils.prefs!.getString('Email')!;
          }
          mobile = PrefUtils.prefs!.getString('Mobilenum')!;
          tokenid = PrefUtils.prefs!.getString('tokenid')!;


          if (PrefUtils.prefs!.getString('photoUrl') != null) {
            photourl = PrefUtils.prefs!.getString('photoUrl')!;
          } else {
            photourl = "";
          }
        });

        Navigator.of(context).pop();

         /*Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);*/
        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {

      throw error;
    }
  }


  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }

  _dialogforAddInfo() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width / 3,
                width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.7,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S .of(context).add_info,//"Add your info",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  S .of(context).what_should_we_call_you,//'* What should we call you?',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S .of(context).name,//'Name',
                                    hoverColor: ColorCodes.darkgreen,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lnameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        fn = "  Please Enter Name";
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      fn = "";
                                    });
                                    return null;
                                  },
                                  onSaved: (value) {
                                    addFirstnameToSF(value!);
                                  },
                                ),
                                Text(
                                  fn,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: ColorCodes.lightred),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  S .of(context).tell_us_your_email,//'Tell us your e-mail',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      decorationColor:
                                      Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintText: 'xyz@gmail.com',
                                    fillColor: ColorCodes.darkgreen,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: ColorCodes.darkgreen, width: 1.2),
                                    ),
                                  ),
                                  validator: (value) {
                                    bool emailValid;
                                    if (value == "")
                                      emailValid = true;
                                    else
                                      emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!);

                                    if (!emailValid) {
                                      setState(() {
                                        ea =
                                        ' Please enter a valid email address';
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      ea = "";
                                    });
                                    return null; //it means user entered a valid input
                                  },
                                  onSaved: (value) {
                                    addEmailToSF(value!);
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ea,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: ColorCodes.lightred),
                                    ),
                                  ],
                                ),
                                Text(
                                  S .of(context).we_will_email,//' We\'ll email you as a reservation confirmation.',
                                  style: TextStyle(
                                      fontSize: 15.2, color: ColorCodes.grey),
                                ),

                                SizedBox(
                                  height: 15.0,
                                ),
                                if(Features.isReferEarn)
                                  Text(
                                    S .of(context).apply_referal_code,//'Apply referral Code',
                                    style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                if(Features.isReferEarn)
                                  TextFormField(
                                    controller: _referController,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        decorationColor: Theme.of(context).primaryColor),
                                    decoration: InputDecoration(
                                      hintText: S .of(context).refer_earn,//'Refer and Earn',
                                      fillColor: Colors.green,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green, width: 1.2),
                                      ),
                                    ),
                                    /*  validator: (value) {
                        bool emailValid;
                        if (value == "")
                          emailValid = true;
                        else
                          emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                        if (!emailValid) {
                          setState(() {
                            ea = ' Please enter a valid email address';
                          });
                          return '';
                        }
                        setState(() {
                          ea = "";
                        });
                        return null; //it means user entered a valid input
                      },*/
                                    onSaved: (value) {
                                      addReferralToSF(value!);
                                    },
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        //  Spacer(),

/*            GestureDetector(
              onTap: () {
                _saveForm();
              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: Color(0xFF2966A2),
                child: Center(
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorCodes.whiteColor),
                  ),
                ),
              ),
            )*/
                      ],
                    ),
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _saveAddInfoForm();
                          _dialogforProcessing();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          height: 60.0,
                          child: Center(
                            child: Text(
                              S .of(context).continue_button,//"CONTINUE",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                ]),
              ),
            );
          });
        });
  }

  _dialogforSignIn() {
    queryData = MediaQuery.of(context);
    hig= queryData!.size.height;
    maxhig=hig!*0.85;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: SingleChildScrollView(
                child: Container(
                  // height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width / 2.,
                  width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width / 2.5,
                  //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                  child: Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      color: ColorCodes.lightGreyWebColor,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S .of(context).signin,//"Sign in",
                            style: TextStyle(
                                color: ColorCodes.mediumBlackColor,
                                fontSize: 20.0),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, bottom: 30.0, right: 30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 32.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 52,
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                    width: 0.5, color: ColorCodes.darkGrey)
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.countryImg,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        S .of(context).country_region,//"Country/Region",
                                        style: TextStyle(
                                          color: ColorCodes.greyColor,
                                        )),
                                    Text(CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name + " (" + IConstants.countryCode + ")",
                                        style: TextStyle(
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 52.0,
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  width: 0.5, color: ColorCodes.darkGrey),
                            ),
                            child: Row(
                              children: <Widget>[
                                Image.asset(Images.phoneImg),
                                SizedBox(
                                  width: 14,
                                ),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 4.0,
                                    child: Form(
                                      key: _form,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16.0),
                                        textAlign: TextAlign.left,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(12)
                                        ],
                                        cursorColor:
                                        Theme.of(context).primaryColor,
                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                        decoration: new InputDecoration.collapsed(
                                            hintText: 'Enter Your Mobile Number',
                                            hintStyle: TextStyle(
                                              color: ColorCodes.mediumBlackColor,
                                            )),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a Mobile number.';
                                          }
                                          return null; //it means user entered a valid input
                                        },
                                        onSaved: (value) {
                                          addMobilenumToSF(value!);
                                        },
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 60.0,
                            margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
                            child: Text(
                              S .of(context).we_will_call_or_text,//"We'll call or text you to confirm your number. Standard message data rates apply.",
                              style: TextStyle(
                                  fontSize: 13, color: ColorCodes.mediumBlackWebColor),
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                PrefUtils.prefs!.setString('skip', "no");
                                PrefUtils.prefs!.setString('prevscreen', "mobilenumber");
                                // PrefUtils.prefs!.setString('Mobilenum', value);

                                _saveForm();
                                _dialogforProcessing();

                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 32,
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: ColorCodes.greenColor,
                                  ),
                                ),
                                child: Text(
                                  S .of(context).login_using_otp,//"LOGIN USING OTP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                      color: ColorCodes.blackColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 60.0,
                            margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
                            child: new RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: ColorCodes.blackColor,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: S .of(context).agreed_terms,//'By continuing you agree to the '
                                  ),
                                  new TextSpan(
                                      text: S .of(context).terms_of_service,//' Terms of Service',
                                      style:
                                      new TextStyle(color: ColorCodes.darkthemeColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {
                                          'title': "Terms of Use",
                                          /*'body': IConstants.restaurantTerms,*/});
                                        }),
                                  new TextSpan(text:
                                  S .of(context).and//' and'
                                  ),
                                  new TextSpan(
                                      text: S .of(context).privacy_policy,//' Privacy Policy',
                                      style:
                                      new TextStyle(color: ColorCodes.darkthemeColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {
                                            'title': "Privacy",
                                            /*'body': PrefUtils.prefs!.getString("privacy").toString()*/});
                                        }),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorCodes.greyColor,
                                  ),
                                ),
                                Container(
                                  //padding: EdgeInsets.all(4.0),
                                  width: 23.0,
                                  height: 23.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorCodes.greyColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        S .of(context).or,//"OR",
                                        style: TextStyle(
                                            fontSize: 10.0, color: ColorCodes.greyColor),
                                      )),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color:ColorCodes.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*Container(
                            height: 44,
                            width: MediaQuery.of(context).size.width / 1.2,
                            margin: EdgeInsets.only(top: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  width: 0.5,
                                  color: ColorCodes.darkGrey.withOpacity(1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _dialogforProcessing();
                                      Navigator.of(context).pop();
                                      _handleSignIn();
                                    },
                                    child: Image.asset(Images.googleImg)),
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _dialogforProcessing();
                                      Navigator.of(context).pop();
                                      facebooklogin();
                                    },
                                    child: Image.asset(Images.facebookImg)),
                                if (_isAvailable)
                                  GestureDetector(
                                      onTap: () {
                                        appleLogIn();
                                      },
                                      child: Image.asset(Images.appleImg))
                              ],
                            ),
                          ),*/
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    _dialogforProcessing();
                                    Navigator.of(context).pop();
                                    _handleSignIn();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(

                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left:23,),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              //SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                              Image.asset(Images.googlewebImg,width: 20,height: 20,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S .of(context).sign_in_with_google,//"Sign in with Google" , //"Sign in with Google",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    _dialogforProcessing();
                                    Navigator.of(context).pop();
                                    facebooklogin();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),

                                        // border: Border.all(width: 0.5, color: Color(0xff4B4B4B)),
                                      ),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left: 23),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              //SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                              Image.asset(Images.facebookwebImg,width: 20,height: 20,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S .of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_isAvailable)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 28),
                                  child: GestureDetector(
                                    onTap: () {
                                      appleLogIn();
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(4.0),
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      child: Container(

                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4.0),),
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.only(right:23.0,left:23,),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                // SvgPicture.asset(Images.appleImg, width: 25, height: 25,),
                                                Image.asset(Images.appleImg,width: 20,height: 20,),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                Text(
                                                  S .of(context).signin_apple,//"Sign in with Apple"  , //"Sign in with Apple",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorCodes.signincolor),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            );
          });
        });
  }

  _dialogforOtp() async {
    return alertOtp(context);
  }

  void alertOtp(BuildContext ctx) {
    mobile = PrefUtils.prefs!.getString("Mobilenum")!;
    var alert = AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: StreamBuilder<int>(
            stream: _events!.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // height: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                      //     ? MediaQuery.of(context).size.height
                      //    : MediaQuery.of(context).size.width / 3,
                        width: (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width / 2.5,
                        child: Column(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            padding: EdgeInsets.only(left: 20.0),
                            color: ColorCodes.lightGreyWebColor,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  S .of(context).signup_otp,//"Signup using OTP",
                                  style: TextStyle(
                                      color: ColorCodes.mediumBlackColor,
                                      fontSize: 20.0),
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 25.0),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      S .of(context).please_check_otp_sent_to_your_mobile_number,//'Please check OTP sent to your mobile number',
                                      style: TextStyle(
                                          color: ColorCodes.mediumBlackWebColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),

                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 20.0),
                                      Text(
                                        IConstants.countryCode + '  $mobile',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: ColorCodes.blackColor,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(width: 30.0),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          _dialogforSignIn();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: ColorCodes.whiteColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: ColorCodes.baseColordark, width: 1.5),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  S .of(context).change,//'Change',
                                                  style: TextStyle(
                                                      color: ColorCodes.blackColor,
                                                      fontSize: 13))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      S .of(context).enter_otp,//'Enter OTP',
                                      style: TextStyle(
                                          color: ColorCodes.greyColor, fontSize: 14),
                                      //textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Auto Sms
                                        Container(
                                            height: 40,
                                            //width: MediaQuery.of(context).size.width*80/100,
                                            width: (Vx.isWeb &&
                                                ResponsiveLayout.isSmallScreen(
                                                    context))
                                                ? MediaQuery.of(context).size.width /
                                                2
                                                : MediaQuery.of(context).size.width /
                                                3,
                                            //padding: EdgeInsets.zero,
                                            child: PinFieldAutoFill(
                                                controller: controller,
                                                decoration: UnderlineDecoration(
                                                    colorBuilder: FixedColorBuilder(
                                                        ColorCodes.greyColor)),
                                                onCodeChanged: (text) {
                                                  otpvalue = text!;
                                                  SchedulerBinding.instance
                                                      !.addPostFrameCallback(
                                                          (_) => setState(() {}));
                                                },
                                                onCodeSubmitted: (text) {
                                                  SchedulerBinding.instance
                                                      !.addPostFrameCallback(
                                                          (_) => setState(() {
                                                        otpvalue = text;
                                                      }));
                                                },
                                                codeLength: 4,
                                                currentCode: otpvalue)),
                                      ]),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _showOtp
                                      ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          width: (Vx.isWeb &&
                                              ResponsiveLayout
                                                  .isSmallScreen(context))
                                              ? MediaQuery.of(context)
                                              .size
                                              .width *
                                              50 /
                                              100
                                              : MediaQuery.of(context)
                                              .size
                                              .width *
                                              32 /
                                              100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorCodes.greyColor,
                                                width: 1.5),
                                          ),
                                          child: Center(
                                              child: Text(
                                                S .of(context).resend_otp,//'Resend OTP'
                                              )),
                                        ),
                                        if(Features.callMeInsteadOTP)
                                          Container(
                                            height: 28,
                                            width: 28,
                                            margin: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: ColorCodes.greyColor,
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  S .of(context).or,//'OR',
                                                  style: TextStyle(fontSize: 10),
                                                )),
                                          ),
                                        if(Features.callMeInsteadOTP)
                                          _timeRemaining == 0
                                              ? MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              behavior: HitTestBehavior
                                                  .translucent,
                                              onTap: () {
                                                otpCall();
                                                _timeRemaining = 60;
                                              },
                                              child: Expanded(
                                                child: Container(
                                                  height: 40,
                                                  //width: MediaQuery.of(context).size.width*32/100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(6),
                                                    border: Border.all(
                                                        color: ColorCodes.darkgreen,
                                                        width: 1.5),
                                                  ),

                                                  child: Center(
                                                      child: Text(
                                                        S .of(context).call_me_instead,//'Call me Instead'
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )
                                              : Expanded(
                                            child: Container(
                                              height: 40,
                                              //width: MediaQuery.of(context).size.width*32/100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                border: Border.all(
                                                    color:
                                                    ColorCodes.greyColor,
                                                    width: 1.5),
                                              ),
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: S .of(context).call_in,//'Call in',
                                                          style: TextStyle(
                                                              color: ColorCodes.blackColor)),
                                                      new TextSpan(
                                                        text:
                                                        ' 00:$_timeRemaining',
                                                        style: TextStyle(
                                                            color: ColorCodes.lightGreyWebColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ])
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _timeRemaining == 0
                                          ? MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          behavior:
                                          HitTestBehavior.translucent,
                                          onTap: () {
                                            //  _showCall = true;
                                            _showOtp = true;
                                            _timeRemaining += 30;
                                            Otpin30sec();
                                          },
                                          child: Expanded(
                                            child: Container(
                                              height: 40,
                                              width: (Vx.isWeb &&
                                                  ResponsiveLayout
                                                      .isSmallScreen(
                                                      context))
                                                  ? MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  30 /
                                                  100
                                                  : MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  15 /
                                                  100,
                                              //width: MediaQuery.of(context).size.width*32/100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                border: Border.all(
                                                    color: ColorCodes.darkgreen,
                                                    width: 1.5),
                                              ),
                                              child: Center(
                                                  child:
                                                  Text(
                                                    S .of(context).resend_otp,//'Resend OTP'
                                                  )),
                                            ),
                                          ),
                                        ),
                                      )
                                          : Expanded(
                                        child: Container(
                                          height: 40,
                                          //width: MediaQuery.of(context).size.width*40/100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorCodes.blackColor,
                                                width: 1.5),
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S .of(context).resend_otp_in,//'Resend Otp in',
                                                      style: TextStyle(
                                                          color: ColorCodes.blackColor)),
                                                  new TextSpan(
                                                    text:
                                                    ' 00:$_timeRemaining',
                                                    style: TextStyle(
                                                      color: ColorCodes.lightGreyWebColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(Features.callMeInsteadOTP)
                                        Container(
                                          height: 28,
                                          width: 28,
                                          margin: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            border: Border.all(
                                                color: ColorCodes.greyColor,
                                                width: 1.5),
                                          ),
                                          child: Center(
                                              child: Text(
                                                S .of(context).or,//'OR',
                                                style: TextStyle(fontSize: 10),
                                              )),
                                        ),
                                      if(Features.callMeInsteadOTP)
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            //width: MediaQuery.of(context).size.width*32/100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: ColorCodes.greyColor,
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  S .of(context).call_me_instead,//'Call me Instead'
                                                )),
                                          ),
                                        ),
                                    ],
                                  ),
                                ]),
                          ),

                          /*Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _verifyOtp();
                                  _dialogforProcessing();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  height: 60.0,
                                  child: Center(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context).buttonColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                          ),*/
                        ])),
                    SizedBox(height: 30,),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _verifyOtp();
                            _dialogforProcessing();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            height: 60.0,
                            child: Center(
                              child: Text(
                                S .of(context).login,//"LOGIN",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }));
    _startTimer();
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return alert;
        });
  }

  Widget _loginDropdown() {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Material(
          elevation: 35,
          child: Container(
            margin: EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      /// remove search list on signin click
                      onremovedDrpDown();
                      //_dialogforSignIn();
                      LoginWeb(context,result: (sucsess){
                        if(sucsess){
                          Navigator.of(context).pop();
                         /* Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.routeName, (route) => false);*/
                          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                        }else{
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).accentColor,
                      ),
                      child: Center(
                          child: Text(
                              S .of(context).login_register,//'Login/ Sign Up',
                              style: TextStyle(
                                  color: ColorCodes.whiteColor, fontSize: 16))),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    onremovedDrpDown();
                    Navigator.of(context)
                        .pushReplacementNamed(CustomerSupportScreen.routeName);
                  },
                  child: _DropDownItem(Icons.headset, S .of(context).customer_support,//"Customer Support"
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        )
      ],
    );
  }

  /*Widget _dropdown() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Material(
          elevation: 35,
          // shape: ArrowShape(),
          child: Container(
            //height: 4 * itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    if (photourl != null)
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: ColorCodes.lightGreyColor,
                        backgroundImage: NetworkImage(photourl),
                      ),
                    if (photourl == null)
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: ColorCodes.lightGreyColor,
                      ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: ColorCodes.darkGrey, fontSize: 18.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '$phone',
                             style:
                                TextStyle(
                                    color: ColorCodes.darkGrey, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context)
                        .pushReplacementNamed(MyorderScreen.routeName);
                  },
                  child: _DropDownItem(Icons.note, "My Orders"),
                ),
                if(Features.isShoppingList)
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context)
                        .pushReplacementNamed(ShoppinglistScreen.routeName);
                  },
                  child: _DropDownItem(Icons.list, "Shopping list"),
                ),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context)
                        .pushReplacementNamed(AddressbookScreen.routeName);
                  },
                  child: _DropDownItem(Icons.library_books, "Address book"),
                ),
                if(Features.isMembership)
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context)
                        .pushReplacementNamed(MembershipScreen.routeName);
                  },
                  child: _DropDownItem(Icons.star, "Membership"),
                ),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context).pushReplacementNamed(
                        WalletScreen.routeName,
                        arguments: {'type': "loyalty"});
                  },
                  child: _DropDownItem(Icons.wallet_membership, "Wallet"),
                ),
                if(Features.isLoyalty)
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context).pushNamed(WalletScreen.routeName,
                        arguments: {'type': "loyalty"});
                  },
                  child: _DropDownItem(Icons.library_books, "Loyalty"),
                ),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () {
                    floatingDropdown.remove();
                    Navigator.of(context)
                        .pushReplacementNamed(CustomerSupportScreen.routeName);
                  },
                  child: _DropDownItem(Icons.headset, "Customer Support"),
                ),
                FlatButton(
                  hoverColor: ColorCodes.lightBlueColor,
                  onPressed: () async {
                    floatingDropdown.remove();
                    PrefUtils.prefs!.remove('LoginStatus');
                    try {
                      // PrefUtils.prefs!.remove('LoginStatus');
                      if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {
                        PrefUtils.prefs!.setString("photoUrl", "");
                        await _googleSignIn.signOut();
                      } else if (PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {
                        PrefUtils.prefs!.getString("FBAccessToken");
                        var facebookSignIn = FacebookLoginWeb();
                        final graphResponse = await http.delete(
                            'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs!.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');
                        PrefUtils.prefs!.setString("photoUrl", "");
                        await facebookSignIn.logOut().then((value) {
                        });
                      }
                    } catch (e) {
                    }
                    String branch = PrefUtils.prefs!.getString("branch");
                    String _tokenId = PrefUtils.prefs!.getString("tokenid");
                    PrefUtils.prefs!.clear();
                    PrefUtils.prefs!.setBool('introduction', true);
                    PrefUtils.prefs!.setString("branch", branch);
                    PrefUtils.prefs!.setString('skip', "yes");
                    PrefUtils.prefs!.setString('tokenid', _tokenId);
                    //_dialogforSignIn();
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.routeName, (route) => false);

                    setState(() {
                      checkSkip = true;
                    });
                  },
                  child: _DropDownItem(Icons.exit_to_app, "Logout"),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }*/

  createHeaderForWeb() {

    debugPrint("checkSkip1...."+PrefUtils.prefs!.containsKey('apikey').toString());
    checkSkip = !PrefUtils.prefs!.containsKey('apikey');
    name = (VxState.store as GroceStore).userData.username??"";
    debugPrint("yes1....."+name+",,,,"+(VxState.store as GroceStore).userData.username.toString());
    return VxBuilder(
      mutations: {HomeScreenController,SetPrimeryLocation},
     builder: (context, GroceStore store,state){
        debugPrint("homescreen data...."+store.homescreen.data.toString());
        debugPrint("Location data...."+store.userData.area.toString());
        String currentlocation ="";
        if(PrefUtils.prefs!.containsKey("deliverylocation")) {
          currentlocation = PrefUtils.prefs!.getString("deliverylocation")!;
          debugPrint("Location sf data...."+PrefUtils.prefs!.getString("deliverylocation")!);
        } else {
          currentlocation = PrefUtils.prefs!.getString("restaurant_location")??"";
          debugPrint("Location sf data.... no Location");
        }
       if(store.homescreen.data!=null) {
         if (store.homescreen.data!.allBrands!.length > 0 || store.homescreen.data!.allCategoryDetails!.length > 0 || (store.homescreen.data!.discountByCart!=null)&&store.homescreen.data!.discountByCart!.data!.length > 0) {
           _isDelivering = true;
         } else {
           _isDelivering = false;
         }
       }
       return Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Container(
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.topCenter,
                 end: Alignment.topRight,
                 colors: [
                   ColorCodes. whiteColor,
                   ColorCodes.whiteColor
                 ],
               ),
             ),
             width: MediaQuery.of(context).size.width,
             height: 60.0,
             child: Row(
               children: [
                 SizedBox(
                   width: 10.0,
                 ),
                 MouseRegion(
                   cursor: SystemMouseCursors.click,
                   child: GestureDetector(
                     behavior: HitTestBehavior.translucent,
                     onTap:() {
                       if(!widget._isHome){
                         debugPrint("brand.....");
                         /*Navigator.pushNamedAndRemoveUntil(
                             context, HomeScreen.routeName, (route) => false);*/
                         HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                             PrefUtils.prefs!.getString("ftokenid"),
                             branch: (VxState.store as GroceStore).userData.branch ?? "15",
                             rows: "0");
                         Navigation(context, navigatore: NavigatoreTyp.homenav);
                         GoRouter.of(context).refresh();

                       }
                     },
                     child: Features.isWebTrail ? Features.logo!=""?CachedNetworkImage(width: 200,imageUrl: "${Features.logo}") : SizedBox(width: 200,)
                     : Image.asset(
                       Images.logonImg1,
                       width: 220,
                     ),
                   ),
                 ),
                 SizedBox(
                   width: 30.0,
                 ),

                 Expanded(
                   child: MouseRegion(
                     cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                       behavior: HitTestBehavior.translucent,
                       onTap: () {
                         PrefUtils.prefs!.setString("formapscreen", "homescreen");
                         /*Navigator.of(context).pushNamed(MapScreen.routeName,arguments: {
                           "valnext": "",
                         });*/
                         Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push, qparms:{
                               "valnext": "",
                             });
                         onremovedDrpDown();
                       },
                       child: Row(
                         children: [
                           SizedBox(
                             width: 40.0,
                           ),
                           Icon(
                             Icons.location_on_outlined,
                             color: ColorCodes.greenColor,
                           ),
                           SizedBox(
                             width: 14.0,
                           ),
                           Expanded(
                             child:   Text(
                               currentlocation,
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                               style:
                               TextStyle(color: ColorCodes.greenColor, fontSize: 17.0),
                             ),
                           ),
                           Icon(
                             Icons.arrow_drop_down_sharp,
                             color: ColorCodes.greenColor,
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
                 SizedBox(
                   width: 40.0,
                 ),
                 Container(
                   height: 50.0,
                   width: MediaQuery.of(context).size.width/3,
                   decoration: BoxDecoration(
                     color: ColorCodes.appdrawerColor                                                                                         ,
                     borderRadius: BorderRadius.circular(6),
                   ),
                   child: TextField(
                       autofocus: false,
                       focusNode: _focus,
                       textInputAction: TextInputAction.search,
                       onTap: ()=>_onFocusChange(),
                       // style: TextStyle(color: (IConstants.isEnterprise)?ColorCodes.whiteColor:ColorCodes.blackColor),
                       decoration: InputDecoration(
                         // fillColor: ColorCodes.whiteColor,
                         border: InputBorder.none,
                         contentPadding: EdgeInsets.only(top:13,left:20,right:10),
                         hintText: ' Search for Products ',
                         hintStyle: TextStyle(
                           color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.greyColor,
                         ),
                         suffixIcon:
                         Icon(Icons.search, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.greyColor),
                         // focusColor: ColorCodes.whiteColor,
                         //  fillColor: ColorCodes.whiteColor,
                         filled: (_focus.hasFocus),
                       ),
                       onSubmitted: (value) {
                         searchValue = value;
                         _focus.requestFocus();
                         onremovedDrpDown();
                         debugPrint("onHit....."+value.toString());
                         onSubmit(value);

                       },
                       // onTap: ()=>  _onFocusChange(),
                       onChanged: (String newVal) {
                         setState(() {
                           searchValue = newVal;
                           if (newVal.length == 0) {
                             setState(() {
                               _isSearchShow = false;
                             });

                             search("");
                             onremovedDrpDown();
                           }
                           else if (newVal.length == 2) {
                             //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                             _debouncer.run(() {
                               search(newVal);
                               onadddDrpDown();
                               _focus.requestFocus();
                             });
                           }
                           else if (newVal.length >= 3) {
                             _debouncer.run(() {
                               _isSearchShow = true;
                               onadddDrpDown();
                               search(newVal);
                               //  onSubmit(newVal);
                               _focus.requestFocus();
                             });

                             /*searchDispaly = searchData.searchitems
                                              .where((elem) =>
                                              elem.title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(newVal.toLowerCase()))
                                              .toList();
                                          _isSearchShow = true;*/
                           }
                         });
                       }),
                 ),


                 SizedBox(
                   width: 40.0,
                 ),
                 MouseRegion(
                   cursor: SystemMouseCursors.click,
                   child: GestureDetector(
                     behavior: HitTestBehavior.translucent,
                     onTap: () {
                      /* Navigator.of(context).pushNamed(CartScreen.routeName,
                           arguments: {"prev": "home_screen", "afterlogin": ""});*/
                     //  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,parms: {"afterlogin":null.toString()});
                       Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                       onremovedDrpDown();
                     },
                     child: Row(
                       children: [
                         SizedBox(
                           width: 10.0,
                         ),
                         ValueListenableBuilder(
                           valueListenable:IConstants.currentdeliverylocation,
                           builder: (context, value, widget){
                             return VxBuilder(
                               builder: (context, GroceStore box, index) {
                                 if (CartCalculations.itemCount<=0)
                                   return GestureDetector(
                                     onTap: () {
                                       if (value != S .of(context).not_available_location)
                                         Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                     },
                                     child: Container(
                                       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                                       width: 28,
                                       height: 28,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(100),
                                       ),
                                       child: Image.asset(
                                         Images.cartImg,
                                         height: 30,
                                         width: 30,
                                         color: ColorCodes.blackColor,
                                       ),
                                     ),
                                   );
                                 return Consumer<CartCalculations>(
                                   builder: (_, cart, ch) => Badge(
                                     child: ch!,
                                     color: ColorCodes.darkgreen,
                                     value: CartCalculations.itemCount.toString(),
                                   ),
                                   child: GestureDetector(
                                     onTap: () {
                                       if (value != S .of(context).not_available_location)
                                   /*      Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                                           "afterlogin": ""
                                         });*/
                                         Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                     },
                                     child: Container(
                                       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                                       width: 28,
                                       height: 28,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(100),
                                       ),
                                       child:
                                       Image.asset(
                                         Images.cartImg,
                                         height: 28,
                                         width: 28,
                                         color:  ColorCodes.blackColor,
                                       ),
                                     ),
                                   ),);
                               },mutations: {SetCartItem},
                             );
                           },
                         ),
                         SizedBox(
                           width: 10.0,
                         ),
                       ],
                     ),
                   ),
                 ),

                 SizedBox(
                   width:40.0,
                 ),
                 checkSkip?
                 GestureDetector(
                   onTap: (){
                     onremovedDrpDown();
                     // _dialogforSignIn();
                     LoginWeb(context,result: (sucsess){
                       if(sucsess){
                         print("successs");
                         Navigator.of(context).pop();
                         /*Navigator.pushNamedAndRemoveUntil(
                             context, HomeScreen.routeName, (route) => false);*/
                         print("referesh,,,,,,"+(VxState.store as GroceStore).userData.id.toString());
                         HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                             PrefUtils.prefs!.getString("ftokenid"),
                             branch: (VxState.store as GroceStore).userData.branch ?? "15",
                             rows: "0");
                         Navigation(context, navigatore: NavigatoreTyp.homenav);
                         GoRouter.of(context).refresh();

                       }else{
                         Navigator.of(context).pop();
                       }
                     });
                   },
                   child: Container(

                     height: 45.0,

                     child:
                     Row(
                       children: [
                         SizedBox(width: 10.0),
                         Icon(Icons.person_outline_rounded,
                             color: ColorCodes.blackColor, size: 24.0),
                         SizedBox(
                           width: 9.0,
                         ),
                         new Text(
                           S .of(context).login_register,//"Login",
                           style: TextStyle(
                             color: ColorCodes.blackColor,
                             fontSize: 17,
                           ),
                         ),
                         Icon(
                           Icons.arrow_drop_down_sharp,
                           color: ColorCodes.blackColor,
                         ),
                         SizedBox(
                           width: 10.0,
                         ),
                       ],
                     ),
                   ),
                 )
                     :
                 Container(
                   child: PopupMenuButton(
                     offset: const Offset(0, 38),
                     onSelected: (selectedValue) {
                       setState(() {
                         if(selectedValue == "/MyOrders"){
                           /*Navigator.of(context)
                               .pushReplacementNamed(MyorderScreen.routeName,arguments: {
                             "orderhistory": ""
                           });*/
                           Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                               /*parms: {
                             "orderhistory": ""
                           }*/);
                         }
                         else if(selectedValue == "/MySubscription"){
                         /*  Navigator.of(context)
                               .pushReplacementNamed(MySubscriptionScreen.routeName);*/
                           Navigation(context, name: Routename.MySubscription, navigatore: NavigatoreTyp.Push);
                         }
                         else if(selectedValue == "/shoppinglist"){
                           /*Navigator.of(context)
                               .pushReplacementNamed(ShoppinglistScreen.routeName);*/
                           Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                         }
                         else if(selectedValue == "/Addressbook"){
                         /*  Navigator.of(context)
                               .pushReplacementNamed(AddressbookScreen.routeName);*/
                           Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.Push);
                         }
                         else if(selectedValue == "/Membership"){
                          /* Navigator.of(context)
                               .pushReplacementNamed(MembershipScreen.routeName);*/
                           Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                         }
                         else if(selectedValue == "/Wallet"){
                           /*Navigator.of(context).pushReplacementNamed(
                               WalletScreen.routeName,
                               arguments: {'type': "wallet"});*/
                           Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,qparms: {
                             "type":"wallet",
                           });
                         }
                         else if(selectedValue == "/Loyalty"){
                          /* Navigator.of(context).pushReplacementNamed(
                               WalletScreen.routeName,
                               arguments: {'type': "loyalty"});*/
                           Navigation(context, name: Routename.Loyalty, navigatore: NavigatoreTyp.Push,qparms: {
                             "type":"loyalty",
                           });
                         }
                         else if(selectedValue == "/language"){
                           showDialog(context: context, builder: (BuildContext context) => LanguageselectDailog(context));
                         }
                         /*else if(selectedValue == "/CustomerSupport"){
                             js.context.callMethod("crispchat"); //call showAlert with parameter value
                          // <script type="text/javascript">window.$crisp=[];window.CRISP_WEBSITE_ID="cd088871-648c-453e-b754-bce14cdba681";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();</script>
                             //Navigator.of(context).pushReplacementNamed(CustomerSupportScreen.routeName);
                           }*/
                         else if(selectedValue == "/Logout"){
                           logout();
                         }
                       });
                     },
                     child:  Row(
                       children: [
                         SizedBox(
                           width: 14.0,
                         ),
                         new Text(
                           name,
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           style: TextStyle(
                             color: ColorCodes.blackColor,
                             fontSize: 15,
                           ),
                         ),
                         Icon(
                           Icons.arrow_drop_down_sharp,
                           color: ColorCodes.blackColor,
                         ),
                       ],
                     ),
                     itemBuilder: (BuildContext bc) => [
                       PopupMenuItem(child:
                       Container(

                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        children: <Widget>[

                             if (photourl != null)
                               CircleAvatar(
                                 radius: 20.0,
                                 backgroundColor: ColorCodes.greyColor,
                                 backgroundImage: NetworkImage(photourl),
                               ),
                             if (photourl == null)
                               CircleAvatar(
                                 radius: 20.0,
                                 backgroundColor: ColorCodes.greyColor,
                               ),
                             SizedBox(
                               width: 10.0,
                             ),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text(
                                     name,
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 3,
                                     style: TextStyle(
                                         color: ColorCodes.blackColor, fontSize: 18.0),
                                   ),
                                   SizedBox(
                                     height: 5.0,
                                   ),
                                   Text(
                                     store.userData.mobileNumber??"",
                                     //'$phone',
                                     style:
                                     TextStyle(
                                         color: ColorCodes.darkGrey, fontSize: 14.0),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                       ),
                       PopupMenuItem(child:

                       Row(
                         children: [
                           Image.asset(Images.appbar_myorder, height: 30.0, width: 30.0,color:ColorCodes.blackColor),
                           SizedBox(width: 10,),
                           Text(
                             S .of(context).my_orders,
                             style: TextStyle(
                                 color:ColorCodes.blackColor
                             ),
                             //"My Orders"
                           ),
                         ],
                       ),
                           value: "/MyOrders"),
                       if(Features.isSubscription)
                         PopupMenuItem(child:

                         Row(
                           children: [
                             Image.asset(Images.appbar_subscription, height: 30.0, width: 30.0, color: ColorCodes.blackColor,),
                             SizedBox(width: 10,),
                             Text(
                               S .of(context).my_subscription,
                               style: TextStyle(
                                   color:ColorCodes.blackColor
                               ),
                               //"My Orders"
                             ),
                           ],
                         ),
                             value: "/MySubscription"),
                       if(Features.isShoppingList)
                         PopupMenuItem(
                             child: Row(
                               children: [
                                 Image.asset(Images.appbar_shopping, height: 30.0, width: 30.0,color: ColorCodes.blackColor,),
                                 SizedBox(width: 10,),
                                 Text(
                                   S .of(context).shopping_list,
                                   style: TextStyle(
                                       color:ColorCodes.blackColor
                                   ),//"Shopping list"
                                 ),
                               ],
                             ),
                             value: "/shoppinglist"),
                       PopupMenuItem(child:
                       Row(
                         children: [
                           Image.asset(Images.appbar_address, height: 20.0, width: 20.0, color:ColorCodes.blackColor),
                           SizedBox(width: 10,),
                           Text(
                             S .of(context).address_book,
                             style: TextStyle(
                                 color:ColorCodes.blackColor
                             ), //"Address book"
                           ),
                         ],
                       ),
                           value: "/Addressbook"),
                       if(Features.isMembership)
                         PopupMenuItem(
                             child: Row(
                               children: [
                                 Image.asset(Images.memImg, height:20.0, width:20.0, color:ColorCodes.blackColor),
                                 SizedBox(width: 10,),
                                 Text(
                                   S .of(context).membership,
                                   style: TextStyle(
                                       color:ColorCodes.blackColor
                                   ),//"Membership"
                                 ),
                               ],
                             ),
                             value: "/Membership"),
                       if(Features.isWallet)
                         PopupMenuItem(
                             child: Row(
                               children: [
                                 Image.asset(Images.addwallet, height: 25.0, width: 25.0, color: ColorCodes.blackColor),
                                 SizedBox(width: 10,),
                                 Text(
                                   S .of(context).wallet,
                                   style: TextStyle(
                                       color:ColorCodes.blackColor
                                   ),//"Wallet"
                                 ),
                               ],
                             ),
                             value: "/Wallet"),
                       if(Features.isLoyalty)
                         PopupMenuItem(
                             child: Row(
                               children: [
                                 Image.asset(Images.app_loyaltyweb, height: 20.0, width: 20.0, color:ColorCodes.blackColor),
                                 SizedBox(width: 10,),
                                 Text(
                                   S .of(context).loyalty,
                                   style: TextStyle(
                                       color:ColorCodes.blackColor
                                   ),//"Loyalty"
                                 ),
                               ],
                             ),
                             value: "/Loyalty"),
                       // PopupMenuItem(child:
                       //   Row(
                       //     children: [
                       //       Image.asset(Images.appCustomer, height: 15.0, width: 15.0),
                       //       SizedBox(width: 10,),
                       //       Text("Customer Support"),
                       //     ],
                       //   ),
                       //       value: "/CustomerSupport"),
                       if(store.language.languages.length > 1)
                         PopupMenuItem(
                             child: Row(
                               children: [
                                 Image.asset(Images.addLanguage,height: 25.0, width: 25.0, color:ColorCodes.blackColor),
                                 SizedBox(width: 10,),
                                 Text(
                                   S .of(context).language,
                                   style: TextStyle(
                                       color:ColorCodes.blackColor
                                   ),//"Logout"
                                 ),
                               ],
                             ),
                             value: "/language"
                         ),
                       PopupMenuItem(
                           child: Row(
                             children: [
                               Image.asset(Images.logoutImg2, height: 25.0, width: 25.0),
                               SizedBox(width: 10,),
                               Text(
                                 S .of(context).log_out,
                                 style: TextStyle(
                                     color:ColorCodes.blackColor
                                 ),//"Logout"
                               ),
                             ],
                           ),
                           value: "/Logout"
                       ),
                     ],
                   ),
                 ),
                 SizedBox(
                   width: 20.0,
                 )
               ],
             ),
           ),
           /* Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                color: ColorCodes.whiteColor,
                child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesData.items.length,
                    itemBuilder: (_, i) => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SubcategoryScreen.routeName, arguments: {
                                'catId': categoriesData.items[i].catid,
                                'catTitle': categoriesData.items[i].title,
                              });
                              floatingDropdown.remove();
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  categoriesData.items[i].title,
                                  style: TextStyle(
                                    color: ColorCodes.blackColor,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )),
              ),*/
           if(store.homescreen.data!=null) if( store.homescreen.data!.allCategoryDetails!.length>0) StatefulBuilder(
               builder: (context,setState){
                 return ControlledScrollView(
                     lbtnval:lbtn,rbtnval:rbtn,
                     controller: cstscrollcontroller,
                     onLeftClick: () {
                       setState((){
                         rbtn = true;
                       });
                       int initcso = cstscrollcontroller.offset.toInt();
                       cstscrollcontroller.animateTo(cstscrollcontroller.offset -200,
                           curve: Curves.easeIn, duration: Duration(milliseconds: 500));
                       int finalcso = cstscrollcontroller.offset.toInt();
                       if(finalcso<=0){
                         setState(() {
                           lbtn = false;
                         });
                       }
                     },
                     onRightClick: () {
                       setState((){
                         lbtn = true;
                       });
                       int initcso = cstscrollcontroller.offset.toInt();
                       cstscrollcontroller.animateTo(cstscrollcontroller.offset +200,
                           curve: Curves.easeIn, duration: Duration(milliseconds: 500));
                       int finalcso = cstscrollcontroller.offset.toInt();

                       if((cstscrollcontroller.position.maxScrollExtent.toInt()-100)<finalcso){
                         setState(() {
                           rbtn = false;
                           lbtn = true;
                         });
                       }
                     },
                     child: new ListView.builder(
                       shrinkWrap: true,
                       controller: cstscrollcontroller,
                       scrollDirection: Axis.horizontal,
                       itemCount: store.homescreen.data!.allCategoryDetails!.length,
                       itemBuilder: (_, j) =>

                           showSubCategory(store.homescreen.data!.allCategoryDetails![j].id!,
                               store.homescreen.data!.allCategoryDetails![j].categoryName!,
                               store.homescreen.data!.allCategoryDetails![j].description!),

                     ),);
               },
             ),
           /*  Container(
            height: 50.0,
            child: Stack(
              // fit: StackFit.expand,
              children:[
                Positioned(
                  child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_back, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.blue, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),left: 1,),
                new ListView.builder(
                    shrinkWrap: true,
                    controller: cstscrollcontroller,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesData.items.length,
                    itemBuilder: (_, j) =>
                        showSubCategory(categoriesData.items[j].catid,categoriesData.items[j].title)),
                Positioned(child: ElevatedButton(
                  onPressed: () {

                  },child: Icon(Icons.arrow_forward, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.blue, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),right: 1,),
              ],
            ),
          ),*/
           Container(
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 color: ColorCodes.whiteColor,
                 /*borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),*/
                 boxShadow: [
                   BoxShadow(
                     color: ColorCodes.grey.withOpacity(0.3),
                     spreadRadius: 1,
                     blurRadius: 3,
                     offset: Offset(0, 3),
                   )
                 ],
               )
           ),
         ],
       );
     },
    );
  }



 /* launchWhatsapp({required number,required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    try{
      launch(url);
    }catch(e){
    }

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
  /* void launchWhatsapp({required number,required message})async{


    final link = WhatsAppUnilink(
      phoneNumber: number,
      text: " I want to order ",
    );
    await launch('$link');
  }*/

  fetchPrimary(){
    String isMapfetch,isdefaultloc;
    isMapfetch = PrefUtils.prefs!.getString("ismapfetch").toString();
    isdefaultloc=PrefUtils.prefs!.getString('defaultlocation').toString();//(prefs.getBool('defaultlocation')!=null)?prefs.getBool('defaultlocation'):false;
    debugPrint("ismapfetch"+isMapfetch.toString());
    debugPrint("default loc"+isdefaultloc.toString());
    if(PrefUtils.prefs!.getString("defaultlocation").toString()!="null" && PrefUtils.prefs!.getString("ismapfetch").toString()!="null"){
      debugPrint("iffffffff.....");
      setState(() {
        _deliverLocation = PrefUtils.prefs!.getString("deliverylocation")!;
        IConstants.deliverylocationmain.value = _deliverLocation;
        IConstants.currentdeliverylocation.value = S .of(context).location_available;
        debugPrint("delloc"+_deliverLocation.toString());
      });
    }else{
      debugPrint("else........");

      // getCurrentLocation();
    }
  }

  // void getCurrentLocation() async {
  //   // PermissionStatus permission = await LocationPermissions().requestPermissions();
  //   // permission = await LocationPermissions().checkPermissionStatus();
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.camera,
  //   ].request();
  //   var status = await Permission.location.status;
  //
  //
  //   if(statuses[Permission.location]!.isDenied){ //check each permission status after.
  //     print("Location permission is denied.");
  //     PrefUtils.prefs!.setString("ismapfetch","true");
  //     setState(() {
  //       // _permissiongrant = false;
  //       if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
  //         Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
  //           setState(() {
  //             debugPrint("build 1");
  //             PrefUtils.prefs!.setString("deliverylocation", PrefUtils.prefs!.getString("restaurant_location")!);
  //             PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat")!);
  //             PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long")!);
  //             _deliverLocation = PrefUtils.prefs!.getString("deliverylocation")!;
  //             PrefUtils.prefs!.setString("isdelivering","false");
  //             debugPrint("defalut loc"+_deliverLocation);
  //             IConstants.deliverylocationmain.value = _deliverLocation;
  //             PrefUtils.prefs!.setString("nopermission","yes");
  //           });
  //         });
  //       } else {
  //         setState(() {
  //           _deliverLocation = PrefUtils.prefs!.getString("deliverylocation")!;
  //           PrefUtils.prefs!.setString("latitude", _lat.toString());
  //           PrefUtils.prefs!.setString("longitude", _lng.toString());
  //           debugPrint("defalut loc"+_deliverLocation);
  //           PrefUtils.prefs!.setString("isdelivering","false");
  //           IConstants.deliverylocationmain.value = _deliverLocation;
  //           PrefUtils.prefs!.setString("nopermission","yes");
  //         });
  //
  //       }
  //     });
  //
  //   }
  //   else{
  //     print("Location permission is Granted.");
  //     setState(() {
  //       // _permissiongrant = true;
  //     });
  //     PrefUtils.prefs!.setString("nopermission","no");
  //     // checkusergps();
  //
  //   }
  //
  //   if(statuses[Permission.camera]!.isDenied){ //check each permission status after.
  //     print("Camera permission is denied.");
  //   }
  //   /* if(!status.isGranted){
  //     var status = await Permission.location.request();
  //     if(status.isGranted){
  //       var status = await Permission.camera.status;
  //       if(!status.isGranted){
  //         var status = await Permission.camera.request();
  //         if(status.isGranted){
  //           //Good, all your permission are granted, do some stuff
  //         }else{
  //           //Do stuff according to this permission was rejected
  //         }
  //       }
  //     }else{
  //       //Do stuff according to this permission was rejected
  //     }
  //
  //
  //     PrefUtils.prefs!.setString("ismapfetch","true");
  //     setState(() {
  //       _permissiongrant = false;
  //       if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
  //         Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
  //           setState(() {
  //             debugPrint("build 1");
  //             PrefUtils.prefs!.setString("deliverylocation", PrefUtils.prefs!.getString("restaurant_location"));
  //             PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat"));
  //             PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long"));
  //             _deliverLocation = PrefUtils.prefs!.getString("deliverylocation");
  //             PrefUtils.prefs!.setString("isdelivering","false");
  //             debugPrint("defalut loc"+_deliverLocation);
  //             IConstants.deliverylocationmain.value = _deliverLocation;
  //             PrefUtils.prefs!.setString("nopermission","yes");
  //           });
  //         });
  //       } else {
  //         setState(() {
  //           _deliverLocation = PrefUtils.prefs!.getString("deliverylocation");
  //           PrefUtils.prefs!.setString("latitude", _lat.toString());
  //           PrefUtils.prefs!.setString("longitude", _lng.toString());
  //           debugPrint("defalut loc"+_deliverLocation);
  //           PrefUtils.prefs!.setString("isdelivering","false");
  //           IConstants.deliverylocationmain.value = _deliverLocation;
  //           PrefUtils.prefs!.setString("nopermission","yes");
  //         });
  //
  //       }
  //     });
  //   }
  //   else{
  //     setState(() {
  //       _permissiongrant = true;
  //
  //
  //     });
  //     PrefUtils.prefs!.setString("nopermission","no");
  //     checkusergps();
  //   }*/
  //   /* if (permission.toString() == "PermissionStatus.granted") {
  //     setState(() {
  //       _permissiongrant = true;
  //
  //
  //     });
  //     PrefUtils.prefs!.setString("nopermission","no");
  //     checkusergps();
  //   }
  //   else {
  //     PrefUtils.prefs!.setString("ismapfetch","true");
  //     setState(() {
  //       _permissiongrant = false;
  //       if (!PrefUtils.prefs!.containsKey("deliverylocation")) {
  //         Provider.of<BrandItemsList>(context, listen: false).GetRestaurant().then((_) {
  //           setState(() {
  //             debugPrint("build 1");
  //             PrefUtils.prefs!.setString("deliverylocation", PrefUtils.prefs!.getString("restaurant_location"));
  //             PrefUtils.prefs!.setString("latitude", PrefUtils.prefs!.getString("restaurant_lat"));
  //             PrefUtils.prefs!.setString("longitude", PrefUtils.prefs!.getString("restaurant_long"));
  //             _deliverLocation = PrefUtils.prefs!.getString("deliverylocation");
  //             PrefUtils.prefs!.setString("isdelivering","false");
  //             debugPrint("defalut loc"+_deliverLocation);
  //             IConstants.deliverylocationmain.value = _deliverLocation;
  //             PrefUtils.prefs!.setString("nopermission","yes");
  //           });
  //         });
  //       } else {
  //         setState(() {
  //           _deliverLocation = PrefUtils.prefs!.getString("deliverylocation");
  //           PrefUtils.prefs!.setString("latitude", _lat.toString());
  //           PrefUtils.prefs!.setString("longitude", _lng.toString());
  //           debugPrint("defalut loc"+_deliverLocation);
  //           PrefUtils.prefs!.setString("isdelivering","false");
  //           IConstants.deliverylocationmain.value = _deliverLocation;
  //           PrefUtils.prefs!.setString("nopermission","yes");
  //         });
  //
  //       }
  //     });
  //
  //     // checkusergps();
  //    */
  //   /* Prediction p = await PlacesAutocomplete.show(
  //         mode: Mode.overlay, context: context, apiKey: kGoogleApiKey);
  //     displayPrediction(p);*/
  //   /*
  //
  //   }*/
  // }

  // checkusergps() async {
  //   loc.Location location = new loc.Location();
  //   var temp = await location.serviceEnabled();
  //   setState(() {
  //     _serviceEnabled = temp;
  //   });
  //   if (!_serviceEnabled) {
  //     debugPrint("Service Not Enabled ::");
  //     setState(() {
  //       _deliverLocation=PrefUtils.prefs!.getString("deliverylocation");
  //       PrefUtils.prefs!.setString("latitude", _lat.toString());
  //       PrefUtils.prefs!.setString("longitude", _lng.toString());
  //       IConstants.deliverylocationmain.value = _deliverLocation;
  //     });
  //
  //     PrefUtils.prefs!.setString("nopermission","yes");
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       setState(() {
  //         count++;
  //       });
  //       if (count == 1)
  //         location.requestService();
  //       /* showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text(
  //                   translate('forconvience.Location unavailable')  //"Location unavailable"
  //               ),
  //               content:  Text(
  //                   translate('forconvience.Please enable location') //'Please enable the location from device settings.'
  //               ),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: Text('Ok'),
  //                   onPressed: () async {
  //                     setState(() {
  //                       count = 0;
  //                     });
  //                     //await AppSettings.openLocationSettings();
  //                     location.requestService();
  //                     Navigator.of(context, rootNavigator: true).pop();
  //                     //checkusergps();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );*/
  //     }
  //   } else {
  //     PrefUtils.prefs!.setString("nopermission","no");
  //     debugPrint("Service Enabled ::");
  //     Position res = await Geolocator().getCurrentPosition();
  //     setState(() {
  //       position = res;
  //       _lat = position.latitude;
  //       _lng = position.longitude;
  //       /* cameraposition = CameraPosition(
  //         target: LatLng(_lat, _lng),
  //         zoom: 16.0,
  //       );*/
  //       //_child = mapWidget();
  //     });
  //     await getAddress(_lat, _lng);
  //   }
  // }
  //
  //
  // List<Placemark> placemark;
  // void getAddress(double latitude, double longitude) async {
  //   loc.Location location = new loc.Location();
  //   var temp = await location.serviceEnabled();
  //   setState(() {
  //     _serviceEnabled = temp;
  //   });
  //   if (!_serviceEnabled) {
  //     // checkusergps();
  //     SetPrimeryLocation();
  //   }
  //   placemark =
  //   await Geolocator().placemarkFromCoordinates(latitude, longitude);
  //
  //   if (placemark[0].subLocality.toString() == "") {
  //     if (placemark[0].locality.toString() == "") {
  //       _mapaddress = "";
  //       addressLine="";
  //       //_child = mapWidget();
  //     } else {
  //
  //       // _address = placemark[0].locality.toString();
  //       final coordinates = new Coordinates(_lat, _lng);
  //       var addresses;
  //       addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //       setState(() {
  //         var first = addresses.first;
  //         print("${first.featureName} : ${first.addressLine}");
  //
  //         _mapaddress = (first.featureName!=null)?(first.featureName):first.featureName;
  //         addressLine=first.addressLine;//(first.subLocality!=null)?(first.subLocality+","+first.locality+","+first.adminArea)
  //         PrefUtils.prefs!.setString("default location","true");
  //         PrefUtils.prefs!.setString('defaultlocation', "true");
  //
  //
  //         setState(() {
  //           _deliverLocation=addressLine;
  //           PrefUtils.prefs!.setString("deliverylocation",addressLine);
  //           PrefUtils.prefs!.setString("latitude", _lat.toString());
  //           PrefUtils.prefs!.setString("longitude", _lng.toString());//prefs.getString("deliverylocation");//
  //         });
  //
  //         // prefs.setString("delivery")
  //         // _deliverLocation=addressLine;
  //         // :(first.locality+","+first.adminArea);
  //         debugPrint("Check Location..start........");
  //         checkLocation();
  //
  //         debugPrint("Check Location...end......");
  //         debugPrint("latlong: "+_lat.toString()+" "+ _lng.toString());
  //         debugPrint("address: "+_mapaddress);
  //         debugPrint("addressline"+addressLine);
  //       });
  //
  //       // _child = mapWidget();
  //     }
  //   } else {
  //     // _address = final coordinates = new Coordinates(_lat, _lng);
  //     var addresses;
  //     addresses = await Geocoder.local.findAddressesFromCoordinates(
  //         new Coordinates(_lat, _lng));
  //     setState(() {
  //       var first = addresses.first;
  //       print("${first.featureName} : ${first.addressLine}");
  //
  //       _mapaddress = (first.featureName!=null)?(first.featureName):first.featureName;
  //       addressLine=first.addressLine;
  //       PrefUtils.prefs!.setString("default location","true");
  //       PrefUtils.prefs!.setString('defaultlocation', "true");
  //       //prefs.setString("deliverylocation",addressLine);
  //       setState(() {
  //         _deliverLocation=addressLine;
  //         PrefUtils.prefs!.setString("deliverylocation",addressLine);
  //         PrefUtils.prefs!.setString("latitude", _lat.toString());
  //         PrefUtils.prefs!.setString("longitude", _lng.toString());
  //         //prefs.getString("deliverylocation");//addressLine;
  //       });
  //       debugPrint("Check Location..start........");
  //       checkLocation();
  //
  //       debugPrint("Check Location...end......");
  //       // prefs.setString("deliverylocation",addressLine);
  //       // _deliverLocation=addressLine;
  //       /*  addressLine = (first.subLocality != null) ? (first.subLocality + "," +
  //             first.locality + "," + first.adminArea)
  //             : (first.locality + "," + first.adminArea);*/
  //       debugPrint("latlong: " + _lat.toString() + _lng.toString());
  //       debugPrint("address: " + _mapaddress);
  //       debugPrint("addressline" + addressLine);
  //     });
  //     // _child = mapWidget();
  //   }
  // }

  Future<void> checkLocation() async {
    debugPrint("checkLocation . . . , , ");
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'check-location';
    try {
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "lat": _lat.toString(),
        "long": _lng.toString(),
        "branch" : PrefUtils.prefs!.getString("branch"),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseJson = json.decode(response.body);
      debugPrint("checkLocation........");
      debugPrint(_lat.toString());
      debugPrint(_lng.toString());
      debugPrint(responseJson.toString());
      bool _isCartCheck = false;
      if (responseJson['status'].toString() == "yes") {
        if(PrefUtils.prefs!.getString("branch") == responseJson['branch'].toString()) {
          debugPrint("trueee..............");
          PrefUtils.prefs!.setString("nopermission","no");
          PrefUtils.prefs!.setString("available", "yes");
          PrefUtils.prefs!.setString("isdelivering","true");

        }
        else {
          debugPrint("false..............");

        }
      } else {
        //Navigator.of(context).pop();
        debugPrint("snack..............");
        PrefUtils.prefs!.setString("nopermission","yes");
        PrefUtils.prefs!.setString("available", "no");
        PrefUtils.prefs!.setString("isdelivering","false");
        IConstants.currentdeliverylocation.value = S .of(context).not_available_location;//"Not Available";
      }
    } catch (error) {
      throw error;
    }
  }

  createHeaderForMobile() {


    final brandsData = Provider.of<BrandItemsList>(context, listen: false);
    final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
    final discountitemData = Provider.of<SellingItemsList>(context, listen: false);

    if (brandsData.items.length > 0 ||
        sellingitemData.items.length > 0 ||
        categoriesData.items.length > 0 ||
        discountitemData.itemsdiscount.length > 0) {
      _isDelivering = true;
    } else {
      _isDelivering = false;
    }

    /*if(_deliverLocation!=null ){
      if(_deliverLocation.indexOf(' ') >= 0){
        int idx = _deliverLocation.indexOf(" ");
        _deliveryLocmain = _deliverLocation.substring(0,idx).trim().toString();
        _deliverySubloc = _deliverLocation.substring(idx+1).trim().toString();
      }
      else{
        _deliveryLocmain = _deliverLocation;//_deliverLocation.substring(0,idx).trim().toString();
        _deliverySubloc = _deliverLocation;//_deliverLocation.substring(idx+1).trim().toString();
      }

    }*/
    print("..,mnbvcxz....." + store.userData.area.toString());
    return Container(

        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorCodes.whiteColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,

              colors: [
                IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
              ],
            )
        ),
        //color: Theme.of(context).primaryColor,
        height: (Vx.isWeb && _isshow) ? 220.0 :_isDelivering ? IConstants.isEnterprise ?  135.0 : 120 : IConstants.isEnterprise ? 135 : 120,
        width: MediaQuery.of(context).size.width,
        child:Column(
            children: <Widget>[
              (Vx.isWeb && ResponsiveLayout.isSmallScreen(context))?
              _isshow ?
              Container(
                // height:50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                      IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Images.logoImg1,
                      // color: Colors.white,
                      height: 30,
                      // width: 200,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Text(
                          S .of(context).download_our_app,//"DOWNLOAD APP",
                          style: TextStyle(fontSize: 14, color:IConstants.isEnterprise? Colors.white:Colors.black),
                        ),
                        SizedBox(width: 10,),
                        Text(
                            S .of(context).download_app_for_best+IConstants.isEnterprise.toString(),//"Download the app for the best",
                            style: TextStyle(
                                fontSize: 12, color: IConstants.isEnterprise? Colors.white:Colors.black)),
                        Text(
                            S .of(context).grocery_experience,//"Grocery Shopping Experiance",
                            style: TextStyle(
                                fontSize: 12, color: IConstants.isEnterprise? Colors.white:Colors.black)),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [

                        Container(
                          margin: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isshow = !_isshow;
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 15,
                              color: IConstants.isEnterprise? Colors.white:Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Vx.isWeb) {
                              launch(
                                  'https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                            }
                            else if (!Vx.isWeb) {
                              launch(
                                  'https://apps.apple.com/us/app/id' + IConstants.appleId);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.white, // Set border color
                                  width: 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                            ),
                            // Set border width
                            child: Text("DOWNLOAD APP", style: TextStyle(
                                fontSize: 10, color: Colors.green)),
                          ),
                        ),
                      ],

                    ),
                  ],
                ),
              ) : SizedBox.shrink()
                  :SizedBox.shrink(),
              Row(
                children: <Widget>[
                  /*SizedBox(
                width: 12,
              ),*/
                  ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation,
                      builder: (context,value, widget){
                        return IconButton(
                          padding: EdgeInsets.only(left: 0.0),
                          icon: Icon(
                            Icons.menu,
                            color: IConstants.isEnterprise ? ColorCodes.menuColor : ColorCodes.darkgreen,
                            size: IConstants.isEnterprise ? 25.0 : 30,
                          ),
                          onPressed: () {
                            if (value != S .of(context).not_available_location)
                              HomeScreen.scaffoldKey.currentState!.openDrawer();
                          },
                        );
                      }),
                  if(!IConstants.isEnterprise)
                    Spacer(),
                  Image.asset(
                    IConstants.isEnterprise?Images.logoAppbarImg:Images.logoAppbarImglite,
                    height: IConstants.isEnterprise ? 50 : 75,
                    width: IConstants.isEnterprise ? 138 : 165,
                  ),
                  Spacer(),
                  SizedBox(
                    width: 10,
                  ),
                  if(Features.isWhatsapp)
                    GestureDetector(
                      onTap:(){
                        //launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery");
                        launchWhatsApp();
                      },
                      child: Image.asset(
                        Images.whatsapp,
                        height: 25,
                        width: 25,
                        color: IConstants.isEnterprise?Colors.white:ColorCodes.greenColor,
                      ),
                    ),
                  if(Features.isWhatsapp)
                    SizedBox(
                      width: 7,
                    ),
                  if(Features.isPushNotification)
                    ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation,
                        builder: (context, value, widget){
                          return VxBuilder<GroceStore>(
                            mutations: {SetUserData},
                            builder: (context,GroceStore store, status) {
                              int _count = store.notificationCount ??= 0;
                              if (_count <= 0)
                                return Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    // color: Theme.of(context).buttonColor
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      /*  if(snapshot.hasData) {
                            debugPrint("1...");
                            Navigator.of(context).pushNamed(
                                NotificationScreen.routeName);
                          }
                          else {
                            debugPrint("2...");
                            Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,);
                          }*/
                                      //if (_isDelivering)
                                      if (value != S .of(context).not_available_location)
                                        if(!PrefUtils.prefs!.containsKey("apikey")){
                                          debugPrint("1...");
                                          /*Navigator.of(context).pushNamed(
                                            SignupSelectionScreen.routeName,
                                          );*/
                                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                        }else{
                                          debugPrint("2...");
                                          Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notify);

                                        }
                                    },
                                    child: /*Icon(
                          Icons.notifications_none,
                          size: IConstants.isEnterprise ? 19: 22,
                          color: Theme.of(context).primaryColor,
                        ),*/
                                    Image.asset(
                                      Images.header_Notification,
                                      height: 25,
                                      width: 25,
                                      color: IConstants.isEnterprise?Colors.white:ColorCodes.mediumBlackWebColor,
                                    ),
                                  ),
                                );
                              return Consumer<NotificationItemsList>(
                                builder: (_, cart, ch) => Badge(
                                  child: ch!,
                                  color: ColorCodes.darkgreen,
                                  value: _count.toString(),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 10, right: 10, bottom: 10),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100)),
                                  // color: Theme.of(context).buttonColor),
                                  child: GestureDetector(
                                    onTap: () {
                                      // if (_isDelivering)
                                      if (value != S .of(context).not_available_location)
                                        if(!PrefUtils.prefs!.containsKey("apikey")){
                                          debugPrint("4...");
                                          /*Navigator.of(context).pushNamed(
                                            SignupSelectionScreen.routeName,
                                          );*/
                                          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push);
                                        }else{
                                          debugPrint("5...");
                                          Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notify);
                                          NotificationController(NotificationTYP.clear);
                                        }
                                    },
                                    child: /*Icon(
                            Icons.notifications_none,
                            size: IConstants.isEnterprise ? 19: 22,
                            color: Theme.of(context).primaryColor,
                          ),*/
                                    Image.asset(
                                      Images.header_Notification,
                                      height: 25,
                                      width: 25,
                                      color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  // if(Features.isPushNotification)
                  //   ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation,
                  //       builder: (context, value, widget){
                  //         return StreamBuilder<int>(
                  //           stream: headerBloc.notificationCountStream,
                  //           builder: (context, snapshot) {
                  //             int _count = snapshot.hasData ? snapshot.data : 0;
                  //             if (_count <= 0)
                  //               return Container(
                  //                 width: 25,
                  //                 height: 25,
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(100),
                  //                   // color: Theme.of(context).buttonColor
                  //                 ),
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     /*  if(snapshot.hasData) {
                  //           debugPrint("1...");
                  //           Navigator.of(context).pushNamed(
                  //               NotificationScreen.routeName);
                  //         }
                  //         else {
                  //           debugPrint("2...");
                  //           Navigator.of(context).pushNamed(
                  //             SignupSelectionScreen.routeName,);
                  //         }*/
                  //                     //if (_isDelivering)
                  //                     if (value != S .of(context).not_available_location)
                  //                       if(!PrefUtils.prefs!.containsKey("apikey")){
                  //                         debugPrint("1...");
                  //                         Navigator.of(context).pushNamed(
                  //                           SignupSelectionScreen.routeName,
                  //                         );
                  //                       }else{
                  //                         debugPrint("2...");
                  //                         Navigator.of(context).pushNamed(
                  //                             NotificationScreen.routeName);
                  //                       }
                  //                   },
                  //                   child: /*Icon(
                  //         Icons.notifications_none,
                  //         size: IConstants.isEnterprise ? 19: 22,
                  //         color: Theme.of(context).primaryColor,
                  //       ),*/
                  //                   Image.asset(
                  //                     Images.header_Notification,
                  //                     height: 25,
                  //                     width: 25,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               );
                  //             return Consumer<NotificationItemsList>(
                  //               builder: (_, cart, ch) => Badge(
                  //                 child: ch,
                  //                 color: ColorCodes.darkgreen,
                  //                 value: _count.toString(),
                  //               ),
                  //               child: GestureDetector(
                  //                 onTap: () {
                  //                   debugPrint("3...");
                  //                   if (value != S .of(context).not_available_location)
                  //                     Navigator.of(context)
                  //                         .pushNamed(NotificationScreen.routeName);
                  //                 },
                  //                 child: Container(
                  //                   margin: EdgeInsets.only(
                  //                       top: 10, right: 10, bottom: 10),
                  //                   width: 25,
                  //                   height: 25,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(100)),
                  //                   // color: Theme.of(context).buttonColor),
                  //                   child: GestureDetector(
                  //                     onTap: () {
                  //                       // if (_isDelivering)
                  //                       if (value != S .of(context).not_available_location)
                  //                         if(!PrefUtils.prefs!.containsKey("apikey")){
                  //                           debugPrint("4...");
                  //                           Navigator.of(context).pushNamed(
                  //                             SignupSelectionScreen.routeName,
                  //                           );
                  //                         }else{
                  //                           debugPrint("5...");
                  //                           Navigator.of(context).pushNamed(
                  //                               NotificationScreen.routeName);
                  //                         }
                  //
                  //                     },
                  //                     child: /*Icon(
                  //           Icons.notifications_none,
                  //           size: IConstants.isEnterprise ? 19: 22,
                  //           color: Theme.of(context).primaryColor,
                  //         ),*/
                  //                     Image.asset(
                  //                       Images.header_Notification,
                  //                       height: 25,
                  //                       width: 25,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       }),
                  SizedBox(
                    width: 5,
                  ),
                  ValueListenableBuilder(
                      valueListenable: IConstants.currentdeliverylocation,
                      builder: (context, value, widget){return VxBuilder(
                          // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                          builder: (context, GroceStore box, index) {
                            // if (CartCalculations.itemCount<=0)
                    //   return GestureDetector(
                    //     onTap: () {
                    //       if (value != S .of(context).not_available_location)
                    //       Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                    //         "afterlogin": ""
                    //       });
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    //       width: 28,
                    //       height: 28,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(100),
                    //         /* color: Theme.of(context).buttonColor*/),
                            //       child: /*Icon(
                    //       Icons.shopping_cart_outlined,
                    //       size: IConstants.isEnterprise ? 24: 21,
                    //       color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                    //     ),*/
                    //       Image.asset(
                    //         Images.header_cart,
                    //         height: 28,
                    //         width: 28,
                    //         color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                    //       ),
                    //     ),
                    //   );
                    return Consumer<CartCalculations>(
                      builder: (_, cart, ch) => Badge(
                        child: ch!,
                        color: ColorCodes.darkgreen,
                        value: CartCalculations.itemCount.toString(),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (value != S .of(context).not_available_location)
                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                         /* Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                            "afterlogin": ""
                          });*/
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            /*color: Theme.of(context).buttonColor*/),
                          child: /*Icon(
                          Icons.shopping_cart_outlined,
                          size: IConstants.isEnterprise ? 24: 21,
                          color: IConstants.isEnterprise ? *//*Theme.of(context).primaryColor*//*Colors.white : ColorCodes.mediumBlackWebColor,
                        ),*/
                                  Image.asset(
                                    Images.header_cart,
                                    height: 28,
                                    width: 28,
                                    color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
                                  ),
                                ),
                              ),);
                          },mutations: {SetCartItem},
                        );}),
                  SizedBox(width: 5),
                ],
              ),
              IConstants.isEnterprise ?
              SizedBox(
                height: 5,
              ) :
              SizedBox(
                height: 0,
              ),
              IConstants.isEnterprise ?
              ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation, builder: (context, value ,widget){
                return  Container(

                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorCodes.searchColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ColorCodes.searchBoarder)
                  ),
                  width: MediaQuery.of(context).size.width,
                  /*margin: EdgeInsets.symmetric(horizontal: 10),*/
                  padding: IConstants.isEnterprise ? EdgeInsets.only(left: 15,right: 15) : EdgeInsets.only(left: 15,right: 15),

                  child: IntrinsicHeight(
                    child:
                    Row(
                      children: [
                        if(IConstants.isEnterprise) GestureDetector(
                          onTap: () {
                            if (value != S .of(context).not_available_location)
                              //if (_isDelivering)
                             /* Navigator.of(context).pushNamed(
                                CategoryScreen.routeName,
                              );*/
                              Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                          },
                          child: Image.asset(
                            Images.categoriesImg,
                            height: 24,
                            color: ColorCodes.whiteColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        VerticalDivider(
                          color: ColorCodes.whiteColor,
                          endIndent: 8,
                          indent: 8,
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            // if (_isDelivering)
                            if (value != S .of(context).not_available_location)
                              Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.76,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S .of(context).search_from_products,//" Search From 10,000+ products",
                                  style: TextStyle(
                                    color: ColorCodes.searchText,

                                  ),
                                ),
                                //SizedBox(width: MediaQuery.of(context).size.width),
                                Icon(
                                  Icons.search,
                                  color: ColorCodes.searchIcon,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
                  :
              Container(
                height: 35,
                padding: EdgeInsets.only(left: 5,right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        PrefUtils.prefs!.setString("formapscreen", "homescreen");
                        /*Navigator.of(context).pushNamed(MapScreen.routeName,arguments: {
                          "valnext": "",
                        });*/
                        Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push,
                            qparms:{
                              "valnext": "",
                            });
                      },
                      child: Icon(Icons.location_on,
                          color: ColorCodes.darkgreen, size: 33),
                    ),
                    VxBuilder(
                        mutations: {SetPrimeryLocation,HomeScreenController},
                        builder: (context,GroceStore store,state){
                          debugPrint("aa....///." + store.userData.area.toString());
                          String _deliverLocation = "";
                          String _deliveryLocmain = "";
                          String _deliverySubloc = "";
                          _deliverLocation = store.userData.area!=null?store.userData.area! : "";
                          if(_deliverLocation!=null ){
                            if(_deliverLocation.indexOf(' ') >= 0){
                              int idx = _deliverLocation.indexOf(" ");
                              _deliveryLocmain = _deliverLocation.substring(0,idx).trim().toString();
                              _deliverySubloc = _deliverLocation.substring(idx+1).trim().toString();
                            } if(_deliverLocation.indexOf(',') >= 0) {
                              int idx = _deliverLocation.indexOf(",");
                              _deliveryLocmain = _deliverLocation.substring(0,idx).trim().toString();
                              _deliverySubloc = _deliverLocation.substring(idx+1).trim().toString();
                            } else{
                              _deliveryLocmain = _deliverLocation;//_deliverLocation.substring(0,idx).trim().toString();
                              _deliverySubloc = _deliverLocation;//_deliverLocation.substring(idx+1).trim().toString();
                            }

                          }
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push,
                                    qparms:{
                                      "valnext": "",
                                    });
                              },
                              child: RichText(
                                maxLines: 2,
                                overflow:TextOverflow.ellipsis,
                                text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: _deliveryLocmain + "\n",//_delLocation[0].trim()+"\n",
                                      //(_deliverLocation!=null)?_deliverLocation:"",
                                      style: TextStyle(
                                          color: ColorCodes.blackColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new TextSpan(
                                      text: _deliverySubloc,//_delLocation[1].trim(),//"Ambalapadi, Udupi, Karnataka...............",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8, color: ColorCodes.grey ),
                                    ),
                                  ],
                                ),
                              ),
                              /*child: Text(
                       //(_deliverLocation!=null)?_deliverLocation:"",
                       "Ambalapadi",
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                           color: ColorCodes.blackColor,
                           fontSize: 17.0,
                           fontWeight: FontWeight.bold),
                     ),*/
                            ),
                          );
                        }
                    ),
                    SizedBox(width: 10.0),
                    ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation, builder: (context, value, widget){
                      return Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 1.7,
                        //color: ColorCodes.grey,
                        decoration: BoxDecoration(
                            color: ColorCodes.lightGreyWebColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorCodes.lightGreyWebColor)
                        ),
                        //width: MediaQuery.of(context).size.width,
                        /*margin: EdgeInsets.symmetric(horizontal: 10),*/
                        padding: IConstants.isEnterprise ? EdgeInsets.only(left: 15) : EdgeInsets.only(left: 7,right: 10),

                        child: IntrinsicHeight(
                          child:
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // if (_isDelivering)
                                  Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

                                },
                                child: Container(
                                  //width: MediaQuery.of(context).size.width * 1.2,
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                          Icons.search,
                                          color: ColorCodes.grey,
                                          size: 22
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        S .of(context).search_from_products,//" Search From 10,000+ products",
                                        style: TextStyle(
                                          color: ColorCodes.grey,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      //SizedBox(width: MediaQuery.of(context).size.width),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                    ,
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width,
                color: IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
              ),
              IConstants.isEnterprise ?
              Container(
                  decoration:/*(IConstants.isEnterprise)?*/ BoxDecoration(
                    // boxShadow: <BoxShadow>[
                    //   BoxShadow(
                    //       color: ColorCodes.grey,
                    //       blurRadius: 15.0,
                    //       offset: Offset(0.0, 0.75))
                    // ],
                    color: ColorCodes.whiteColor,
                  ),
                  /*: BoxDecoration(
                boxShadow: <BoxShadow>[
                 BoxShadow(
                   color: ColorCodes.grey,
                   offset: Offset(0.0, 0.0),
                 ),
                 ],
                  color: Theme.of(context).buttonColor,
               ),*/
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  child: Row(
                      children: [
                        // IconButton(icon: Icon(Icons.location_on,size:18,color: Colors.black,)),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            PrefUtils.prefs!.setString("formapscreen", "homescreen");
                            /*Navigator.of(context).pushNamed(MapScreen.routeName,arguments: {
                              "valnext": "",
                            });*/
                            Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push,
                                qparms:{
                                  "valnext": "",
                                });
                          },
                          child: Icon(Icons.location_on,
                              color: ColorCodes.deliveryLocation, size: 16),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        VxBuilder(
                          mutations: {SetPrimeryLocation,HomeScreenController},
                          builder: (context,GroceStore store,state){
                            return  Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  PrefUtils.prefs!.setString("formapscreen", "homescreen");
                                  /*Navigator.of(context).pushNamed(MapScreen.routeName,arguments: {
                                    "valnext": "",
                                  });*/
                                  Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push,
                                      qparms:{
                                        "valnext": "",
                                      });
                                },
                                child: Text(
                                  store.userData.area!=null?store.userData.area!:"",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ColorCodes.deliveryLocation,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              PrefUtils.prefs!.setString("formapscreen", "homescreen");
                              Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push);
                             // Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
                            },
                            child: Text(
                              S .of(context).change,//"Change",
                              style: TextStyle(
                                  color: ColorCodes.deliveryLocation,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: 15,
                        )
                      ])):
              SizedBox.shrink(),
            ]));
  }

  showSubCategory(String catid, String title, String description) {
    // print("description click...."+description.toString());
    ProductController productController = ProductController();
    if(store.homescreen.data!.allCategoryDetails![store.homescreen.data!.allCategoryDetails!.indexWhere((element) => element.id == catid)].subCategory.isEmpty)
    productController.geSubtCategory(catid,onload:(bool status){});
      return VxBuilder(builder: (context, GroceStore store,state){

  int j=0;
  List<CategoryData> subcategoryData =[];
  final catlist = store.homescreen.data!.allCategoryDetails;
  if(catlist!=null) subcategoryData = store.homescreen.data!.allCategoryDetails![catlist.indexWhere((element) => element.id == catid)].subCategory;
  //   context,
  //   listen: false,
  // ).findByIdweb(catid);
  // print("showSubCategory....." + subcategoryData.length.toString() + "..." + title);
  return Container(
    padding: EdgeInsets.only(left: 20,/*bottom:30*/),
    child: PopupMenuButton(
      tooltip: description,
      offset: const Offset(0, 50),
      onSelected: (String selectedValue) {setState(() {widget.onSubcatClick==null?
     /* Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
        'maincategory': title.toString(),
        'catId': catid.toString(),
        'catTitle': title.toString(),
        'subcatId': selectedValue.toString(),
        'indexvalue': j.toString(),
        // 'type':subcategoryData.where((element) => element.id == selectedValue.toString()).first.type,
        'prev': "category_item"
      })*/
      Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
          qparms: {
            'maincategory': title.toString(),
            'catId': catid.toString(),
            'catTitle': title.toString(),
            'subcatId': selectedValue.toString(),
            'indexvalue': j.toString(),
            // 'type':subcategoryData.where((element) => element.id == selectedValue.toString()).first.type,
            'prev': "category_item"
          })
          :widget.onSubcatClick!(catid,selectedValue,0,j);});},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        for (j=1;j<subcategoryData.length;j++)
          new PopupMenuItem<String>(
            height: 28,
            child: Text(subcategoryData[j].categoryName!,style: TextStyle(fontSize: 18),),
            value: subcategoryData[j].id,
          ),
      ],
    ),
  );
}, mutations: {ProductMutation});
  }
  Future<void> logout() async {
    PrefUtils.prefs!.remove('LoginStatus');
    try {
      // PrefUtils.prefs!.remove('LoginStatus');
      if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {
        PrefUtils.prefs!.setString("photoUrl", "");
        await _googleSignIn.signOut();
      } else if (PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {
        PrefUtils.prefs!.getString("FBAccessToken");
        var facebookSignIn = FacebookLoginWeb();
        final graphResponse = await http.delete(
            'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs!.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');
        PrefUtils.prefs!.setString("photoUrl", "");
        await facebookSignIn.logOut().then((value) {
        });
      }
    } catch (e) {
    }
    String branch = PrefUtils.prefs!.getString("branch")!;
    String _tokenId = PrefUtils.prefs!.getString("tokenid")!;
    String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
    String _restaurant_location = PrefUtils.prefs!.getString("restaurant_location")!;
    String _deliverylocation = PrefUtils.prefs!.getString("deliverylocation")!;
    PrefUtils.prefs!.clear();
    PrefUtils.prefs!.setBool('introduction', true);
    PrefUtils.prefs!.setString("branch", branch);
    PrefUtils.prefs!.setString('skip', "yes");
    PrefUtils.prefs!.setString('ftokenid', _ftokenId);
    PrefUtils.prefs!.setString('tokenid', _tokenId);
    PrefUtils.prefs!.setString('restaurant_location', _restaurant_location);
    PrefUtils.prefs!.setString('deliverylocation', _deliverylocation);
    //_dialogforSignIn();
    /*Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));*/
    /*Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (route) => false);*/
    Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);

    setState(() {
      checkSkip = true;
    });
  }
}

Widget _DropDownItem(IconData iconData, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: <Widget>[
        Icon(
          iconData,
          color: ColorCodes.darkGrey,
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          text,
          style: TextStyle(color: ColorCodes.darkGrey, fontSize: 17),
        ),
      ],
    ),
  );
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}