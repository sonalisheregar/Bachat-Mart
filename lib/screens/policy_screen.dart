import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';
import '../screens/refer_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../assets/ColorCodes.dart';
import '../screens/about_screen.dart';
import '../screens/privacy_screen.dart';
import '../constants/IConstants.dart';
import 'dart:io';

class PolicyScreen extends StatefulWidget {
  static const routeName = '/policy-screen';

  Map<String,String> params;
  PolicyScreen(this.params);
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> with Navigations {
  bool _iscontactus = false;
  bool _isWeb =false;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;

  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final title = widget.params['title'];
    //final body = widget.params['body'];
    String body = "";

    if(title == "Refer") {
      body = PrefUtils.prefs!.getString("refer")!;
    } else if(title == "Term & Conditions") {
      body = IConstants.restaurantTerms;
    } else if(title == "Privacy" || title == "Privacy Policy") {
      body = PrefUtils.prefs!.getString("privacy")!;
    } else if(title == "Return") {
      body = IConstants.returnsPolicy;
    } else if(title == "Refund") {
      body = IConstants.refundPolicy;
    } else if(title == "About us") {
      body = PrefUtils.prefs!.getString("description")!;
    } else if(title == "Terms of Use" || title == "Terms of Service") {
      body = IConstants.restaurantTerms;
    } else if(title == "Wallet") {
      body = IConstants.walletPolicy;
    }

    if(title == "Contact Us") {
      _iscontactus = true;
    } else {
      _iscontactus = false;
    }
    
    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
            onPressed: () async {
              if(title == "Contact Us" || title == "About Us") {
                /*Navigator.of(context).popUntil(
                    ModalRoute.withName(AboutScreen.routeName,));*/
                Navigation(context, name: Routename.AboutUs, navigatore: NavigatoreTyp.Push);
              }else if(title == "Refer" ){
                /*Navigator.of(context).popUntil(
                    ModalRoute.withName(ReferEarn.routeName,));*/
                Navigation(context, name:Routename.Refer,navigatore: NavigatoreTyp.PopUntill
                );
              }else if(title == "Privacy"){
               /* Navigator.of(context).popUntil(
                    ModalRoute.withName(PrivacyScreen.routeName,));*/
                Navigation(context, name: Routename.Privacy, navigatore: NavigatoreTyp.Push);
              }
              else{
                Navigator.of(context).pop();
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(title!,
        style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                    /*ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
                  ]
              )
          ),
        ),
      );
    }
    _body() {
       /*_isloading ?
      Center(
        child: CircularProgressIndicator(),
      ) :*/
      queryData = MediaQuery.of(context);
      wid= queryData.size.width;
      maxwid=wid*0.90;
     return Expanded(
        child: SingleChildScrollView(
          child: Container(
            constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,

            child: Column(
              children: <Widget>[
                _iscontactus ?
                Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                            S .of(context).business_name,
                          // "Business Name",
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(IConstants.restaurantName, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                          S .of(context).address,
                          // "Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Expanded(child: Text(
                          PrefUtils.prefs!.getString("restaurant_address")!, style: TextStyle(fontSize: 14.0),)),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                            S .of(context).contactnumber,
                          // "Contact Number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(IConstants.primaryMobile, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(
                          S .of(context).email,
                          // "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(IConstants.primaryEmail, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0,),
                        Text(IConstants.secondaryEmail, style: TextStyle(fontSize: 14.0),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Divider(),
                  ],
                )
                    :
                Row(
                  children: <Widget>[
                    SizedBox(width: 5.0,),
//                  Expanded(child: Text(privacy)),
                    Expanded(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0),
                          child: Html(data: body,
                            style: {
                              "span": Style(
                                fontSize: FontSize(12.0),
                                fontWeight: FontWeight.normal,
                              )
                            },
                          ),
                        )
                    ),
                    // SizedBox(width: 5.0,),
                  ],
                ),
                  if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _body(),
        ],
      ),
    );
  }
}
