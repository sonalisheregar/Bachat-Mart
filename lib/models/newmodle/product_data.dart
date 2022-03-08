import '../../constants/IConstants.dart';
import '../../constants/features.dart';

class ItemData {
  String? id;
  String? eligibleForExpress;
  var deliveryDuration;
  String? eligibleForSubscription;
  List<SubscriptionSlot>? subscriptionSlot;
  //var subscriptionSlot;
  String? paymentMode;
  String? duration;
  String? categoryId;
  String? itemName;
  String? itemSlug;
  String? vegType;
  String? itemFeaturedImage;
  String? regularPrice;
  String? salePrice;
  String? isActive;
  String? salesTax;
  String? totalQty;
  String? brand;
  String? item_description;
  String? manufacturer_description;
  String? type;
  List<PriceVariation>? priceVariation;
  int? replacement;
  // var deliveryDuration;
  String? delivery;
  String? mode;
  String? membershipId;

  ItemData(
      {this.id,
        this.eligibleForExpress,
        this.deliveryDuration,
        this.eligibleForSubscription,
        this.subscriptionSlot,
        this.paymentMode,
        this.duration,
        this.categoryId,
        this.itemName,
        this.itemSlug,
        this.vegType,
        this.itemFeaturedImage,
        this.regularPrice,
        this.salePrice,
        this.isActive,
        this.salesTax,
        this.totalQty,
        this.brand,
        this.item_description,
        this.manufacturer_description,
        this.type,
        this.replacement,
        this.priceVariation,
        this.delivery,
        this.mode,
        this.membershipId,
      });

  ItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eligibleForExpress = Features.isExpressDelivery? Features.isSplit? json['eligible_for_express'] : "0" : "1";
    deliveryDuration = json['delivery_duration'];
    eligibleForSubscription = json['eligible_for_subscription'];
    if (json['subscription_slot'] != null) {
      subscriptionSlot = <SubscriptionSlot>[];
      json['subscription_slot'].forEach((v) {
        subscriptionSlot!.add(new SubscriptionSlot.fromJson(v));
      });
    }

