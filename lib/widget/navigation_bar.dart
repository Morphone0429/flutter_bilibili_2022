import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:provider/provider.dart';

class KNavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const KNavigationBar(
      {Key? key, this.statusStyle = StatusStyle.DARK_CONTENT, this.color = Colors.white, this.height = 46, this.child})
      : super(key: key);

  @override
  State<KNavigationBar> createState() => _KNavigationBarState();
}

class _KNavigationBarState extends State<KNavigationBar> {
  var _statusStyle;
  var _color;
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusStyle.LIGHT_CONTENT;
    } else {
      _color = widget.color;
      _statusStyle = widget.statusStyle;
    }
    _statusBarInit(); // watch之后就会_statusBarInit()
    var top = MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width, // 屏幕宽度
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
    );
  }

  void _statusBarInit() {
    changeStatusBar(color: _color, statusStyle: _statusStyle);
  }
}
