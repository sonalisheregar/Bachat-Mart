import 'package:bachat_mart/repository/authenticate/AuthRepo.dart';
import 'package:bachat_mart/repository/notification/notification_repo.dart';

import '../../constants/IConstants.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/fetchdata/home_repo.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
enum NotificationTYP{
  fetch,clear
}
class NotificationController{
  NotificationController(NotificationTYP notification){
    switch(notification){
      case NotificationTYP.fetch:
        notificationrepo.fetch();
        // TODO: Handle this case.
        break;
      case NotificationTYP.clear:
        notificationrepo.clear();
        // TODO: Handle this case.
        break;
    }
  }
}
class HomeScreenController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var mode;
  var branch;
  var user;
  var rows;
  //var languageid;

HomeScreenController({this.mode = "getAll",this.branch="15",this.user,this.rows ="0",/*this.languageid*/});
  @override
  Future<bool> perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
     store!.homescreen = await homePagerepo.getData(ParamBodyData(user: user,branch:branch??"15" ,languageId: IConstants.languageId,mode: mode,rows: "0"));
     if(store!.homescreen.data!.customerDetails!.length>0) {
       store!.userData.area = store!.homescreen.data!.customerDetails![0].area;
     } else {
       store!.userData.area = PrefUtils.prefs!.containsKey("deliverylocation")?PrefUtils.prefs!.getString("deliverylocation"):IConstants.currentdeliverylocation.value;
      }
     store!.userData.branch =branch;
      store!.userData.delevrystatus = true;
     store!.userData.latitude =  store!.homescreen.data!.customerDetails!.length>0?store!.homescreen.data!.customerDetails![0].latitude:PrefUtils.prefs!.containsKey("latitude")?PrefUtils.prefs!.getString("latitude"):PrefUtils.prefs!.getString("restaurant_lat");
     store!.userData.longitude =  store!.homescreen.data!.customerDetails!.length>0?store!.homescreen.data!.customerDetails![0].longitude:PrefUtils.prefs!.containsKey("longitude")?PrefUtils.prefs!.getString("longitude"):PrefUtils.prefs!.getString("restaurant_long");
     store!.userData.membership =  store!.homescreen.data!.customerDetails!.length>0?store!.homescreen.data!.customerDetails![0].membership:"0";
    print("stored area:${store!.userData.area}");
    print("stored branch:${store!.userData.branch}");
  return Future.value(true);
  }}
