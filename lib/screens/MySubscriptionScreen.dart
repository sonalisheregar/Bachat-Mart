import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:bachat_mart/rought_genrator.dart';
import '../generated/l10n.dart';
import '../widgets/simmers/order_screen_shimmer.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';

import '../constants/IConstants.dart';
import '../providers/myorderitems.dart';
import '../screens/home_screen.dart';

import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';

import '../widgets/header.dart';
import '../widgets/mysubscription_display.dart';
import 'package:provider/provider.dart';


class MySubscriptionScreen extends StatefulWidget {
  static const routeName = '/mysubscription-screen';
  @override
  _MySubscriptionScreenState createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> with Navigations{

  var totalamount;
  var totlamount;
  var _isLoading = true;
  var _checkorders = false;
  var _isWeb= false;


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
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
      Provider.of<MyorderList>(context, listen: false).GetSubscriptionorders().then((_) async {
       debugPrint("GetSubscriptionorders...");
        setState(() {
          debugPrint("GetSubscriptionorders.. loading....");
          _isLoading = false;
        });
      });
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        backgroundColor: ColorCodes.whiteColor,
        elevation: (IConstants.isEnterprise)?0:1,

        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),onPressed: () {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
           /* Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);*/
            Navigation(context, navigatore: NavigatoreTyp.Pop);
          });
        } ),
        title: Text(S .of(context).my_subscription,//'My Subscription',
          style: TextStyle(color: IConstants.isEnterprise?ColorCodes.menuColor:ColorCodes.blackColor),
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    IConstants.isEnterprise?ColorCodes.accentColor:ColorCodes.whiteColor,
                    IConstants.isEnterprise?ColorCodes.primaryColor:ColorCodes.whiteColor
                  /*  ColorCodes.accentColor,
                    ColorCodes.primaryColor*/
                  ]
              )
          ),
        ),
      );
    }

    return  WillPopScope(
      onWillPop: () { // this is the block you need
        Navigation(context, navigatore: NavigatoreTyp.Pop);
        return Future.value(false);

      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
            //.of(context)
           // .backgroundColor,
        body:  Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            _body(),
          ],
        ),
        //),
      ),
    );

  }
  _body(){
    final mysubscriptionData = Provider.of<MyorderList>(context, listen: false);
    debugPrint("mysubscriptionData...."+ mysubscriptionData.itemssub.length.toString());
    if (mysubscriptionData.itemssub.length <= 0) {
      _checkorders = false;
    } else {
      _checkorders = true;
    }

    return _checkorders
        ? Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (mysubscriptionData.itemssub.length>0)
              _isLoading
                  ?  Center(
                child: OrderScreenShimmer(),
              )
                  :Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.white,
                  //  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                  padding: EdgeInsets.only(left:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?18 : 0.0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context)) ? 18 : 0.0),
                  child: SizedBox(
                    child: ListView.separated(
                        separatorBuilder: (context, index) =>  Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: DottedLine(
                              dashColor: ColorCodes.lightgrey,
                              lineThickness: 1.0,
                              dashLength: 2.0,
                              dashRadius: 0.0,
                              dashGapLength: 1.0),
                        ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mysubscriptionData.itemssub.length,
                      itemBuilder: (_, i)
                      {
                        debugPrint("variation name..."+mysubscriptionData.itemssub[i].variation_name.toString());
                                         return Column(
                                            children: [
                                              MysubscriptionDisply(
                                                  mysubscriptionData
                                                      .itemssub[i].subid!,
                                                  mysubscriptionData
                                                      .itemssub[i].userid!,
                                                  mysubscriptionData
                                                      .itemssub[i].varid!,
                                                  mysubscriptionData
                                                      .itemssub[i].createdtime!,
                                                  mysubscriptionData
                                                      .itemssub[i].quantity!,
                                                  mysubscriptionData
                                                      .itemssub[i].delivery!,
                                                  mysubscriptionData
                                                      .itemssub[i].startdate!,
                                                  mysubscriptionData
                                                      .itemssub[i].enddate!,
                                                  mysubscriptionData
                                                      .itemssub[i].addres!,
                                                  mysubscriptionData
                                                      .itemssub[i].addressid!,
                                                  mysubscriptionData
                                                      .itemssub[i].addresstype!,
                                                  mysubscriptionData
                                                      .itemssub[i].amount!,
                                                  mysubscriptionData
                                                      .itemssub[i].branch!,
                                                  mysubscriptionData
                                                      .itemssub[i].slot!,
                                                  mysubscriptionData
                                                      .itemssub[i].paymenttype!,
                                                  mysubscriptionData
                                                      .itemssub[i].crontime!,
                                                  mysubscriptionData
                                                      .itemssub[i].status!,
                                                  mysubscriptionData
                                                      .itemssub[i].channel!,
                                                  mysubscriptionData
                                                      .itemssub[i].type!,
                                                  mysubscriptionData
                                                      .itemssub[i].name!,
                                                  mysubscriptionData
                                                      .itemssub[i].image!,
                                                  mysubscriptionData.itemssub[i]
                                                      .variation_name!),

                                            ],
                                          );
                                        }),
                  ),
                ),
              ),
            SizedBox(
              height: 40.0,
            ),
            if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: ColorCodes.whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isLoading
                  ? Center(
                child: OrderScreenShimmer(),
              )
                  :
              EmptyOrder(),
              if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ),
        ),

      ),
    );

  }

  Widget EmptyOrder() {
    return Container(
      color: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?Colors.white:null,
        height:MediaQuery.of(context).size.height/1.5,
      child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Image.asset(Images.myorderImg),
            Text(S .of(context).no_active_subscription_yet,//"No active subscription yet",
              style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 10.0,),
            Text(S .of(context).start_subscription_doorstep,//"Start a subscription now to get grocery deliveries to your doorstep.",
              maxLines:2 ,style: TextStyle(fontSize: 12,color: Colors.grey),),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              },
              child: Container(
                width: 120.0,
                height: 40.0,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                    border: Border(
                      top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                      right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                    )),
                child: Center(
                    child: Text(S .of(context).start_subscription,//'Start Subscription',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
              ),
            ),
          ],
        ),
    );

  }
}
