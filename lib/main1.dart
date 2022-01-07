// import 'package:flutter/material.dart';
// import 'package:flutter_bilibili_lcq/http/dao/login_dao.dart';
// import 'package:flutter_bilibili_lcq/page/home_page.dart';
// import 'package:flutter_bilibili_lcq/page/login_page.dart';
// import 'package:flutter_bilibili_lcq/page/registration_page.dart';
// import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';
// import 'package:flutter_bilibili_lcq/util/color.dart';

// import 'db/hi_cache.dart';
// import 'model/video_model.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: white,
//       ),
//       home: BiliApp(),
//     );
//   }
// }

// class BiliApp extends StatefulWidget {
//   const BiliApp({Key? key}) : super(key: key);

//   @override
//   _BiliAppState createState() => _BiliAppState();
// }

// class _BiliAppState extends State<BiliApp> {
//   // 使用navigator
//   BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
//   BiliRouteInformationParser _routeInformationParser =
//       BiliRouteInformationParser();
//   // 定义route

//   @override
//   Widget build(BuildContext context) {
//     var widget = Router(
//       routeInformationParser: _routeInformationParser,
//       routerDelegate: _routeDelegate,
//       routeInformationProvider: PlatformRouteInformationProvider(
//           initialRouteInformation: RouteInformation(location: '/')),
//     );

//     return MaterialApp(
//       home: widget,
//     );
//   }
// }

// class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin {
//   // navigatorKey初始化  好处可以通过GlobalKey获取当前NavigatorState
//   // 为Navigator设置一个key 必要的时候可以用过navigatorKey.currentState来获取NavigatorState对象
//   final GlobalKey<NavigatorState> navigatorKey;
//   BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
//   List<MaterialPage> pages = []; // 存放页面集合
//   VideoModel? videoModel;
//   BiliRoutePath? path;
//   @override
//   Widget build(BuildContext context) {
//     // 实现pages 堆栈
//     pages = [
//       pageWrap(HomePage(
//         onJumpToDetail: (videoModel) {
//           this.videoModel = videoModel;
//           notifyListeners(); //通知
//         },
//       )),
//       if (videoModel != null) pageWrap(VideoDetailPage(videoModel!))
//     ];

//     return Navigator(
//       key: navigatorKey,
//       pages: pages,
//       onPopPage: (route, result) {
//         // 这里控制是否可以返回上一页
//         if (!route.didPop(result)) {
//           return false;
//         }
//         return true;
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(BiliRoutePath configuration) async {
//     path = configuration;
//   }
// }

// // 将其解析为定义的数据类型
// class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
//   @override
//   Future<BiliRoutePath> parseRouteInformation(
//       RouteInformation routeInformation) async {
//     final uri = Uri.parse(routeInformation.location!); // 字符串转uri
//     print('uri:$uri');
//     if (uri.pathSegments.isEmpty) {
//       // 长度为0  认为是首页
//       return BiliRoutePath.home();
//     }
//     return BiliRoutePath.detail();
//   }
// }

// // 定义路由数据  path
// class BiliRoutePath {
//   final String location;
//   // 命名构造函数
//   BiliRoutePath.home() : location = '/';
//   BiliRoutePath.detail() : location = '/detail';
// }

// // 创建pages
// pageWrap(Widget child) {
//   return MaterialPage(key: ValueKey(child.hashCode), child: child);
// }
