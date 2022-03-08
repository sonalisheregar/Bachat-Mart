import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/screens/MultipleImagePicker_screen.dart';
import 'package:bachat_mart/screens/MySubscriptionScreen.dart';
import 'package:bachat_mart/screens/Payment_SubscriptionScreen.dart';
import 'package:bachat_mart/screens/View_Subscription_Details.dart';
import 'package:bachat_mart/screens/address_screen.dart';
import 'package:bachat_mart/screens/addressbook_screen.dart';
import 'package:bachat_mart/screens/banner_product_screen.dart';
import 'package:bachat_mart/screens/confirmorder_screen.dart';
import 'package:bachat_mart/screens/customer_support_screen.dart';
import 'package:bachat_mart/screens/edit_screen.dart';
import 'package:bachat_mart/screens/help_screen.dart';
import 'package:bachat_mart/screens/home_screen.dart';
import 'package:bachat_mart/screens/introduction_screen.dart';
import 'package:bachat_mart/screens/myorder_screen.dart';
import 'package:bachat_mart/screens/not_subcategory_screen.dart';
import 'package:bachat_mart/screens/offer_screen.dart';
import 'package:bachat_mart/screens/orderconfirmation_screen.dart';
import 'package:bachat_mart/screens/pages_screen.dart';
import 'package:bachat_mart/screens/payment_screen.dart';
import 'package:bachat_mart/screens/pickup_screen.dart';
import 'package:bachat_mart/screens/policy_screen.dart';
import 'package:bachat_mart/screens/searchitem_screen.dart';
import 'package:bachat_mart/screens/sellingitem_screen.dart';
import 'package:bachat_mart/screens/items_screen.dart';
import 'package:bachat_mart/screens/signup_screen.dart';
import 'package:bachat_mart/screens/login_screen.dart';
import 'package:bachat_mart/screens/orderhistory_screen.dart';
import 'package:bachat_mart/screens/rate_order_screen.dart';
import 'package:bachat_mart/screens/refer_screen.dart';
import 'package:bachat_mart/screens/refund_screen.dart';
import 'package:bachat_mart/screens/return_screen.dart';
import 'package:bachat_mart/screens/splash_screen.dart';
import 'package:bachat_mart/screens/subcategory_screen.dart';
import 'package:bachat_mart/screens/subscribe_screen.dart';
import 'package:bachat_mart/screens/subscription_confirm_screen.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/home_screen.dart';
import '../../screens/items_screen.dart';
import '../../screens/membership_screen.dart';
import '../../screens/shoppinglistitems_screen.dart';
import '../../screens/signup_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uuid/uuid.dart';
import 'controller/mutations/address_mutation.dart';
import 'controller/mutations/cart_mutation.dart';
import 'controller/mutations/home_screen_mutation.dart';
import 'providers/branditems.dart';
import 'repository/authenticate/AuthRepo.dart';
import 'screens/about_screen.dart';
import 'screens/brands_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/category_screen.dart';
import 'screens/map_screen.dart';
import 'screens/not_brand_screen.dart';
import 'screens/not_product_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/otpconfirm_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/shoppinglist_screen.dart';
import 'screens/signup_selection_screen.dart';
import 'screens/singleproduct_screen1.dart';
import 'screens/wallet_screen.dart';
import 'utils/prefUtils.dart';
import 'package:go_router/go_router.dart';

enum Routename{

  Home,Wallet,Loyalty,Category,Shoppinglist,SignUpScreen,OtpConfirm,AboutUs,Privacy,Cart,SingleProduct,Membership,MyOrders,CustomerSupport,Policy,SellingItem,Help,
  Introduction,ItemScreen,SignUp,ShoppinglistItem,MapScreen,Login,MyOrder,OrderHistory,Rateorder,Refer,Refund,Return,AddressBook,MultipleImagePicker,EditScreen,ConfirmOrder,BrandsScreen
  ,PickupScreen,MySubscription,AddressScreen,PaymentScreen,OrderConfirmation,SubscribeScreen,PaymenSubscription,SubscriptionConfirm,notifyProduct,ViewSubscriptionDetails,OfferScreen,notifybrand,notify,search,
  BannerProduct,NotSubcategory,Pages,SubcategoryScreen,Splash
}

enum NavigatoreTyp{
  Push,Pop,PushReplacment,PopUntill,homenav
}


class PageControler extends Navigations  {
  PageControler(){
    PrefUtils.prefs!.setBool("restor", false);
    print("resorent fetch...");
    initialRoute((){
      print("Intilaizes Sucses");
      // RouteInformations.onloaddata();
    });
  }

