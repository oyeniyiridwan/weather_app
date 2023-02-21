import 'package:dio/dio.dart';
import 'package:weather_app/app/app.logger.dart';
import 'package:weather_app/app/service_locator.dart';
import 'package:weather_app/utils/api_constant.dart';
import 'package:weather_app/utils/api_response_handler.dart';
import 'package:weather_app/utils/enum.dart';

class ApiService{
  final dio = Dio();
  final log = getLogger('ApiService');
  ApiService(){
    dio.options.sendTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.options.baseUrl = baseUrl;
    log.i('API constructed and DIO setup registered');
  }

  Future<ApiResponse?> get(
      String path,{ Map<String, dynamic>? queryParameters,
      }
      )async{
    ApiResponse? res;
    if(connectivityService.hasConnection){
      log.i('Making request to $path');
      try {
        final response = await dio.get(path,
            queryParameters: queryParameters,
        );
        res = ApiUtils.toApiResponse(response);
        return res;
      }on DioError catch(e){
        log.wtf('From $path  - ${e.response?.data?.toString()}');
        res = ApiUtils.toApiResponse(e.response);
        return res;
      }
    }else {
      snackbarService.showCustomSnackBar(
        message: 'Please check your internet',
        variant: SnackBarType.failure,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
}
}