    deliveryDuration = (json['delivery_duration'] == "slot" || json['delivery_duration'] == ""|| json['delivery_duration'] == null)
        ?new DeliveryDurationData(duration: "",durationType: "",note: ""):new DeliveryDurationData.fromJson(json['delivery_duration']is List<dynamic> ?json['delivery_duration'][0]:json['delivery_duration']);
    paymentMode = json['payment_mode'];
    duration = json['duration'];
    categoryId = json['category_id'];
    itemName = json['item_name'];
    itemSlug = json['item_slug'];
    vegType = json['veg_type'];
    itemFeaturedImage = (json['item_featured_image']==null||json['item_featured_image']==[])?"" : IConstants.API_IMAGE + "items/images/" +json['item_featured_image'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    salesTax = json['sales_tax'];
    totalQty = json['total_qty'];
    replacement = json['replacement'];
    brand = json['brand'];
    item_description = json['item_description'];
    manufacturer_description = json['manufacturer_description'];
    type = json['type'];
    delivery = (json['delivery']??"0");
    mode=(json['mode']??"0");
    if (json['price_variation'] != null) {
      // print("variation: ${json['price_variation']}");
      priceVariation = <PriceVariation>[];
      json['price_variation'].forEach((v) {
        // v["type"] = type;
        v.addAll({
          "type":type
        });
        priceVariation!.add(new PriceVariation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eligible_for_express'] = this.eligibleForExpress;
    data['delivery_duration'] = this.deliveryDuration;
    data['eligible_for_subscription'] = this.eligibleForSubscription;
    if (this.subscriptionSlot != null) {
      data['subscription_slot'] =
          this.subscriptionSlot!.map((v) => v.toJson()).toList();
    }
    data['payment_mode'] = this.paymentMode;
    data['duration'] = this.duration;
    data['category_id'] = this.categoryId;
    data['item_name'] = this.itemName;
    data['item_slug'] = this.itemSlug;
    data['veg_type'] = this.vegType;
    data['item_featured_image'] = this.itemFeaturedImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['sales_tax'] = this.salesTax;
    data['total_qty'] = this.totalQty;
    data['brand'] = this.brand;
    data['replacement'] = this.replacement;
    data['type'] = this.type;
    data['mode'] =this.mode;
    if (this.priceVariation != null) {
      data['price_variation'] =
          this.priceVariation!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryDuration != null) {
      data['delivery_duration'] = this.deliveryDuration.toJson();
    }
    return data;
  }
}

class SubscriptionSlot {
  String? id;
  String? name;
  String? cronTime;
  String? deliveryTime;
  String? branch;
  String? status;

  SubscriptionSlot(
      {this.id,
        this.name,
        this.cronTime,
        this.deliveryTime,
        this.branch,
        this.status});

  SubscriptionSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cronTime = json['cronTime'];
    deliveryTime = json['deliveryTime'];
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cronTime'] = this.cronTime;
    data['deliveryTime'] = this.deliveryTime;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}

class PriceVariation {
  int? loyalty;
  String? netWeight;
  String? id;
  String? menuItemId;
  String? variationName;
  String? price;
  String? priority;
  String? mrp;
  double? stock;
  String? maxItem;
  String? unit;
  String? status;
  String? minItem;
  String? membershipPrice;
  int? loyaltys;
  List<ImageDate>? images;
  String? weight;
  int? quantity;
  bool? discointDisplay = false;
  bool? membershipDisplay = false;
  String? mode;
  AddOn? addon;

  PriceVariation(
      {this.loyalty,
        this.netWeight,
        this.id,
        this.menuItemId,
        this.variationName,
        this.price,
        this.priority,
        this.mrp,
        this.stock,
        this.maxItem,
        this.unit,
        this.status,
        this.minItem,
        this.membershipPrice,
        this.loyaltys,
        this.images,
        this.weight,
        this.quantity,
        this.membershipDisplay,
        this.discointDisplay,
        this.mode,
        // this.addon
      });

  PriceVariation.fromJson(Map<String, dynamic> json) {
    loyalty = json['loyalty'];
    netWeight = json['net_weight'];
    id = json['id'];
    menuItemId = json['menu_item_id'];
    variationName = json['variation_name'];
    // addon = json['addon'];
    price = (IConstants.numberFormat == "1")?double.parse(json['price'].toString()).toStringAsFixed(0):double.parse(json['price'].toString()).toStringAsFixed(IConstants.decimaldigit);
    // print("price..."+json['price'].toString());
    // print("price"+price.toString());
    priority = json['priority'];
    mrp = (IConstants.numberFormat == "1")?double.parse(json['mrp'].toString()).toStringAsFixed(0):double.parse(json['mrp'].toString()).toStringAsFixed(IConstants.decimaldigit);
    stock = json["type"]=="0"?double.parse(json['stock'].toString()):double.parse(json['stock_double'].toString());
    maxItem = json['max_item'].toString();
    unit = json['unit'];
    status = json['status'];
    minItem = json['min_item'].toString();
    membershipPrice = (IConstants.numberFormat == "1")?double.parse(json['membership_price'].toString()).toStringAsFixed(0):double.parse(json['membership_price'].toString()).toStringAsFixed(IConstants.decimaldigit);
    loyaltys = json['loyaltys'];
    if (json['images'] != null) {
      images = <ImageDate>[];
      json['images'].forEach((v) {
        images!.add(new ImageDate.fromJson(v));
      });
    }
    if(json['price'] <= 0 || json['price'] == "" || json['price'] == json['mrp']){
      discointDisplay = false;
    } else {
      discointDisplay = true;
    }
    if(json['membership_price'] == '-' || json['membership_price'] == "0" || json['membership_price'] == json['mrp']
        || json['membership_price'] == json['price']) {
      membershipDisplay = false;
    } else {
      membershipDisplay = true;
    }
    weight = json['weight'].toString();
    quantity = int.parse(json['quantity'].toString());
    mode= json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loyalty'] = this.loyalty;
    data['net_weight'] = this.netWeight;
    data['id'] = this.id;
    data['menu_item_id'] = this.menuItemId;
    data['variation_name'] = this.variationName;
    data['price'] = this.price;
    data['priority'] = this.priority;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['max_item'] = this.maxItem;
    data['unit'] = this.unit;
    data['status'] = this.status;
    data['min_item'] = this.minItem;
    data['membership_price'] = this.membershipPrice;
    // data['addon'] = this.addon;
    data['loyaltys'] = this.loyaltys;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    data['quantity'] = this.quantity;
    data['mode']=this.mode;
    return data;
  }
}
class AddOn {
  String? itemId;
  String? id;
  String? category;
  String? itemName;
  String? itemSlug;
  String? vegType;
  String? regularPrice;
  String? salePrice;
  String? isActive;
  String? isSubscription;
  String? salesTax;
  String? maxItem;
  String? totalQty;
  String? brand;
  String? reference;
  String? duration;
  String? nested;
  String? type;
  String? delivery;
  String? priority;
  String? branch;
  String? parent;
  String? productType;
  String? variationId;
  String? menuItemId;
  String? variationName;
  String? barcode;
  String? price;
  String? membershipPrice;
  String? subscription;
  String? mrp;
  String? stock;
  String? status;
  String? minItem;
  String? sku;
  String? hsn;
  String? featuredImage;
  String? weight;
  String? netWeight;
  String? loyalty;
  String? cost;
  String? isAddon;
  String? cartExpiry;
  String? wholesale;

  AddOn(
      {this.itemId,
        this.id,
        this.category,
        this.itemName,
        this.itemSlug,
        this.vegType,
        this.regularPrice,
        this.salePrice,
        this.isActive,
        this.isSubscription,
        this.salesTax,
        this.maxItem,
        this.totalQty,
        this.brand,
        this.reference,
        this.duration,
        this.nested,
        this.type,
        this.delivery,
        this.priority,
        this.branch,
        this.parent,
        this.productType,
        this.variationId,
        this.menuItemId,
        this.variationName,
        this.barcode,
        this.price,
        this.membershipPrice,
        this.subscription,
        this.mrp,
        this.stock,
        this.status,
        this.minItem,
        this.sku,
        this.hsn,
        this.featuredImage,
        this.weight,
        this.netWeight,
        this.loyalty,
        this.cost,
        this.isAddon,
        this.cartExpiry,
        this.wholesale});

  AddOn.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    id = json['id'];
    category = json['category'];
    itemName = json['itemName'];
    itemSlug = json['itemSlug'];
    vegType = json['vegType'];
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    isActive = json['isActive'];
    isSubscription = json['isSubscription'];
    salesTax = json['salesTax'];
    maxItem = json['maxItem'];
    totalQty = json['totalQty'];
    brand = json['brand'];
    reference = json['reference'];
    duration = json['duration'];
    nested = json['nested'];
    type = json['type'];
    delivery = json['delivery'];
    priority = json['priority'];
    branch = json['branch'];
    parent = json['parent'];
    productType = json['product_type'];
    variationId = json['variation_id'];
    menuItemId = json['menu_item_id'];
    variationName = json['variationName'];
    barcode = json['barcode'];
    price = json['price'];
    membershipPrice = json['membership_price'];
    subscription = json['subscription'];
    mrp = json['mrp'];
    stock = json['stock'];
    status = json['status'];
    minItem = json['minItem'];
    sku = json['sku'];
    hsn = json['hsn'];
    featuredImage = json['featured_image'];
    weight = json['weight'];
    netWeight = json['net_weight'];
    loyalty = json['loyalty'];
    cost = json['cost'];
    isAddon = json['isAddon'];
    cartExpiry = json['cart_expiry'];
    wholesale = json['wholesale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['id'] = this.id;
    data['category'] = this.category;
    data['itemName'] = this.itemName;
    data['itemSlug'] = this.itemSlug;
    data['vegType'] = this.vegType;
    data['regularPrice'] = this.regularPrice;
    data['salePrice'] = this.salePrice;
    data['isActive'] = this.isActive;
    data['isSubscription'] = this.isSubscription;
    data['salesTax'] = this.salesTax;
    data['maxItem'] = this.maxItem;
    data['totalQty'] = this.totalQty;
    data['brand'] = this.brand;
    data['reference'] = this.reference;
    data['duration'] = this.duration;
    data['nested'] = this.nested;
    data['type'] = this.type;
    data['delivery'] = this.delivery;
    data['priority'] = this.priority;
    data['branch'] = this.branch;
    data['parent'] = this.parent;
    data['product_type'] = this.productType;
    data['variation_id'] = this.variationId;
    data['menu_item_id'] = this.menuItemId;
    data['variationName'] = this.variationName;
    data['barcode'] = this.barcode;
    data['price'] = this.price;
    data['membership_price'] = this.membershipPrice;
    data['subscription'] = this.subscription;
    data['mrp'] = this.mrp;
    data['stock'] = this.stock;
    data['status'] = this.status;
    data['minItem'] = this.minItem;
    data['sku'] = this.sku;
    data['hsn'] = this.hsn;
    data['featured_image'] = this.featuredImage;
    data['weight'] = this.weight;
    data['net_weight'] = this.netWeight;
    data['loyalty'] = this.loyalty;
    data['cost'] = this.cost;
    data['isAddon'] = this.isAddon;
    data['cart_expiry'] = this.cartExpiry;
    data['wholesale'] = this.wholesale;
    return data;
  }
}
class DeliveryDurationData {
  String? id;
  String? durationType;
  String? duration;
  String? status;
  String? branch;
  String? note;
  String? blockFor;

  DeliveryDurationData(
      {this.id="",
        this.durationType="",
        this.duration="",
        this.status="",
        this.branch="",
        this.note="'",
        this.blockFor=""});

  DeliveryDurationData.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    durationType = json['durationType'].toString();
    duration = json['duration']??"";
    status = json['status'].toString();
    branch = json['branch']??"";
    note = json['note'];
    blockFor = json['blockFor']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['durationType'] = this.durationType;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['branch'] = this.branch;
    data['note'] = this.note;
    data['blockFor'] = this.blockFor;
    return data;
  }
}


class ImageDate {
  String? id;
  String? image;
  String? ref;

  ImageDate({this.id, this.image, this.ref});

  ImageDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image =  IConstants.API_IMAGE+"items/images/" +json['image'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['ref'] = this.ref;
    return data;
  }
}
