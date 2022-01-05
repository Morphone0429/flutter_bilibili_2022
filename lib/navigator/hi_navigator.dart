import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/page/home_page.dart';
import 'package:flutter_bilibili_lcq/page/login_page.dart';
import 'package:flutter_bilibili_lcq/page/registration_page.dart';
import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';

// 创建pages
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

// 获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (var i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

// 自定义路由封装 路由状态
enum RouteStatus { login, registration, home, detail, unknown }

// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;
  RouteStatusInfo(this.routeStatus, this.page);
}

// 监听路由页面跳转
// 感知当前页面是否压后台
class HiNavigator {
  static HiNavigator? _instance;
  HiNavigator._();
  static HiNavigator? getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance;
  }
}

// 抽象类 供HiNavigator 实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}
