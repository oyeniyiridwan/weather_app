import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/app/app.locator.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/connectivity_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/shared_preference_service.dart';

final apiService = locator<ApiService>();
final connectivityService = locator<ConnectivityService>();
 final sharedPreferencesService = locator<SharedPreferenceService>();
final snackbarService = locator<SnackbarService>();
final locationService = locator<LocationService>();
final navigationService = locator<NavigationService>();
