import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  final Map<String, bool> cities;
  final Function(String value) onPressed;
  final String current;
  final Function(String newValue, bool value) onChange;

  const MyDrawer({
    Key? key,
    required this.cities,
    required this.onPressed,
    required this.current,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(1.sw, 0.1.sh),
          child: AppBar(
            backgroundColor: const Color(0xff3fa9df),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "Cities",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  height: 2.h),
            ),
          ),
        ),
        body: Container(
            color: Colors.white54,
            child: ListView(
                children: cities.keys.map((e) {
              return Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(5.h),
                      title: Text(e),
                      selectedTileColor: const Color(0xff3fa9df),
                      selectedColor: Colors.white,
                      selected: (e == current),
                      onTap: () {
                        onPressed(e);
                      },
                    ),
                  ),
                  if (e != current)
                    Checkbox(
                      value: (cities[e] ?? false),
                      onChanged: (value) {
                        onChange(e, value!);
                      },
                      activeColor: const Color(0xff3fa9df),
                    )
                ],
              );
            }).toList())));
  }
}