  get routs =>[
    GoRoute(path: '/',builder: (context,state){
      return Container();
    }),
    GoRoute(path: "/store",builder: (context,state){
  // print("Intilaizes ${state.params["branch"]}");
  return Container();
  },routes: [
      GoRoute(
        path: nUri(Routename.Home).path,
        builder: (context, state) {
          return HomeScreen(key: state.pageKey);},
      ),
      GoRoute(path: nUri(Routename.Splash).path, builder: (context, state) =>SplashScreenPage(),),
      GoRoute(name: nUri(Routename.Loyalty).name,path: nUri(Routename.Loyalty).path, builder: (context, state) =>WalletScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.Wallet).name,path: nUri(Routename.Wallet).path, builder: (context, state) =>WalletScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.Cart).name,path: nUri(Routename.Cart).path, builder: (context, state) =>CartScreen(/*state.params*/state.queryParams),),
      GoRoute(name: nUri(Routename.SignUpScreen).name,path: nUri(Routename.SignUpScreen).path, builder: (context, state) =>SignupSelectionScreen(),),
      GoRoute(name: nUri(Routename.OtpConfirm).name,path: nUri(Routename.OtpConfirm).path, builder: (context, state) =>OtpconfirmScreen(state.queryParams),), //todo
      GoRoute(name: nUri(Routename.SignUp).name,path: nUri(Routename.SignUp).path, builder: (context, state) =>SignupScreen(),), //todo
      GoRoute(name: nUri(Routename.AboutUs).name, path: nUri(Routename.AboutUs).path, builder: (context, state) =>   AboutScreen()),
      GoRoute(name: nUri(Routename.Privacy).name, path: nUri(Routename.Privacy).path, builder: (context, state) =>   PrivacyScreen()),
      GoRoute(name: nUri(Routename.Shoppinglist).name,path: nUri(Routename.Shoppinglist).path, builder: (context, state) =>ShoppinglistScreen(),),
      // GoRoute(name: nUri(Routename.Category),path: nUri(Routename.Category), builder: (context, state) =>CategoryScreen(),),
      GoRoute(name: nUri(Routename.Category).name,path: nUri(Routename.Category).path, builder: (context, state) =>CategoryScreen(),),
      GoRoute(name: nUri(Routename.Introduction).name,path: nUri(Routename.Introduction).path, builder: (context, state) =>introductionscreen(),),
      GoRoute(name: nUri(Routename.ItemScreen).name,path: nUri(Routename.ItemScreen).path, builder: (context, state) =>ItemsScreen(state.queryParams),),
      // GoRoute(name: nUri(Routename.ItemScreen).name,path: "${nUri(Routename.ItemScreen).path}/:catId/:subcatId", builder: (context, state) =>ItemsScreen(state.params),),
      // GoRoute(path: '/splash', pageBuilder: (context, state) =>  MaterialPage(child: Scaffold(body: Center(child:  Text("Loading...\n ${state.path}\n ${state.fullpath} \n ${state.location} end"),),)),),
      GoRoute(name: nUri(Routename.ShoppinglistItem).name,path: nUri(Routename.ShoppinglistItem).path+"/:id/:name", builder: (context, state) =>ShoppinglistitemsScreen(state.params),),
      GoRoute(name: nUri(Routename.Membership).name,path: "${nUri(Routename.Membership).path}", builder: (context, state) =>MembershipScreen(),),
      GoRoute(path: "share", builder: (context, state)  =>  SingleproductScreen(state.queryParams["id"]!),),
      GoRoute(path: "refer", builder: (context, state) {
        PrefUtils.prefs!.setString("referCodeDynamic", state.queryParams["id"]!);
        return HomeScreen();
      }),
      GoRoute(name: nUri(Routename.MapScreen).name,path: nUri(Routename.MapScreen).path, builder: (context, state) => MapScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.Login).name,path: nUri(Routename.Login).path, builder: (context, state) => LoginScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.MyOrders).name,path: nUri(Routename.MyOrders).path, builder: (context, state) =>MyorderScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.OrderHistory).name,path: nUri(Routename.OrderHistory).path, builder: (context, state) =>OrderhistoryScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.Refer).name,path: nUri(Routename.Refer).path, builder: (context, state) =>ReferEarn(),),
      GoRoute(name: nUri(Routename.Refund).name,path: "${nUri(Routename.Refund).path}/:orderid/:total", builder: (context, state) =>Refund_screen(state.params),),
      GoRoute(name: nUri(Routename.Rateorder).name,path: "${nUri(Routename.Rateorder).path}/:orderid", builder: (context, state) =>RateOrderScreen(state.params),),
      GoRoute(name: nUri(Routename.Return).name,path: "${nUri(Routename.Return).path}/:orderid/:title", builder: (context, state) =>ReturnScreen(state.params),),
      GoRoute(name: nUri(Routename.SingleProduct).name ,path: nUri(Routename.SingleProduct).path+"/:varid", builder: (context, state)  =>  SingleproductScreen(state.params["varid"]!),),
      GoRoute(name: nUri(Routename.SellingItem).name,path:"${nUri(Routename.SellingItem).path}/:seeallpress", builder: (context, state) =>SellingitemScreen(state.params),),
      GoRoute(name: nUri(Routename.Help).name,path:nUri(Routename.Help).path, builder: (context, state) =>HelpScreen(),),
      GoRoute(name: nUri(Routename.AddressBook).name,path:nUri(Routename.AddressBook).path, builder: (context, state) =>AddressbookScreen(),),
      GoRoute(name: nUri(Routename.MultipleImagePicker).name,path:nUri(Routename.MultipleImagePicker).path, builder: (context, state) =>MultipleImagePicker(),),
      GoRoute(name: nUri(Routename.Policy).name,path:"${nUri(Routename.Policy).path}/:title", builder: (context, state) =>PolicyScreen(state.params),),
      GoRoute(name: nUri(Routename.EditScreen).name,path: nUri(Routename.EditScreen).path,builder: (context, state) => EditScreen()),
      GoRoute(name: nUri(Routename.ConfirmOrder).name,path: "${nUri(Routename.ConfirmOrder).path}/:prev",builder: (context, state)=> ConfirmorderScreen(state.params)),
      GoRoute(name: nUri(Routename.PickupScreen).name,path: nUri(Routename.PickupScreen).path,builder: (context, state)=>PickupScreen()),
      GoRoute(name: nUri(Routename.MySubscription).name,path: nUri(Routename.MySubscription).path,builder: (context, state)=>MySubscriptionScreen()),
      GoRoute(name: nUri(Routename.CustomerSupport).name,path: nUri(Routename.CustomerSupport).path,builder: (context, state)=> CustomerSupportScreen(state.params)),
      GoRoute(name: nUri(Routename.AddressScreen).name,path: nUri(Routename.AddressScreen).path, builder: (context, state) =>AddressScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.PaymentScreen).name,path: nUri(Routename.PaymentScreen).path, builder: (context, state) =>PaymentScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.OrderConfirmation).name,path: "${nUri(Routename.OrderConfirmation).path}/:orderstatus/:orderid",builder: (context, state) =>OrderconfirmationScreen(state.params)),
      GoRoute(name: nUri(Routename.SubscribeScreen).name,path: nUri(Routename.SubscribeScreen).path,builder: (context, state)=>SubscribeScreen(state.queryParams)),
      GoRoute(name: nUri(Routename.PaymenSubscription).name,path: nUri(Routename.PaymenSubscription).path,builder: (context,state)=>PaymenSubscriptionScreen(state.queryParams)),
      GoRoute(name: nUri(Routename.SubscriptionConfirm).name,path: "${nUri(Routename.SubscriptionConfirm).path}/:orderstatus/:sorderId",builder: (context, state) =>SubscriptionConfirmScreen(state.params)),
      GoRoute(name: nUri(Routename.ViewSubscriptionDetails).name,path: nUri(Routename.ViewSubscriptionDetails).path,builder: (context,state)=>ViewSubscriptionDetails(state.queryParams)),
      GoRoute(name: nUri(Routename.OfferScreen).name,path:nUri(Routename.OfferScreen).path,builder: (context, state)=>OfferScreen(state.queryParams)),
      GoRoute(name: nUri(Routename.BrandsScreen).name,path: nUri(Routename.BrandsScreen).path, builder: (context, state) =>BrandsScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.BannerProduct).name,path: nUri(Routename.BannerProduct).path, builder: (context, state) =>BannerProductScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.NotSubcategory).name,path: nUri(Routename.NotSubcategory).path, builder: (context, state) =>NotSubcategoryScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.notifyProduct).name,path: nUri(Routename.notifyProduct).path, builder: (context, state) =>NotProductScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.notifybrand).name,path: nUri(Routename.notifybrand).path, builder: (context, state) =>NotBrandScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.notify).name,path: nUri(Routename.notify).path, builder: (context, state) =>NotificationScreen(),),
      GoRoute(name: nUri(Routename.search).name,path: nUri(Routename.search).path, builder: (context, state) =>SearchitemScreen(state.queryParams),),
      GoRoute(name: nUri(Routename.Pages).name,path: "${nUri(Routename.Pages).path}/:id",builder: (context, state)=> PagesScreen(state.params)),
      GoRoute(name: nUri(Routename.SubcategoryScreen).name,path: "${nUri(Routename.SubcategoryScreen).path}/:catId/:catTitle",builder: (context, state)=>SubcategoryScreen(state.params))
    ])
  ];
}
class CUri{
  String uri;
  CUri(this.uri);
  String get name =>uri;
  String get path => "$uri";
}
abstract class Navigations {
  initialRoute(Function sonload) async{
    // if(!PrefUtils.prefs!.containsKey("branch"))
    if(PrefUtils.prefs!.containsKey("restor")&&!PrefUtils.prefs!.getBool("restor")!)
    BrandItemsList().GetRestaurantNew("acbjadgdj",()async {
      PrimeryLocation().fetchPrimarylocation();
    });

    if((VxState.store as GroceStore).homescreen.toJson().isEmpty){
   if(Vx.isWeb){
     if(PrefUtils.prefs!.getString("ftokenid")==null||PrefUtils.prefs!.getString("ftokenid")=="")
     PrefUtils.prefs!.setString("ftokenid", Uuid().v4());
     } else PrefUtils.prefs!.setString("ftokenid",(await FirebaseMessaging.instance.getToken())!);
   print("initial Loading data");
   auth.getuserProfile(onerror: () {
     print("Guest User");
     cartcontroller.fetch(onload: (onload) {
       if(onload){
         HomeScreenController(branch: PrefUtils.prefs!.getString("branch") ?? "15", user: PrefUtils.prefs!.getString("tokenid")).perform().then((value){
           if(value) sonload();
         });
       }
     });
   }, onsucsess: (value) {
     print("user fetch ${value.branch}");
     cartcontroller.fetch(onload: (onload) {
       if(onload){
         HomeScreenController(branch: value.branch ?? "15", user: value.id).perform().then((value){
           if(value) sonload();
         });
       }
     });
   });
 }else{
      sonload();
    }
  }

