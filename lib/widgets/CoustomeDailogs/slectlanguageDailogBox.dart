import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../assets/ColorCodes.dart';
import '../../controller/mutations/languagemutations.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../generated/l10n.dart';

class LanguageselectDailog extends StatelessWidget {
  BuildContext dailogcontext;

   LanguageselectDailog(this.dailogcontext, {Key? key}) : super(key: key);
  GroceStore store = VxState.store;
  @override
  Widget build(BuildContext context) {
    return VxBuilder(
      mutations:{SetLanguage},
      builder: (BuildContext, dynamic,VxStatus){
        return VStack([
          S .current.chose_your_preferred_language.text.bold.size(20).make().p20().centered(),
          ...store.language.languages.map((e) => HStack([e.localName!.text.bold.size(16).color(e.code==store.language.language.code?ColorCodes.primaryColor:ColorCodes.blackColor).make().p12(),
            Icon(Icons.check,
                color: e.code==store.language.language.code? Theme.of(context).primaryColor: ColorCodes.whiteColor,
                size: 24),

          ],alignment: MainAxisAlignment.spaceBetween,).box.color(e.code==store.language.language.code?ColorCodes.lightColor:ColorCodes.whiteColor).make().px4().onTap(() {
            SetLanguage(code: e.code!);
            Navigator.pop(dailogcontext);
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          })).toList()
        ],crossAlignment: CrossAxisAlignment.stretch,).scrollVertical().box.height(270).width(335).make().card.p16.make().centered();
      },
    );
  }
}
