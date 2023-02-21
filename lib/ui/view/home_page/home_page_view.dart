import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/ui/view/home_page/widget/default_card.dart';
import 'package:weather_app/ui/view/home_page/widget/drawer.dart';
import 'package:weather_app/ui/view/home_page/home_page_viewmodel.dart';
import 'package:weather_app/ui/view/home_page/widget/carousel_list.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/constant.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageViewModel>.reactive(
        viewModelBuilder: () => HomePageViewModel(),
        onViewModelReady: (model) async {
          await model.initialize();
        },
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            color: Colors.transparent,
            progressIndicator: const CircularProgressIndicator(
              strokeWidth: 5,
              color: AppColor.secondaryColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Weather"),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () async {
                        await model.onPressedLocation();
                      },
                      icon: Icon(
                        Icons.location_on_outlined,
                        size: 30.h,
                      ))
                ],
              ),
              extendBodyBehindAppBar: true,
              drawer: Drawer(
                child: MyDrawer(
                  cities: model.cities,
                  onPressed: model.onPressed,
                  current: model.currentCity,
                  onChange: model.checkHandler,
                ),
              ),
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  height: 1.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              model.defaultCityWeather.weather?.backGround ??
                                  clear),
                          fit: BoxFit.fill)),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await model.initialize();
                    },
                    child: ListView(
                      children: [
                        DefaultCard(
                            defaultCityWeather: model.defaultCityWeather),
                        40.verticalSpace,
                        CarouselList(
                          weathers: model.weathers,
                          checkHandler: model.checkHandler,
                          updateIndex: model.updateIndex,
                        ),
                        10.verticalSpace,
                        if (model.weathers.isNotEmpty)
                          DotsIndicator(
                            dotsCount: model.weathers.length,
                            position: model.currentIndex.toDouble(),
                            decorator: const DotsDecorator(
                              color: AppColor.greyColor2,
                              activeColor: AppColor.whiteColor,
                            ),
                          )
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
