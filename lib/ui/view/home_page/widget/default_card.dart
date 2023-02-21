import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/constant.dart';

class DefaultCard extends StatelessWidget {
  final OpenWeather defaultCityWeather;
  const DefaultCard({Key? key, required this.defaultCityWeather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.5.sh,
      child: Card(
        color:  AppColor.secondaryColor2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              Text(
                '${defaultCityWeather.name ?? '__'}, ${defaultCityWeather.sys?.country ?? ''}',
                style: TextStyle(
                    color:AppColor.whiteColor,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    height: 2.h),
              ),
              20.verticalSpace,
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMEd().format(DateTime.now()),
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      DateFormat.jm().format(DateTime.now()),
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      '${defaultCityWeather.main?.temp!.round() ?? '__'}°c',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Image.network(
                          defaultCityWeather.weather?.icon??imagePlaceHolder),
                      Text(
                        defaultCityWeather.weather?.description ?? '...',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 15.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  )
                ],
              ),
              40.verticalSpace,
              Text(
                  "Max: ${defaultCityWeather.main?.tempMax ?? '__'}°c, Min: ${defaultCityWeather.main?.tempMin ?? '__'}°c",
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  )),
              5.verticalSpace,
              Text(
                "Wind: ${defaultCityWeather.wind?.speed ?? '__'}m/s",
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
