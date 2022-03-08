import 'package:flutter/material.dart';
import '../constants/IConstants.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';

class CartCalculations with ChangeNotifier
{
  // static Box<Product> store = Hive.box<Product>(storeName);
  static deleteMembershipItem() async {
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    for(int i = 0; i < store.length; i++) {
      if(int.parse(store[i].mode!) == 1) {
        store.removeAt(i);
        break;
      }
    }
  }

///Check for the minimum and maximum Order Is in Range or not return true if order is not in range
  static bool get chackordderrange{
    return ( CartCalculations.checkmembership
        ?
    (double.parse((CartCalculations.totalMember).toStringAsFixed((IConstants.numberFormat == "1") ?0:IConstants.decimaldigit))
        < double.parse(IConstants.minimumOrderAmount)
        || double.parse((CartCalculations.totalMember).toStringAsFixed((IConstants.numberFormat == "1") ?0:IConstants.decimaldigit))
            > double.parse(IConstants.maximumOrderAmount))
        :
    (double.parse(
        (CartCalculations.total).toStringAsFixed((IConstants.numberFormat == "1") ?0:IConstants.decimaldigit)) <
        double.parse(IConstants.minimumOrderAmount) || double.parse(
        (CartCalculations.total).toStringAsFixed((IConstants.numberFormat == "1")
            ?0:IConstants.decimaldigit)) >
        double.parse(IConstants.maximumOrderAmount)));
  }

  /// Check for the product in cart was membership Product or not
  /// Note it will check all product if any one of them is containing membership or not
  static bool get checkmembershipexist {
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    for(int i = 0; i < store.length; i++) {
      if(int.parse(store[i].mode!) == 1) {
        return true;
      }
      }
    return false;
  }

  /// Check for the product in cart was membership Product or not
  /// note: it will check only if cart containing single product an also it is membership purchase product
  static bool get checkmembershipforcheckout {
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    if(store.length<=1&&int.parse(store[0].mode!) == 1) {
      return true;
    }else
    return false;
  }
  /// Check if the User is a Mererd use Or not
  static bool get checkmembership{
    return ( VxState.store as GroceStore).userData.membership=="1"?true:false;
  }

  /// Check if the Product in cart Containing offer product or Not
  static int get offerItem {
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    for(int i = 0; i < store.length; i++) {
      if(int.parse(store[i].mode!) == 4) {
        return 1;
      }
    }
    return 0;
  }

  static int get itemCount { // item count
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    int cartCount = 0;
    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0")
      cartCount = cartCount + int.parse(store[i].quantity!);
    }
    debugPrint("cartcount...1."+cartCount.toString());
    return cartCount;
  }

  static double get totalmrp { // mrp price
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    double totalmrp = 0;

    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0")
      totalmrp = totalmrp + (double.parse(store[i].varMrp!) * int.parse(store[i].quantity!));
    }
    return totalmrp;
  }

  static double get totalprice { //for discount without membership
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    double totalprice = 0;
    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0") {
        if (double.parse(store[i].price!) <= 0 ||
            double.parse(store[i].price!).toString() == "" ||
            double.parse(store[i].price!) ==
                double.parse(store[i].varMrp!)) {} else {
          totalprice = totalprice +
              ((double.parse(store[i].varMrp!) * int.parse(store[i].quantity!)) -
                  (double.parse(store[i].price!) *
                      int.parse(store[i].quantity!)));
        }
      }
    }
    return totalprice;
  }

  static double get discount {
    double discount = 0;
      discount = totalmrp - total;
      return discount;
  }

  static double get totalMembersPrice { //for discount with membership
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    double totalprice = 0;
    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0") {
        if (store[i].membershipPrice == '-' ||
            store[i].membershipPrice == "0") {
          if (double.parse(store[i].price!) <= 0 ||
              double.parse(store[i].price!).toString() == "" ||
              double.parse(store[i].price!) == double.parse(store[i].varMrp!)) {

          } else {
            totalprice = totalprice +
                ((double.parse(store[i].varMrp!) * int.parse(store[i].quantity!))
                    - (double.parse(store[i].price!) *
                        int.parse(store[i].quantity!)));
          }
        } else {
          totalprice = totalprice +
              ((double.parse(store[i].varMrp!) * int.parse(store[i].quantity!)) -
                  (double.parse(store[i].membershipPrice!) *
                      int.parse(store[i].quantity!)));
        }
      }
    }

    return totalprice;
  }

  static double get total { //Total amount without membership
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    double total = 0;
    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0") {
        if (double.parse(store[i].price!) <= 0 ||
            double.parse(store[i].price!).toString() == "" ||
            double.parse(store[i].price!) == double.parse(store[i].varMrp!)) {
          total = total +
              (double.parse(store[i].price!) /*varMrp*/ *
                  int.parse(store[i].quantity!));
        } else {
          total = total +
              (double.parse(store[i].price!) * int.parse(store[i].quantity!));
        }
      }
    }
    return total;
  }

  static double get totalMember { //Total amount with membership
    List<CartItem> store =( VxState.store as GroceStore).CartItemList;
    double total = 0;
    for(int i = 0; i < store.length; i++) {
      if(double.parse(store[i].varStock! ) > 0 && store[i].status.toString() == "0") {
        if (store[i].membershipPrice == '-' ||
            store[i].membershipPrice == "0") {
          if (double.parse(store[i].price!) <= 0 ||
              double.parse(store[i].price!).toString() == "" ||
              double.parse(store[i].price!) == double.parse(store[i].varMrp!)) {
            total = total +
                (double.parse(store[i].varMrp!) * int.parse(store[i].quantity!));
          } else {
            total = total +
                (double.parse(store[i].price!) * int.parse(store[i].quantity!));
          }
        } else {

          total = total +
              (double.parse(store[i].membershipPrice!) *
                  int.parse(store[i].quantity!));
        }
      }
    }
    return total;
  }

}