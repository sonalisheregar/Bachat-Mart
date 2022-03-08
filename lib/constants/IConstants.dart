import 'package:flutter/foundation.dart';

class IConstants {
  static String BaseDomain = "https://manage.grocbay.com" /*"https://login.grocbay.com"*/;
   static String API_PATH = "$BaseDomain/api/app-manager/get-functionality/";
    static String API_IMAGE = "$BaseDomain/uploads/";
  static String AppDomain = "https://web.grocbay.com";


  /* static String API_PATH = "https://login.grocbay.com/api/app-manager/get-functionality/";
   static String API_IMAGE = "https://login.grocbay.com/uploads/";*/
  // static String API_PATH = "https://franchise.tokree.co.in/api/app-manager/get-functionality/";
  // static String API_IMAGE = "https://franchise.tokree.co.in/uploads/";


  static String APP_NAME = "Bachat Mart";
  static String API_PAYTM = "https://cashfree.grocbay.com/";

  static String androidId = ""/* = com.bachatmart.store"*/;
  static String appleId = ""/* = "1512751692"*/;
  static bool isEnterprise = true;
  static String websiteId = ""/*"7ada1ff4-e065-4e54-bb26-193defda73e2"*/;
  static String googleApiKey = ""/*"AIzaSyCe6evdOqGIOUMugiFHNEYq20ztqcNSZrc"*/;

  //social media links

  static String facebookUrl = "";
  static String instagramUrl = "";
  static String youtubeUrl = "";
  static String twitterUrl = "";

  static const paytm_mid = 'eJMBBa49929394152335';
  static var paytm_key = "JaSol8L6wh%26dOLYt";
   ///Used For Paytm
   static var currency = 'INR';
   // static var paymentisstagin = true;
   static String paymentGateway = "";
   static String webViewUrl = "";
   static String gatewayId = "";
   static String gateway_secret = "";
   static bool isPaymentTesting = false;
   static String languageId = "";
   static String countryCode = "";
   static String currencyFormat = "";
   static String minimumOrderAmount = "";
   static String maximumOrderAmount = "";
   static String restaurantName = "";
   static String returnsPolicy = "";
   static String refundPolicy = "";
   static String walletPolicy = "";
   static String numberFormat = "";
   static String primaryMobile = "";
   static String secondaryMobile = "";
   static String primaryEmail = "";
   static String secondaryEmail = "";
   static String restaurantTerms = "";
   static String categoryOneLabel = "";
   static String categoryTwoLabel = "";
   static String categoryThreeLabel = "";
   static String categoryOne = "";
   static String categoryTwo = "";
   static String categoryThree = "";
///CAsh Free
   static String CASHFREEAPPID = "13879338c54954b7326ec033ac397831";
   static var CASHFREEKEY='f1a96d83d497e42bf64c47cc23d99080eadda307';

   static String holyday = "";
   static String holydayNote = "";

   static int decimaldigit = 2;

   //location change
   static final deliverylocationmain = ValueNotifier<String>("");
   static final currentdeliverylocation = ValueNotifier<String>("");

}
