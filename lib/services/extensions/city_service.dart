import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:weather_app/model/city_model.dart';
import 'package:weather_app/services/api_service.dart';

extension Citey on ApiService{
  Future<List<City>> readJson() async {
    List<City> result = [];
    dynamic response = await rootBundle.loadString('assets/cities.json');
  final  data = json.decode(response);
 for(var item in data){
  result.add(City.fromJson(item));
}
 return result;

  }
}