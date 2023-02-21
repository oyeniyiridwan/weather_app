import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/ui/view/home_page/widget/carousel.dart';

class CarouselList extends StatelessWidget {
  final List<OpenWeather> weathers;
  final Function(String s, bool value) checkHandler;
  final Function(int newIndex) updateIndex;
  const CarouselList(
      {Key? key,
      required this.weathers,
      required this.checkHandler,
      required this.updateIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: 200.h,
          autoPlay: true,
          enableInfiniteScroll: false,
          onPageChanged: (newIndex, _) {
            updateIndex(newIndex);
          }),
      itemCount: weathers.length,
      itemBuilder: (context, _, int index) {
        return Carousel(weather: weathers[index], checkHandler: checkHandler);
      },
    );
  }
}
