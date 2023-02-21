import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/connectivity_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/shared_preference_service.dart';
import 'package:weather_app/ui/view/home_page/home_page_view.dart';

@StackedApp(
  routes:[
    CustomRoute(
      page: HomePageView,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 200,
      reverseDurationInMilliseconds: 200,
      initial: true,
    ),
  ],
  logger: StackedLogger(),
  dependencies:[
     Singleton(classType: ConnectivityService),
    Singleton(classType: ApiService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
      LazySingleton(classType: LocationService),
    Presolve(
      classType: SharedPreferenceService,
      presolveUsing: SharedPreferences.getInstance,
    ),
  ]

)
class App{}