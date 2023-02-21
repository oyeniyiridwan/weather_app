import 'package:flutter/material.dart';
import 'package:weather_app/app/service_locator.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/utils/constant.dart';
import 'package:weather_app/utils/api_response_handler.dart';
import 'package:weather_app/utils/enum.dart';

extension OpenWeatherApi on ApiService {
  Future<OpenWeather> getWeatherByLocation(String lat, String lon) async {
    String path = getWeather;
    Map<String, dynamic> parameters = {
      'lat': lat,
      'lon': lon,
      'appid': apiKey,
      'units': 'metric'
    };
    ApiResponse? getResponse = await get(path, queryParameters: parameters);
    if (getResponse != null && getResponse.statusCode == 200) {
      var response = getResponse.data;
      return OpenWeather.fromJson(response);
    } else {
      throw Exception("Failed to get weather report");
    }
  }

  Future<OpenWeather> getWeatherByCityName(String cityName) async {
    String path = getWeather;
    Map<String, dynamic> parameters = {
      'q': cityName,
      'appid': apiKey,
      'units': 'metric'
    };
    ApiResponse? getResponse = await get(path, queryParameters: parameters);
    if (getResponse != null && getResponse.statusCode == 200) {
      var response = getResponse.data;
      return OpenWeather.fromJson(response);
    } else {
      throw Exception("Failed to get weather report");
    }
  }

  Future<OpenWeather> getCurrentLocationWeather() async {
    if (await locationService.checkForPermission()) {
      var coord = await locationService.getCoordinate();
      return getWeatherByLocation(coord.lat.toString(), coord.lon.toString());
    } else {
      snackbarService.showCustomSnackBar(
          message: 'pls enable location permission',
          variant: SnackBarType.failure);
      throw Exception("");
    }
  }
}
