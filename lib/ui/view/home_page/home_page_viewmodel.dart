import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/app/service_locator.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/extensions/city_service.dart';
import 'package:weather_app/services/extensions/open_weather_service.dart';

class HomePageViewModel extends BaseViewModel {
  Map<String, bool> cities = {};
  @override
  bool isBusy = true;
  final List<String> _savedCitiesName =
      sharedPreferencesService.getStringList('listOfCities') ??
          ['Abuja', 'Ibadan', 'Onitsha'];
  String get defaultCity =>
      sharedPreferencesService.getString('default') ?? 'Lagos';
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
    var response = await apiService.readJson();
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
    sharedPreferencesService.setString('default', value);
    getWeatherInfoDefault();
    _value = null;
    notifyListeners();
    navigationService.back();
  }

  onPressedLocation() async {
    isBusy = true;
    notifyListeners();
    try {
      defaultCityWeather = await apiService.getCurrentLocationWeather();
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
      defaultCityWeather = await apiService.getCurrentLocationWeather();
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
      defaultCityWeather = await apiService.getWeatherByCityName(currentCity);
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
      var response = await apiService.getWeatherByCityName(item);
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
    sharedPreferencesService.setStringList('listOfCities', _savedCitiesName);
    var response = await apiService.getWeatherByCityName(addCity);
    weathers.insert(0, response);
    currentIndex = 0;
    notifyListeners();
  }

  deleteWeatherInfo(String city) {
    _savedCitiesName.remove(city);
    notifyListeners();
    sharedPreferencesService.setStringList('listOfCities', _savedCitiesName);
    weathers.removeWhere((element) => element.name == city);
    currentIndex = 0;
    notifyListeners();
  }
}
