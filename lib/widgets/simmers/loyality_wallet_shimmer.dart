import 'package:flutter/material.dart';
import 'package:bachat_mart/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';

class LoyalityorWalletShimmer extends StatelessWidget {
  const LoyalityorWalletShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.baseColor,
      highlightColor: ColorCodes.lightGreyWebColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
          new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(0.0),
            itemCount: 6,
            itemBuilder: (_, i) => Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Shimmer.fromColors(
                  baseColor: ColorCodes.baseColor,
                  highlightColor: ColorCodes.lightGreyWebColor,
                  child: Container(
                    height: 90.0,
                    color: Theme.of(context).buttonColor,
                  ),
                )),
          ),
        ],

      ),
    );
  }
}
