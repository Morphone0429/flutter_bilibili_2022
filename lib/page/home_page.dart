import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_state.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/dao/home_dao.dart';
import 'package:flutter_bilibili_lcq/model/home_mo.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:flutter_bilibili_lcq/widget/navigation_bar.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;

  late TabController _controller;

  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    _controller = TabController(length: categoryList.length, vsync: this); // TickerProviderStateMixin实现了vsync的功能 复用即可
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
    });
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance()?.removeListener(listener);
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          NavigationBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          ),
          Container(
            color: Colors.white,
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(tab.name, style: TextStyle(fontSize: 16)),
          ),
        );
      }).toList(),
      isScrollable: true,
      labelColor: Colors.black,
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: primary, width: 3),
        insets: EdgeInsets.only(left: 15, right: 15),
      ),
      controller: _controller,
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
        _controller = TabController(length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
      });
    } on NeedAuth catch (e) {
      print('$e');
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print('$e');
      showWarnToast(e.message);
    }
  }
}
