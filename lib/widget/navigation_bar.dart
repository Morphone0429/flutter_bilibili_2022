import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT } // 暗黑 明亮

class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    var top = MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width, // 屏幕宽度
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  void _statusBarInit() {
    changeStatusBar();
  }

  void changeStatusBar(
      {color: Colors.white, StatusStyle statusStyle: StatusStyle.DARK_CONTENT, BuildContext? context}) {
    //沉浸式状态栏样式
    var brightness;
    if (Platform.isIOS) {
      brightness = statusStyle == StatusStyle.LIGHT_CONTENT ? Brightness.dark : Brightness.light;
    } else {
      brightness = statusStyle == StatusStyle.LIGHT_CONTENT ? Brightness.light : Brightness.dark;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }
}
