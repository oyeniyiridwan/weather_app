import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:weather_app/app/app.router.dart';
import 'package:weather_app/app/service_locator.dart' as locator;

class DynamicService{
  FirebaseDynamicLinks? dynamicLinks;

  DynamicService(){
    dynamicLinks = FirebaseDynamicLinks.instance;
    initDynamicLinks();
  }
  Future initDynamicLinks()async{
    final dynamicLink = await dynamicLinks!.getInitialLink();
    if(dynamicLink != null){
      String title = extractData(dynamicLink.link);
      await locator.sharedPreferencesService.setString('default', title);
    }}

  Future<void> createDynamicLink(String path) async {
    String url = 'https://shevyweatherapp.page.link';
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: url,
        link: Uri.parse('$url/$path'),
        androidParameters: const AndroidParameters(
          packageName: "com.example.weather_app",
          minimumVersion: 0,
        ),
        iosParameters: const IOSParameters(
          bundleId: "com.example.weather_app",
          minimumVersion: '0',
        ),
        socialMetaTagParameters:  SocialMetaTagParameters(
          description: '',
          title: path,
        )
    );
    ShortDynamicLink shortLink =
    await dynamicLinks!.buildShortLink(parameters);
    Uri uri =  shortLink.shortUrl;
    await Share.share(uri.toString(), subject: path);
  }

  Future<void> dynamicListen()async{
     dynamicLinks!.onLink.listen((data) async{
   var newValue = extractData(data.link);
   // locator.navigationService.navigateToSecondPage();
       locator.sharedPreferencesService.setString('default', newValue);
       locator.navigationService.replaceWith(Routes.homePageView);
    }).onError((error){
      debugPrint('error');
    });
    }



String extractData(Uri uri){
  List<String> separated = [];
  separated.addAll(uri.path.split('/'));
  return separated.last;
}}