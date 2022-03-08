import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:bachat_mart/assets/images.dart';
import 'package:bachat_mart/constants/IConstants.dart';
import 'package:bachat_mart/constants/features.dart';
import 'package:bachat_mart/generated/l10n.dart';
import 'package:bachat_mart/models/newmodle/product_data.dart';
import 'package:bachat_mart/providers/branditems.dart';
import 'package:bachat_mart/utils/ResponsiveLayout.dart';
import 'package:bachat_mart/utils/prefUtils.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemDetailsWidget extends StatefulWidget {
  ItemData itmdata;
  final Function() ontap;

  ItemDetailsWidget({Key? key,required this.itmdata,required this.ontap});

  @override
  State<ItemDetailsWidget> createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget>  with TickerProviderStateMixin{
  TabController? _tabController;
  bool _isExpandeddescription = false;
  bool _isExpandedmanufacture = false;
  late List<Tab> tabList = [];
  bool visible= false;
  bool visiblestand= true;
  bool visibleexpress= false;
  var dividerSlot = ColorCodes.blackColor;
  var dividerExpress = ColorCodes.whiteColor;
  var textSlot = ColorCodes.lightBlack;
  var textExpress = ColorCodes.grey;
  var ContainerSlot = ColorCodes.whiteColor;
  var ContainerExpress = ColorCodes.whiteColor;

  var selectedTimeSlot = ColorCodes.whiteColor;
  int _groupValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.itmdata.item_description!=null&&widget.itmdata.item_description!.isNotEmpty)
      tabList.add(new Tab(
        text: 'Description',
      ));
    if (widget.itmdata.manufacturer_description!=null&&widget.itmdata.manufacturer_description!.length>0)
      tabList.add(new Tab(
        text: 'Manufacturer Details',
      ));
    _tabController = new TabController(
      vsync: this,
      length: tabList.length,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   ((widget.itmdata.item_description!=null&&widget.itmdata.item_description!.length>0) || (widget.itmdata.manufacturer_description!=null&&widget.itmdata.manufacturer_description!.length>0))?
    Padding(
      padding:  EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?30:10,right:10,top:10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width:Vx.isWeb?MediaQuery.of(context).size.width*0.97:MediaQuery.of(context).size.width*0.95,
          //  padding: EdgeInsets.only(right:2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          visiblestand = true;
                          visibleexpress = false;
                          dividerSlot = ColorCodes.blackColor;
                          dividerExpress = ColorCodes.whiteColor;
                          ContainerSlot = ColorCodes.whiteColor;
                          ContainerExpress = ColorCodes.whiteColor;
                          textSlot = ColorCodes.lightBlack;
                          textExpress = ColorCodes.grey;
                          _groupValue = 1;
                        });

                      },
                      child: Container(
                        height: 50,
                        width: 160,
                        decoration: BoxDecoration(
                            color: ContainerSlot,
                            border: Border(
                              bottom: BorderSide(width: 1.0, color: dividerSlot),
                            )),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(S .of(context).description,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textSlot),
                            ),

                          ],
                        ),
                      ),
                    ),
                    //Spacer(),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          visibleexpress = true;
                          visiblestand = false;
                          dividerSlot = ColorCodes.whiteColor;
                          dividerExpress = ColorCodes.blackColor;
                          ContainerSlot = ColorCodes.whiteColor;
                          ContainerExpress = ColorCodes.whiteColor;
                          textSlot = ColorCodes.grey;
                          textExpress = ColorCodes.lightBlack;
                          _groupValue = 2;
                        });

                      },
                      child: Container(
                        height: 50,
                        width: 160,
                        decoration: BoxDecoration(
                            color: ContainerExpress,
                            border: Border(
                              bottom: BorderSide(width: 1.0, color: dividerExpress),
                            )),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(S .of(context).manufacture_details,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textExpress),
                            ),


                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                      if(Features.isShoppingList)
                        (PrefUtils.prefs!.containsKey("apikey"))?
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.ontap();
                                    /*final shoplistData = Provider.of<BrandItemsList>(context, listen: false);

                          if (shoplistData.itemsshoplist.length <= 0) {
                            _dialogforCreatelistTwo(context, shoplistData);
                          } else {
                            _dialogforShoppinglistTwo(context);
                          }*/
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          Images.addToListImg,width: 25,height: 25,color: ColorCodes.mediumBlackColor),
                                      SizedBox(width: 5),
                                      Text(S .current.add_to_list, style: TextStyle(
                                          fontSize: 16, color: ColorCodes.mediumBlackColor,
                                          fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                              if(Features.isShare)
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    if (Platform.isIOS) {
                                      Share.share(S .current.download_app +
                                          IConstants.APP_NAME +
                                          '${S .current.from_app_store} https://apps.apple.com/us/app/id' + IConstants.appleId);
                                    } else {
                                      Share.share(S .current.download_app +
                                          IConstants.APP_NAME +
                                          '${S .current.from_google_play_store}https://play.google.com/store/apps/details?id=' + IConstants.androidId);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Icon(Icons.share, color: Colors.grey, size: 26),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(
                                        S .current.share,
                                        style: TextStyle(
                                            fontSize: 20, color: ColorCodes.mediumBlackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //Spacer(),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ):
                        SizedBox.shrink(),

                  ],
                ),
                SizedBox(width: 20,),
                Visibility(
                  visible: visiblestand,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    color: ColorCodes.whiteColor,
                    //padding: EdgeInsets.only(left: 20,right: 20),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Text( widget.itmdata.item_description!,
                              maxLines: _isExpandeddescription ? widget.itmdata.item_description!.length : 2,textAlign: TextAlign.start),
                        ),
                        InkWell(
                          onTap: (){ setState(() {
                            _isExpandeddescription = !_isExpandeddescription;
                          }); },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _isExpandeddescription ? Text("Show Less",style: TextStyle(color: Colors.blue),) :  Text("Show More",style: TextStyle(color: Colors.blue))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: visibleexpress,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    color: ColorCodes.whiteColor,
                    //padding: EdgeInsets.only(left: 20,right: 20),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Text( widget.itmdata.manufacturer_description!,
                              maxLines: _isExpandedmanufacture ? widget.itmdata.manufacturer_description!.length : 2,textAlign: TextAlign.start),
                        ),
                        InkWell(
                          onTap: (){ setState(() {
                            _isExpandedmanufacture = !_isExpandedmanufacture;
                          }); },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _isExpandedmanufacture ? Text("Show Less",style: TextStyle(color: Colors.blue),) :  Text("Show More",style: TextStyle(color: Colors.blue))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                //SizedBox(height: 20,),
              ],
            ),
          ),
          /*new Container(
              width:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?500:MediaQuery.of(context).size.width,
              child: new TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  indicatorSize:
                  TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(right: 30,left: 0),
                  tabs: tabList),
            ),*/

        ],
      ),
    ):SizedBox.shrink();
  }


}


