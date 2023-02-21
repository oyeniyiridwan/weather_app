import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/utils/colors.dart';

class Carousel extends StatelessWidget {
  final Function(String s, bool value) checkHandler;
  final OpenWeather weather;
  const Carousel({Key? key, required this.weather, required this.checkHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10.h),
          width: 1.sw,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(weather.weather!.backGround.toString()),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(15.h),
          ),
          child: Card(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                children: [
                  Text(
                    '${weather.name}, ${weather.sys!.country}',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${weather.main?.temp!.round()}°c',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                              height: 50.h,
                              width: 50.h,
                              child: Image.network(
                                  weather.weather!.icon.toString())),
                          Text(
                            weather.weather!.description.toString(),
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15.sp,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Text(
                      "Max: ${weather.main!.tempMax}°c, Min: ${weather.main!.tempMin}°c",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  5.verticalSpace,
                  Text(
                    "Wind: ${weather.wind!.speed}m/s",
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          right: 5.h,
          child: InkWell(
            onTap: () {
              checkHandler("${weather.name}", false);
            },
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.secondaryColor),
              child: const Icon(
                Icons.close,
                size: 15,
                color: AppColor.whiteColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
