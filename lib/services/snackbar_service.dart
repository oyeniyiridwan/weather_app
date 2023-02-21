import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/app/app.locator.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/enum.dart';

void setupSnackBar() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackBarType.success,
    config: SnackbarConfig(
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.green,
      textColor: AppColor.whiteColor,
      borderRadius: 5,
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.only(top: 20, bottom: 0, right: 20, left: 20),
      barBlur: 0.6,
      messageColor:AppColor.whiteColor,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackBarType.failure,
    config: SnackbarConfig(
      backgroundColor: AppColor.redColor,
      textColor: AppColor.whiteColor,
      borderRadius: 1,
      dismissDirection: DismissDirection.horizontal,
      // animationDuration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
      barBlur: 0.6,
      messageColor: AppColor.whiteColor,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
    ),
  );
}
