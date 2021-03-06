import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/http/dao/login_dao.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/page/dark_mode_page.dart';
import 'package:flutter_bilibili_lcq/page/login_page.dart';
import 'package:flutter_bilibili_lcq/page/notice_page.dart';
import 'package:flutter_bilibili_lcq/page/registration_page.dart';
import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';
import 'package:flutter_bilibili_lcq/provider/hi_provider.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:provider/provider.dart';

import 'db/hi_cache.dart';
import 'model/video_model.dart';
import 'navigator/bottom_navigator.dart';

void main() {
  runApp(BiliApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: BiliApp(),
//     );
//   }
// }

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  // 使用navigator
  // _routeDelegate代理
  final BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder可以在真正打开页面是 预初始化
    return FutureBuilder<HiCache>(
      builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
        // 定义route   如果还在加载中 返回全局的loading
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(
                // routeInformationParser: _routeInformationParser,   web
                routerDelegate: _routeDelegate,
                // routeInformationProvider: PlatformRouteInformationProvider(
                //     initialRouteInformation: RouteInformation(location: '/')),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        return MultiProvider(
            providers: topProviders,
            child: Consumer<ThemeProvider>(builder: (BuildContext context,
                ThemeProvider themeProvider, Widget? child) {
              return MaterialApp(
                  home: widget,
                  theme: themeProvider.getTheme(),
                  darkTheme: themeProvider.getTheme(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode());
            }));
      },
      future: HiCache.preInit(), // 缓存读取初始化
    );
  }
}

// RouterDelegate代理
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // navigatorKey初始化  好处可以通过GlobalKey获取当前NavigatorState
  // 为Navigator设置一个key 必要的时候可以用过navigatorKey.currentState来获取NavigatorState对象
  final GlobalKey<NavigatorState> navigatorKey;
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现路由跳转逻辑 路由初始化时 注册逻辑
    HiNavigator.getInstance()?.registerRouteJump(
      RouteJumpListener(
        onJumpTo: (routeStatus, {args}) {
          _routeStatus = routeStatus;
          if (routeStatus == RouteStatus.detail) {
            videoModel = args!['videoMo'];
          }
          notifyListeners();
        },
      ),
    );
  }

  RouteStatus _routeStatus = RouteStatus.home;

  List<MaterialPage> pages = []; // 存放页面集合
  VideoModel? videoModel;

  // BiliRoutePath? path;
  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus); // 打开的页面是否在路由堆栈，存在的话在什么位置
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已经存在，则将该页面和它上面的所有页面进行出栈
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if (routeStatus == RouteStatus.home) {
      // 跳转首页时将栈中其他页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(BottomNavigator()); // 创建首页
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.darkMode) {
      page = pageWrap(DarkModePage());
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.notice) {
      page = pageWrap(NoticePage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    // 重新创建一个数组 否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    // 路由变化  通知路由发生变化  tempPages此时是新的堆栈信息  page还未赋值 是旧的堆栈信息
    HiNavigator.getInstance()?.notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!
          .maybePop(), //返回上一页调用的方法  获取全局navigatorKey  修复安卓物理返回键无法返回上一页的问题
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // 登录页 未登录 点击返回键  进行拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast('请先登录');
                return false;
              }
            }
          }

          // 这里控制是否可以返回上一页
          if (!route.didPop(result)) {
            return false;
          }
          // 关闭页面  通知路由变化
          var tempPages = [...pages];
          pages.removeLast(); // 返回的上一页面移出  栈顶页面移出
          HiNavigator.getInstance()?.notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  // 路由拦截
  RouteStatus get routeStatus {
    // print('是否已登录-登录令牌：${LoginDao.getBoardingPass()}');
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  // 是否登录
  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}
}

// 定义路由数据  path
class BiliRoutePath {
  final String location;
  // 命名构造函数
  BiliRoutePath.home() : location = '/';
  BiliRoutePath.detail() : location = '/detail';
}
