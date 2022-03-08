import 'dart:convert';

import 'package:bachat_mart/models/payment/cashfree_web.dart';

import  'paytmabstactsdk.dart' if (dart.library.html) 'dart:js' as js ;

class CashFreeWeb{
  static doPayment(orderToken, {required Function(CashFreeWebModle) OnSucsess, OnFailure}) async{
    print("otcken: $orderToken");
    js.context.callMethod('startCashfreePayments', [ orderToken,]);
    js.context['onResultSuccess'] = (String parameter) async{
      print("response=> $parameter");
      OnSucsess(CashFreeWebModle.fromJson(json.decode(parameter)));
      // OnSucsess(json.decode(parameter) as Map<dynamic, dynamic>);
    };
    js.context['onResultFailure'] = (String parameter) async{
      print("response=> $parameter");
      OnSucsess(CashFreeWebModle.fromJson(json.decode(parameter)));
      // OnSucsess(json.decode(parameter) as Map<dynamic, dynamic>);
    };
  }
}