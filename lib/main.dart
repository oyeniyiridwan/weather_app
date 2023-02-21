import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/app/app.locator.dart';
import 'package:weather_app/app/app.router.dart';
import 'package:weather_app/services/snackbar_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  setupSnackBar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
              title: 'Weather App',
              onGenerateRoute: StackedRouter().onGenerateRoute,
              navigatorKey: StackedService.navigatorKey,
              debugShowCheckedModeBanner: false,
            ));
  }
}
