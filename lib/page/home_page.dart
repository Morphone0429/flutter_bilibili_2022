import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<VideoModel>? onJumpToDetail;

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;

  late TabController _controller;

  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];

  @override
  void initState() {
    _controller = TabController(length: tabs.length, vsync: this); // TickerProviderStateMixin实现了vsync的功能 复用即可
    HiNavigator.getInstance()?.addListener(listener = (current, pre) {
      print('current: ${current.page}');
      print('current: ${pre.page}');
      // 如何判断页面有没有被压后台
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页onResume');
      } else if (widget == pre?.page || pre.page is HomePage) {
        // pre第一次打开可能会不存在
        print('首页被压后台onPause');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    HiNavigator.getInstance()?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller, // _controller通过  与_tabBar联动
              children: tabs.map((tab) {
                return HomeTabPage(name: tab);
              }).toList(),
            ),
          ),
          // Text('home'),
          // MaterialButton(
          //   // onPressed: () => widget.onJumpToDetail!(VideoModel(1111)),
          //   onPressed: () {
          //     HiNavigator.getInstance()?.onJumpTo(RouteStatus.detail,
          //         args: {'videoMo': VideoModel(100)});
          //   },
          //   child: Text('跳转至详情页1'),
          // )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(tab, style: TextStyle(fontSize: 16)),
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
}
