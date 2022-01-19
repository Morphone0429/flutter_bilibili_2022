import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DarkModeItem extends StatelessWidget {
  const DarkModeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var icon = themeProvider.isDark()
        ? Icons.nightlight_round
        : Icons.wb_sunny_rounded;
    return InkWell(
      onTap: () {
        HiNavigator.getInstance()?.onJumpTo(RouteStatus.darkMode);
      },
      child: Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(top: 10, left: 15, bottom: 15),
          child: Row(
            children: [
              Text('夜间模式',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 2, left: 10),
                child: Icon(icon),
              )
            ],
          )),
    );
  }
}
