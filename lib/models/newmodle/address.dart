import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressModle {
  bool? status;
  List<Address>? data;

  AddressModle({this.status, this.data});

  AddressModle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data =[];
      json['data'].forEach((v) {
        data!.add(new Address.fromJson(v));
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

class Address {
  int? id;
  String? customer;
  String? addressType;
  String? fullName;
  String? address;
  String? lattitude;
  String? logingitude;
  String? isdefault;
  String? pincode;
  IconData? addressicon;

  Address(
      {this.id,
        this.customer,
        this.addressType,
        this.fullName,
        this.address,
        this.lattitude,
        this.logingitude,
        this.isdefault,
        this.pincode,
        this.addressicon,
      });

  Address.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    customer = json['customer'];
    addressType = json['addressType'];
    fullName = json['fullName'];
    address = json['address'];
    lattitude = json['lattitude'];
    logingitude = json['logingitude'];
    isdefault = json['isdefault'];
    pincode = json['pincode'];
    addressicon= json['addressType'].toString().toLowerCase()=="home"? Icons.home:json['addressType'].toString().toLowerCase()=="work"?Icons.work:Icons.location_on;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['addressType'] = this.addressType;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['lattitude'] = this.lattitude;
    data['logingitude'] = this.logingitude;
    data['isdefault'] = this.isdefault;
    data['pincode'] = this.pincode;
    return data;
  }
}