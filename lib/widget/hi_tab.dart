import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:provider/provider.dart';

class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 13,
      this.borderWidth = 2,
      this.insets = 15,
      this.unselectedLabelColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLabelColor = themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
      tabs: tabs,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: _unselectedLabelColor,
      labelStyle: TextStyle(fontSize: fontSize),
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: primary, width: borderWidth),
        insets: EdgeInsets.only(left: insets, right: insets),
      ),
      controller: controller,
    );
  }
}
