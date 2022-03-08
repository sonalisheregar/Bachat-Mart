import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/about-screen';
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with Navigations{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: gradientappbarmobile(),
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0,),
              if(PrefUtils.prefs!.getString("description")!="")
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,parms: {"title": S.of(context).about_us/*, "body" :PrefUtils.prefs!.getString("description").toString()*/});
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S .of(context).about_us
                      // "About Us"
                      , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              if(PrefUtils.prefs!.getString("description")!="")
              SizedBox(height: 5.0,),
              if(PrefUtils.prefs!.getString("description")!="")
              Divider(),
              SizedBox(height: 5.0,),
              GestureDetector(
                onTap: () async {
                  Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                      parms: {
                    "title": S.of(context).contact_us,
                       // "body": " ",
                        //"businessname": IConstants.restaurantName,
                        //"address": PrefUtils.prefs!.getString("restaurant_address").toString(),
                        //"contactnum": IConstants.primaryMobile,
                        //"pemail": IConstants.primaryEmail,
                        //"semail": IConstants.secondaryEmail,
                      });
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Text(
                      S .of(context).contact_us,
                      // "Contact Us",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                    SizedBox(width: 5.0,),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              Divider(),
              SizedBox(height: 5.0,),
            ],
          ),
        )
    );
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
          onPressed: () async{
            //Navigator.of(context).pop();
           // GoRouter.of(context).pop();
           // context.go('/');
            Navigation(context, navigatore: NavigatoreTyp.homenav);
            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
           // return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(
          S .of(context).about,
        // 'About',
        style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor,fontWeight: FontWeight.normal),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                  IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor,
               /*   ColorCodes.accentColor,
                  ColorCodes.primaryColor*/
                ]
            )
        ),
      ),
    );
  }
}
