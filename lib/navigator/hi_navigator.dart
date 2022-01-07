import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/page/home_page.dart';
import 'package:flutter_bilibili_lcq/page/login_page.dart';
import 'package:flutter_bilibili_lcq/page/registration_page.dart';
import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';

import 'bottom_navigator.dart';

// 页面跳转监听  当前页面  上一页面
typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo pre);

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
  } else if (page.child is BottomNavigator) {
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
// HiNavigator本身没有跳转能力 RouterDelegate提供
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _routeJump;

  List<RouteChangeListener> _listener = []; //感知监听的集合
  RouteStatusInfo? _current; //打开过的页面
  RouteStatusInfo? _bottomTab; //首页底部tab
  HiNavigator._();
  static HiNavigator? getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance;
  }

  // 首页底部tab切换监听 index切换的页面  page 打开的页面
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!); //_notify通知底部发送变化
  }

  // 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  // 监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    // 先判断listener是否有添加 ，没有添加先进行添加
    if (!_listener.contains(listener)) {
      _listener.add(listener);
    }
  }

  // 移出监听
  void removeListener(RouteChangeListener listener) {
    _listener.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    // TODO: implement onJumpTo
    _routeJump?.onJumpTo!(routeStatus, args: args);
  }

  // 通知路由页面变化  通过当前堆栈信息和上一页面堆栈信息对比
  // 什么时候通知？  在页面堆栈信息发生变化时
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    // current当前打开的页面   在栈的最顶部
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  // 通知
  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      // 当前打开的底部Bottomtab  打开的是首页，需要明确到首页具体哪一个tab
      current = _bottomTab!;
    }
    print('hinavcurrent当前页面:${current.page}');
    print('hinav_current上一次打开的页面:${_current?.page}');
    _listener.forEach((listener) {
      listener(current, _current!); // 告诉监听 这次打开的页面  和上一次打开的页面
    });
    _current = current; //将打开的页面赋值给本地的变量_current，_current永远是上一次打开的页面
  }
}

// 抽象类 供HiNavigator 实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

// 定义跳转类型
typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

// router 监听---> 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo? onJumpTo;
  RouteJumpListener({this.onJumpTo});
}
