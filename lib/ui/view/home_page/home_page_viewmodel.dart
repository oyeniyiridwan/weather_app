import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/app/service_locator.dart'as locator;
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/extensions/city_service.dart';
import 'package:weather_app/services/extensions/open_weather_service.dart';

class HomePageViewModel extends BaseViewModel {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Map<String, bool> cities = {};
  @override
  bool isBusy = true;
  bool firebase = false;
  final List<String> _savedCitiesName =
      locator.sharedPreferencesService.getStringList('listOfCities') ??
          ['Abuja', 'Ibadan', 'Onitsha'];
  String get defaultCity =>
      locator.sharedPreferencesService.getString('default') ?? 'Lagos';
  String? _value;
  int currentIndex = 0;
  String get currentCity => _value ?? defaultCity;
  OpenWeather defaultCityWeather = OpenWeather();
  List<OpenWeather> weathers = [];

  updateIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

  getSavedCities() async {
    var response = await locator.apiService.readJson();
    List<String> temporary = [];
    for (var item in response) {
      temporary.add(item.city.toString());
    }
    for (var item in temporary) {
      cities.addEntries({item: _savedCitiesName.contains(item)}.entries);
    }
    notifyListeners();
  }

  onPressed(String value) {
    locator.sharedPreferencesService.setString('default', value);
    getWeatherInfoDefault();
    _value = null;
    notifyListeners();
    locator.navigationService.back();
  }

  onPressedLocation() async {
    isBusy = true;
    notifyListeners();
    try {
      defaultCityWeather = await locator.apiService.getCurrentLocationWeather();
      _value = defaultCityWeather.name;
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
    }
  }

  initialize() async {
    debugPrint(_value);
    if (_value != null) {
      defaultCityWeather = await locator.apiService.getCurrentLocationWeather();
    } else {
      await getWeatherInfoDefault();
      await getSavedCities();
    }

    await getWeatherInfoForSavedCities();
  }

  getWeatherInfoDefault() async {
    isBusy = true;
    try {
      _value = null;
      defaultCityWeather = await locator.apiService.getWeatherByCityName(currentCity);
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
    }
  }

  getWeatherInfoForSavedCities() async {
    List<OpenWeather> temporary = [];
    for (var item in _savedCitiesName) {
      var response = await locator.apiService.getWeatherByCityName(item);
      temporary.add(response);
      weathers = temporary;
    }
    notifyListeners();
  }

  checkHandler(String addCity, bool newValue) {
    cities[addCity] = newValue;
    if (_savedCitiesName.contains(addCity)) {
      deleteWeatherInfo(addCity);
    } else {
      getWeatherForNewCity(addCity);
    }
  }

  getWeatherForNewCity(String addCity) async {
    _savedCitiesName.insert(0, addCity);
    notifyListeners();
    locator.sharedPreferencesService.setStringList('listOfCities', _savedCitiesName);
    var response = await locator.apiService.getWeatherByCityName(addCity);
    weathers.insert(0, response);
    currentIndex = 0;
    notifyListeners();
  }

  deleteWeatherInfo(String city) {
    _savedCitiesName.remove(city);
    notifyListeners();
    locator.sharedPreferencesService.setStringList('listOfCities', _savedCitiesName);
    weathers.removeWhere((element) => element.name == city);
    currentIndex = 0;
    notifyListeners();
  }

  Future<void> createDynamicLink() async {
    locator.dynamicService.createDynamicLink(defaultCity);
  }

  Future<void> showNotification()async{
locator.localNotificationService.showNotificationWithActions();
  }

  }


