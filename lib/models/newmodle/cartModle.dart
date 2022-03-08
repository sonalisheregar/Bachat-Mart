import 'package:flutter/cupertino.dart';
import 'package:bachat_mart/constants/features.dart';

class CartItem {
  String? id;
  String? eligibleForExpress;
  String? durationType;
  String? duration;
  String? user;
  String? varId;
  String? quantity;
  String? createdDate;
  String? time;
  String? price;
  String? status;
  String? branch;
  String? itemId;
  String? varName;
  String? varMinItem;
  String? varMaxItem;
  String? itemLoyalty;
  String? varStock;
  String? varMrp;
  String? itemName;
  String? membershipPrice;
  String? itemActualprice;
  String? itemImage;
  String? membershipId;
  String? mode;
  String? type;
  String? delivery;
  String? vegType;
  String? note;
  String? addOn;
  List<Offer>? offer;

  CartItem(
      {this.id,
        this.eligibleForExpress,
        this.durationType,
        this.duration,
        this.user,
        this.varId,
        this.quantity,
        this.createdDate,
        this.time,
        this.price,
        this.status,
        this.branch,
        this.itemId,
        this.varName,
        this.varMinItem,
        this.varMaxItem,
        this.itemLoyalty,
        this.varStock,
        this.varMrp,
        this.itemName,
        this.membershipPrice,
        this.itemActualprice,
        this.itemImage,
        this.membershipId,
        this.mode,
        this.type,
        this.vegType,
        this.note,
        this.addOn,
        this.delivery,
        this.offer
      });

  CartItem.fromJson(Map<String, dynamic> json) {
    debugPrint("duration...type"+json['var_id'].toString());
    id = json['id'];
    eligibleForExpress = json['eligible_for_express'].toString();
    durationType = Features.isSplit ? json['duration_type'].toString():"";
    duration = Features.isSplit ? json['duration'].toString():"";
    user = json['user'];
    varId = json['var_id'];
    quantity = json['quantity'];
    createdDate = json['created_date'];
    time = json['time'];
    price = json['price'].toString();
    status = (json['status']).toString();
    branch = json['branch'];
    itemId = json['itemId'];
    varName = json['varName'];
    varMinItem = json['varMinItem'];
    varMaxItem = json['varMaxItem'];
    itemLoyalty = json['itemLoyalty'];
    varStock = (json['varStock']).toString();
    varMrp = (json['varMrp']).toString();
    itemName = json['itemName'];
    membershipPrice = (json['membershipPrice']).toString();
    itemActualprice = (json['itemActualprice']).toString();
    itemImage = json['itemImage'];
    membershipId = json['membershipId'];
    mode = json['mode'];
    type = json['type'];
    vegType = json['veg_type'];
    note = json['note'];
    addOn = json['addon'];
    delivery=json['delivery'];
    if (json['offer'] != null) {
      offer = [];
      json['offer'].forEach((v) {
        offer!.add(new Offer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson({price,quantity}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eligible_for_express'] = this.eligibleForExpress;
    data['duration_type'] = this.durationType;
    data['duration'] = this.duration;
    data['user'] = this.user;
    data['var_id'] = this.varId;
    data['quantity'] = quantity??this.quantity;
    data['created_date'] = this.createdDate;
    data['time'] = this.time;
    data['price'] = price??this.price;
    data['status'] = this.status;
    data['branch'] = this.branch;
    data['itemId'] = this.itemId;
    data['varName'] = this.varName;
    data['varMinItem'] = this.varMinItem;
    data['varMaxItem'] = this.varMaxItem;
    data['itemLoyalty'] = this.itemLoyalty;
    data['varStock'] = this.varStock;
    data['varMrp'] = this.varMrp;
    data['itemName'] = this.itemName;
    data['membershipPrice'] = this.membershipPrice;
    data['itemActualprice'] = this.itemActualprice;
    data['itemImage'] = this.itemImage;
    data['membershipId'] = this.membershipId;
    data['mode'] = this.mode;
    data['type'] = this.type;
    data['veg_type'] = this.vegType;
    data['note'] = this.note;
    data['addon'] = this.addOn;
    data['delivery']=this.delivery;
    if (this.offer != null) {
      data['offer'] = this.offer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Offer {
  String? orderAmount;

  Offer({this.orderAmount});

  Offer.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderAmount'] = this.orderAmount;
    return data;
  }
}