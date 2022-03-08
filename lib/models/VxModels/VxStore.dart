import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/home_page_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../models/newmodle/user.dart';

import '../../models/sellingitemsfields.dart';
import 'package:velocity_x/velocity_x.dart';
import '../language.dart';

class GroceStore extends VxStore{
  /// contain list of languages
final language = LanguagesList();
///contain login user data if user has logged in
UserData userData = UserData();
int? notificationCount = UserModle().notificationCount;
Prepaid prepaid = Prepaid();
HomePageData homescreen = HomePageData();
List<ItemData> productlist = [];
List<CartItem> CartItemList = [];
// List<CategoryData> categorydatalist = [];
ItemData? singelproduct = ItemData();

SellingItemsFields OffersCartItemsFields= SellingItemsFields();
List<SellingItemsFields> OfferCartList = []; //store and add to cart
List<SellingItemsFields> CartOfferList=[]; //update to cart
}