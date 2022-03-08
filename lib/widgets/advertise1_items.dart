import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:bachat_mart/models/newmodle/home_page_modle.dart';
import 'package:bachat_mart/utils/prefUtils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/categoryitems.dart';
import '../rought_genrator.dart';
import '../screens/items_screen.dart';
import '../screens/subcategory_screen.dart';
import '../screens/not_brand_screen.dart';
import '../screens/banner_product_screen.dart';
import '../screens/pages_screen.dart';
import '../assets/images.dart';

class Advertise1Items extends StatelessWidget with Navigations{
  BannerDetails allbanners;
  final String _isvertical;

  Advertise1Items(this.allbanners, this._isvertical);


  @override
  Widget build(BuildContext context) {
    Widget _mainbannerShimmer() {
      return /*_isWeb ?
      SizedBox.shrink()
          :*/
      Shimmer.fromColors(
          baseColor: /*ColorCodes.baseColor*/Colors.grey[200]!,
          highlightColor: ColorCodes.lightGreyWebColor,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                height: 80.0,
                width: MediaQuery.of(context).size.width - 20.0,
                color: Colors.white,
              ),
            ],
          ));
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async{
          if (allbanners.bannerFor == "1") {
            // Specific product
            /*Navigator.of(context)
                .pushNamed(SingleproductScreen.routeName, arguments: {
              "itemid": bannerData,
            });*/
           /* Navigator.of(context).pushNamed(
                BannerProductScreen.routeName,
                arguments: {
                  "id" : allbanners.data,
                  'type': "product"
                }
            );*/
            Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                qparms: {
                  "id" : allbanners.data,
                  'type': "product"
                });
          }
          else if (allbanners.bannerFor == "2") {
            //Category
            // await Provider.of<CategoriesItemsList>(context,listen: false).fetchCategory();
            final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
            String cattitle = "";
            for (int j = 0; j < categoriesData.items.length; j++) {
              if (allbanners.data == categoriesData.items[j].catid) {
                cattitle = categoriesData.items[j].title!;
              }
            }
           /* Navigator.of(context)
                .pushNamed(SubcategoryScreen.routeName, arguments: {
              'catId': allbanners.data,
              'catTitle': cattitle,
            });*/
            String subTitle = "";
            /*Navigator.of(context).pushNamed(ItemsScreen.routeName,
                arguments: {
                  'maincategory' : subTitle.toString(),
                  'catId' : allbanners.data,
                  'catTitle': subTitle.toString(),
                  'subcatId' : allbanners.data,
                  'indexvalue' : "0",
                  'prev' : "advertise"
                });*/
            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                parms: {
                  'maincategory' : subTitle.toString(),
                  'catId' : allbanners.data!,
                  'catTitle': subTitle.toString(),
                  'subcatId' : allbanners.data!,
                  'indexvalue' : "0",
                  'prev' : "advertise"
                });
          }
          else if (allbanners.bannerFor == "3") {
            String maincategory = "";
            String catid = "";
            String subTitle = "";
            String index = "";

            /*for(int j = 0; j < categoriesData.itemssubcat.length; j++) {
              if(bannerData == categoriesData.itemssubcat[j].subcatid) {
                catid = categoriesData.itemssubcat[j].catid;
                subTitle = categoriesData.itemssubcat[j].title;
                for(int k = 0; k < categoriesData.items.length; k++) {
                  if(categoriesData.itemssubcat[j].catid == categoriesData.items[k].catid) {
                    maincategory = categoriesData.items[k].title;
                  }
                }
              }
            }

            final subcategoryData = Provider.of<CategoriesItemsList>(
              context,
              listen: false,
            ).findById(catid);
            for(int j = 0; j < subcategoryData.length; j++){
              if(bannerData == subcategoryData[j].subcatid) {
                index = j.toString();
              }
            }*/

            /*Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
              'maincategory': maincategory,
              'catId': catid,
              'catTitle': subTitle,
              'subcatId': allbanners.data,
              'indexvalue': index,
              'prev': "advertise"
              *//*'maincategory' : subTitle,
                  'catId' : "",
                  'catTitle': subTitle,
                  'subcatId' : bannerData,
                  'indexvalue' : "0",*//*
            });*/

            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                parms: {
                  'maincategory': maincategory,
                  'catId': catid,
                  'catTitle': subTitle,
                  'subcatId': allbanners.data.toString(),
                  'indexvalue': index,
                  'prev': "advertise"
                });
          }
          else if(allbanners.bannerFor == "5") {
            //brands
            Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.notifyProduct,qparms:
            {
              'brandsId' : allbanners.data,
              'fromScreen' : "Banner",
              'notificationId' : "",
              'notificationStatus': ""
            });
            // Navigator.of(context).pushNamed(NotBrandScreen.routeName,
            //     arguments: {
            //       'brandsId' : allbanners.data,
            //       'fromScreen' : "Banner",
            //       'notificationId' : "",
            //       'notificationStatus': ""
            //     }
            // );
          }
          else if(allbanners.bannerFor == "4") {
            //Subcategory and nested category
           /* Navigator.of(context).pushNamed(BannerProductScreen.routeName,
                arguments: {
                  'id' : allbanners.data,
                  'type': "category"
                }
            );*/
            Navigation(context, name:Routename.BannerProduct,navigatore: NavigatoreTyp.Push,
                qparms: {
                  'id' : allbanners.data,
                  'type': "category"
                });
          }
          else if(allbanners.bannerFor == "6") {
            //custom link
            String url = allbanners.click_link!;
            if (canLaunch(url) != null)
              launch(url);
            else
              // can't launch url, there is some error
              throw "Could not launch $url";
          }
          else if(allbanners.bannerFor == "7") {
            //Pages
         /*   Navigator.of(context).pushNamed(PagesScreen.routeName,
                arguments: {
                  'id' : allbanners.id,
                }
            );*/
            Navigation(context, name:Routename.Pages,navigatore: NavigatoreTyp.Push,
                parms:{  'id' : allbanners.id.toString()});
          }else if(allbanners.bannerFor == "17"){
            if(!Vx.isWeb) {
              PrefUtils.prefs!.containsKey("apikey") ?
              Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
              Navigation(context, name: Routename.Refer, navigatore: NavigatoreTyp.Push);
            }
          }else if(allbanners.bannerFor == "18"){
            PrefUtils.prefs!.containsKey("apikey") ?
            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
            Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
          }
        },
        child: Container(
          margin: _isvertical == "horizontal" ?
          EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0,top:5.0) :
          _isvertical =="home"?EdgeInsets.zero:
          EdgeInsets.only(left: 10.0, bottom: 5.0,top:5.0),
          child: (_isvertical == "top") ?
           CachedNetworkImage(
             imageUrl: allbanners.bannerImage, fit: BoxFit.fill,
           // height: 350,
            width: MediaQuery.of(context).size.width * 0.5,
             //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
             errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
           )
              :
          (_isvertical == "bottom") ?
          CachedNetworkImage(
            imageUrl: allbanners.bannerImage, fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width * 0.46,
            //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg, fit: BoxFit.fill,),
          )
              :_isvertical =="home"?
          CachedNetworkImage(
            imageUrl: allbanners.bannerImage,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height*0.28,
           placeholder: (context, url) => /*Image.asset(Images.defaultSliderImg)*/_mainbannerShimmer(),
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
          ):
          CachedNetworkImage(
            imageUrl: allbanners.bannerImage,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            //placeholder: (context, url) => Image.asset(Images.defaultSliderImg),
            errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
          ),
        ),
      ),
    );
  }
}
