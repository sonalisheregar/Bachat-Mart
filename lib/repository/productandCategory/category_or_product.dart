import 'dart:convert';
import '../../constants/IConstants.dart';
import '../../generated/l10n.dart';

import '../../models/newmodle/category_modle.dart';
import '../../models/newmodle/product_data.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';

class ProductRepo {
  List<CategoryData> _nestItem = [];

Future<List<CategoryData>>  getCategory()async {
  Api api = Api();
   var resp = json.decode(await api.Geturl(
      "restaurant/get-categories?branch=${PrefUtils.prefs!.getString("branch") ??
          "15"}&language_id=${PrefUtils.prefs!.getString("language_id") ??
          "0"}",isv2: false));
  if (resp["status"]) {
    List<CategoryData> caatdata;
   return CategoryDataModle.fromJson(resp).data!/*.data.forEach((element) =>
        getSubcategory(element, (p0) {
          element.subCategory.addAll(p0);
          caatdata.add(element);
        }))*/;
    // return caatdata;
  }
  else{
    return [];
  }
}
getSubcategory(String catid, Function(List<CategoryData>) response) async {
  Api api = Api();
    if(catid!=null) {

        /*api.body={
          "language_id":IConstants.languageId,//PrefUtils.prefs.getString("language_id"),
          "branch":PrefUtils.prefs!.getString("branch")??"999",
          "allKey":S .current.all,
        };*/
      var resp = await api.Geturl("restaurant/get-sub-category/${catid}");
     // https://manage.grocbay.com/api/app-manager/get-functionality/v2/restaurant/get-sub-category-deep/150
      print("hello"+resp.toString());
      if (resp != "[]") {
        if (SubCatModle.fromJson(json.decode(resp)).status!) {
         response( SubCatModle.fromJson(json.decode(resp)).data!);
        } else {
          response([]);
        }
      } else {
        response([]);
      }
    }
    else{
      response([]);
    }
  }
Future<List<CategoryData>> getSubNestcategory(String catid,/* Function(List<CategoryData>) response*/) async {
  Api api = Api();
  final resp = await api.Geturl("restaurant/get-sub-category-deep/${catid}");
  // https://manage.grocbay.com/api/app-manager/get-functionality/v2/restaurant/get-sub-category-deep/150
  print("response,,,,,"+resp.toString());
  List<CategoryData> data = [];
  if ((json.decode(resp)).toString() == "[]")
   return [];
  else
    print("data,,,,,,"+json.decode(resp)["data"].toString());
    json.decode(resp)["data"].asMap().forEach((index, value) {
      data.add(CategoryData.fromJson(value));
    });
    return Future.value(data);

}

  Future<List<ItemData>> getCartProductLists(categoryId, {start = 0, end = 0, type=0,}) async {
    Api api = Api();
    api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs!.getString("branch")??"15",
      "user": PrefUtils.prefs!.getString("apiKey") ?? PrefUtils.prefs!.getString("tokenid")!,
      "language_id": IConstants.languageId,//"0",
      "type" : type.toString(),
    };
 final response = await api.Posturl("restaurant/get-menuitem-by-cart");
if((json.decode(response)["data"]).toString()=="[]")
  return [];
else
    return Future.value(ItemModle.fromJson(json.decode(response)).data);
  }
  Future<List<ItemData>?> getcategoryitemlist(categoryId) async {
    Api api = Api();
  api.body = {
    "branch": PrefUtils.prefs!.getString("branch")!,
    "language_id": IConstants.languageId,//"0",
  };
  final response = await api.Posturl("get-items-by-cart/$categoryId/${PrefUtils.prefs!.getString("apiKey") ?? "1"}",isv2: false);
  List<ItemData> data =[];
  if((json.decode(response)).toString()=="[]")
    return null;
  else{
    json.decode(response).asMap().forEach((index, value){
      data.add(ItemData.fromJson(value));
    });
    return Future.value(data);
  }

}
  Future<List<ItemData>?> getBrandProductLists(categoryId, {start = 0, end = 0,}) async {
    Api api = Api();
    api.body = {
      "id": categoryId,
      "start": start.toString(),
      "end": end.toString(),
      "branch": PrefUtils.prefs!.getString("branch")!,
      "user": PrefUtils.prefs!.getString("apiKey") ?? "1",
      "language_id": IConstants.languageId,//"0"
    };
    final response = await api.Posturl("restaurant/get-menuitem-by-brand-by-cart");

    if((json.decode(response)["data"]).toString()=="[]")
      return null;
    else
    return Future.value(ItemModle
        .fromJson(json.decode(response))
        .data);
  }
  Future<List<ItemData>> getProduct(prodid) async {
    Api api = Api();
  print("fetching productof varid:${prodid}");
  List<ItemData> _itemdata =[];
    api.body = {
      'id': prodid,
      'branch': PrefUtils.prefs!.getString("branch")??"15",
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("tokenid")!,
      'language_id': IConstants.languageId,//'0'
    };
  _itemdata.clear();
    json.decode(await api.Posturl("single-product-by-var",isv2: false)).asMap().forEach((index, value) {
      _itemdata.clear();
      _itemdata.add(ItemData.fromJson(value)) ;
    });
  return _itemdata;
  }
  Future<List<ItemData>> getSearchQuery(query,{int start = 0 ,int end = 0}) async {
    Api api = Api();
  if(start!=null){
    api.body = {
      'branch': PrefUtils.prefs!.getString("branch")!,
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!,
      'language_id': IConstants.languageId,//'0',
      'item_name': '$query',
      'start':'$start',
      'end':'$end',
    };
  }
  /*else
    api.body = {
      'branch': PrefUtils.prefs!.getString("branch"),
      'user': PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("tokenid"),
      'language_id': '0',
      'item_name': '$query',
    };*/
  final resp =  await api.Posturl("restaurant/search-items-by-cart");
  print("search......."+resp.toString());
    return Future.value(ItemModle.fromJson(json.decode(resp)).data??=[]);
  }
  Future<ItemModle> getRecentProduct(prodid) async {
    Api api = Api();
    return Future.value(ItemModle.fromJson(json.decode(await api.Posturl("restaurant/get-recent-products-by-cart/$prodid/${PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey"):PrefUtils.prefs!.getString("ftokenid")}/${PrefUtils.prefs!.getString("branch")??"15"}",isv2: false))));
  }
}
class CategoryDataModle {
  bool? status;
  List<CategoryData>? data;

  CategoryDataModle({this.status, this.data});

  CategoryDataModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class ItemModle {
  bool? status;
  List<ItemData>? data =[];
  String? label;

  ItemModle({this.status, this.data,this.label});

  ItemModle.fromJson(Map<String, dynamic> json) {
    status = json['status']??true;
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {

        data!.add(new ItemData.fromJson(v));
      });
      label = json['label'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    return data;
  }
}
class SubCatModle {
  bool? status;
  List<CategoryData>? data;

  SubCatModle({this.status, this.data});

  SubCatModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