  CUri  Function(Routename name) get nUri=>(Routename name){
    switch(name){
      case Routename.Home:return  CUri("home");
      case Routename.Wallet: return CUri("wallet");
      case Routename.AboutUs: return CUri("about");
      case Routename.Privacy: return CUri("privacy");
      case Routename.Cart: return CUri("cart");
      case Routename.Loyalty: return CUri("loyalty");
      case Routename.Category: return CUri("category");
      case Routename.Shoppinglist: return CUri("shopping");
      case Routename.SignUpScreen: return CUri("auth");///Signup selection Screen
      case Routename.OtpConfirm: return CUri("auth/otp/Confirm");
      case Routename.SingleProduct: return CUri("product");
      case Routename.Membership:
        return CUri("membership");
      case Routename.MyOrders:
        return CUri("myorders");
      case Routename.CustomerSupport:
        return CUri('customer/support');
      case Routename.Introduction:
        return CUri('introduction');
      case Routename.ItemScreen:
        return CUri('items');
      case Routename.SignUp:
        return CUri('auth/signup');///signup
      case Routename.Policy:
        return CUri('policy');
      case Routename.SellingItem:
        return CUri('sellingitem');
      case Routename.Help:
        return CUri('help');
      case Routename.AddressBook:
        return CUri('addressbook');
      case Routename.MultipleImagePicker:
        return CUri('multiplepicker');
      case Routename.ShoppinglistItem:
        return CUri('myshopping');///shopping lists
      case Routename.MapScreen:
        return CUri('maps');
      case Routename.Login:
        return CUri('login');
      case Routename.MyOrder:
        return CUri('order');///my order
      case Routename.OrderHistory:
        return CUri('order/history');///order history
      case Routename.Rateorder:
        return CUri('order/rate');///rate order
      case Routename.Refer:
        return CUri('referearn');
      case Routename.Refund:
        return CUri('refund');
      case Routename.Return:
        return CUri('return');
      case Routename.EditScreen: return CUri('edit');
      case Routename.ConfirmOrder:
       return CUri('order/confirm');///confirm order
      case Routename.PickupScreen:
       return CUri('pickup');
      case Routename.MySubscription:
       return CUri('subscription');
      case Routename.AddressScreen:
       return CUri('address');
      case Routename.BrandsScreen: return CUri('brands');
      case Routename.PaymentScreen:
       return CUri('payment');
      case Routename.OrderConfirmation:
       return CUri('order/confirmation');///order confirmation
      case Routename.SubscribeScreen:
       return CUri('subscribe');
      case Routename.PaymenSubscription:
       return CUri('pay/subscription');
      case Routename.SubscriptionConfirm:
        return CUri('subscription/confirm');
      case Routename.ViewSubscriptionDetails:
        return CUri('subscription/view');///view Subscription
      case Routename.OfferScreen:
        return CUri('offers');
      case Routename.BannerProduct:
        return CUri('banner/product');
      case Routename.NotSubcategory:
        return CUri('notify/subcategory');
      case Routename.notifybrand:
        return CUri('notify/banner');
      case Routename.notify:
        return CUri('notify');
      case Routename.search:
        return CUri('search');
      case Routename.Pages:
        return CUri('pages');
      case Routename.notifyProduct:
        return CUri('notify/product');
      case Routename.SubcategoryScreen:
        return CUri('subcategory');
      case Routename.Splash:
        return CUri('splash');
    }
  };


