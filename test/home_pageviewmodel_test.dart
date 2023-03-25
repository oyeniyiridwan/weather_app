import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app/app.locator.dart';
import 'package:weather_app/ui/view/home_page/home_page_viewmodel.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await setupLocator();
  HomePageViewModel home = HomePageViewModel();
  test('test homepageviewmodel', () =>{
    home.updateIndex(2),
    expect(home.currentIndex, 2),
  });
}