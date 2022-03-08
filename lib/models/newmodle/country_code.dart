import 'dart:convert';

import 'package:flutter/services.dart';

class CountryCode {
  String? name;
  String? dialCode;
  String? code;
  List? data;

  Future<CountryCode> loadCountryCodeData(String code) async {
    List<CountryCode> list =[];
    final jsonText = await rootBundle.loadString('assets/data/country_code.json');
    json.decode(jsonText).asMap().forEach((index, value){
      list.add(CountryCode.fromJson(value));
    });
    return list.where((element) => element.code == code).first;
  }

  CountryCode({this.name, this.dialCode, this.code});

  CountryCode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    return data;
  }
}