  Navigation(BuildContext context,{Routename? name,required NavigatoreTyp navigatore,Map<String, String>? parms, Map<String, dynamic>? qparms}){
    // parms!=null?parms.addAll({"branch":"${PrefUtils.prefs!.getString("branch")}"}):parms = {"branch":"${PrefUtils.prefs!.getString("branch")}"};
    switch(navigatore){
      case NavigatoreTyp.Push:
        print("params...."+parms.toString());
        if(parms!=null && qparms!=null){
          Map<String,String> qparms1={};
          qparms.forEach((key, value) {
            if(value !=null){
              qparms1.addAll({key:value.toString()});
            }
          });
          print("paramcs...."+parms.toString());

          context.pushNamed(nUri(name!).name,params: parms,queryParams: qparms1);
        }else if(parms!=null){
          print("paraxmcs...."+parms.toString());
          context.pushNamed(nUri(name!).name,params: parms);
        }else if(qparms!=null){
          print("paraxmc]s...."+parms.toString());
          Map<String,String> qparms1={};
          qparms.forEach((key, value) {
            if(value !=null){
              qparms1.addAll({key:value.toString()});
            }
          });
          print("qparms1...."+qparms.toString());
          print("qparms...."+qparms1.toString());
          context.pushNamed(nUri(name!).name/*,params: {"branch":"999"},*/,queryParams: qparms1);
        }else{
          context.pushNamed(nUri(name!).name/*,params: {"branch":"999"}*/);
        }
        /* parms!=null?
        context.goNamed(nUri(name!).name,params: parms):
        context.goNamed(nUri(name!).name);*/
        // context.goNamed(nUri(name).name,queryParams: parms!);
        // context.vxNav.push(Uri(path:  nUri(name!), queryParameters:parms));
        // TODO: Handle this case.
        break;
      case NavigatoreTyp.Pop:
        if(GoRouter.of(context).navigator!.canPop())
        GoRouter.of(context).pop();
        else
          context.go(/*"/${PrefUtils.prefs!.getString("branch")}*/ "/store/"+nUri(Routename.Home).path);
        // context.vxNav.pop();
        // TODO: Handle this case.
        break;
      case NavigatoreTyp.PushReplacment:
        // GoRouter.of(context).pop();
        parms!=null?
        context.goNamed(nUri(name!).name,params: parms):
        context.goNamed(nUri(name!).name/*,params: {"branch":"999"}*/);
        // TODO: Handle this case.
        break;
      case NavigatoreTyp.PopUntill:
        parms!=null?
        context.goNamed(nUri(name!).name,params: parms):
        context.goNamed(nUri(name!).name/*,params: {"branch":"999"}*/);
        // context.vxNav.clearAndPush(Uri(path:nUri(name!)));
        // TODO: Handle this case.
        break;
      case NavigatoreTyp.homenav:
        if(Vx.isWeb) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            context.go("/store/" + nUri(Routename.Home).path);
          });
        }else {
          Future.delayed(Duration.zero, () {
            // context.go(nUri(Routename.Home).path);
            context.go("/store/" + nUri(Routename.Home).path);
          });
        }
          //GoRouter.of(context).pop();
          // GoRouter.of(context).refresh();
          GoRouter.of(context).notifyListeners();
          // context.vxNav.popToRoot();
        //});
        // TODO: Handle this case.
        break;
    }
  }
}
class RoutesArg  extends VxObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('Pushed a route');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('Popped a route');
  }

  @override
  void didChangeRoute(Uri route, Page<dynamic> page, String pushOrPop) {
    // TODO: implement didChangeRoute
    print("${route.path} - $pushOrPop");
  }

}