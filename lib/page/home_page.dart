import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_state.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/dao/home_dao.dart';
import 'package:flutter_bilibili_lcq/model/home_mo.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/page/profile_page.dart';
import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:flutter_bilibili_lcq/widget/hi_tab.dart';
import 'package:flutter_bilibili_lcq/widget/loading_container.dart';
import 'package:flutter_bilibili_lcq/widget/navigation_bar.dart';

import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;

  late TabController _controller;

  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this); // app生命周期绑定
    _controller = TabController(
        length: categoryList.length,
        vsync: this); // TickerProviderStateMixin实现了vsync的功能 复用即可
    HiNavigator.getInstance()?.addListener(listener = (current, pre) {
      // print('current: ${current.page}');
      // print('current: ${pre.page}');
      // 如何判断页面有没有被压后台
      if (widget == current.page || current.page is HomePage) {
        // print('打开了首页onResume');
      } else if (widget == pre?.page || pre.page is HomePage) {
        // pre第一次打开可能会不存在
        // print('首页被压后台onPause');
      }

      // 当页面返回到首页时  首页状态栏状态异常  需要重新设置
      if (pre?.page is VideoDetailPage && current.page is! ProfilePage) {
        var statusStyle = StatusStyle.DARK_CONTENT;
        changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      }
    });

    loadData();
  }

  ///监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // print(':didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        //fix Android压后台首页状态栏字体颜色变白，详情页状态栏字体变黑问题
        changeStatusBar();
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    HiNavigator.getInstance()?.removeListener(listener);

    _controller.dispose();

    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(),
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Column(
          children: [
            KNavigationBar(
              height: 50,
              child: _appBar(),
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
            ),
            Container(
              // color: Colors.white,
              decoration: bottomBoxShadow(),
              child: _tabBar(),
            ),
            Flexible(
              child: TabBarView(
                controller: _controller, // _controller通过  与_tabBar联动
                children: categoryList.map((tab) {
                  return HomeTabPage(
                    name: tab.name,
                    bannerList: tab.name == '推荐' ? bannerList : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(text: tab.name);
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  _appBar() {
    return Padding(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                image: AssetImage('images/avatar.png'),
                height: 46,
                width: 46,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                height: 32,
                child: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ))
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      if (result.categoryList != null) {
        // tab长度变化后需要重新创建TabController
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print('$e');
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      print('$e');
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
