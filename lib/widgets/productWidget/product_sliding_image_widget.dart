import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:bachat_mart/assets/images.dart';
import 'package:bachat_mart/data/calculations.dart';
import 'package:bachat_mart/models/newmodle/product_data.dart';
import 'package:provider/provider.dart';

import '../badge_ofstock.dart';

class SlidingImage extends StatelessWidget {
  final Function() ontap;
  final ItemData productdata;
  final String varid;
  const SlidingImage({Key? key,required this.ontap,required this.productdata,required this.varid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).stock!<=0
        ? Consumer<CartCalculations>(
      builder: (_, cart, ch) => BadgeOfStock(
        child: ch!,
        value: "10",
        singleproduct: true,
      ),
      child: GestureDetector(
        onTap: () {
      ontap();
        },
        child: GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 173,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator:
          Theme.of(context).accentColor,
          autoPlayInterval: Duration(seconds: 8),
          items: <Widget>[
            if(productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.isNotEmpty)
           ... productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.map((e) =>  Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: e.image,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        /*],
                                            )*/
                      )),
                );
              },
            )).toList()
            else
            GestureDetector(
              onTap: () {

              },
              child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                      horizontal: 5.0,vertical: 10),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(
                            5.0)),
                    child:
                    CachedNetworkImage(
                        imageUrl:productdata.itemFeaturedImage,
                        placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                        errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                        fit: BoxFit.fill),
                    /*],
                                            )*/
                  )),
            )
          ],
        ),
      ),
    )
        : GestureDetector(
      onTap: () {
        ontap();
      },
      child: GFCarousel(
        autoPlay: true,
        viewportFraction: 1.0,
        height: 180,
        pagination: true,
        passiveIndicator: Colors.white,
        activeIndicator:
        Theme.of(context).accentColor,
        autoPlayInterval: Duration(seconds: 8),
        items: <Widget>[
          // if(productdata.priceVariation!.length<0)
          //
          //   else
          if(productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.isNotEmpty)
          ... productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.map((e) =>  GestureDetector(
            onTap: () {

            },
            child: Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(
                    horizontal: 5.0,vertical: 10),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(
                          5.0)),
                  child:
                  CachedNetworkImage(
                      imageUrl: e.image,
                      placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                      errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                      fit: BoxFit.fill),
                  /*],
                                            )*/
                )),
          )).toList()
else
            GestureDetector(
              onTap: () {

              },
              child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                      horizontal: 5.0,vertical: 10),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(
                            5.0)),
                    child:
                    CachedNetworkImage(
                        imageUrl:productdata.itemFeaturedImage,
                        placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                        errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                        fit: BoxFit.fill),
                    /*],
                                            )*/
                  )),
            )
        ],
      ),
    );
  }
}
