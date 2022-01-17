import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:flutter_bilibili_lcq/widget/hi_tab.dart';
import 'package:flutter_bilibili_lcq/widget/navigation_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with TickerProviderStateMixin {
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TABS.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return KNavigationBar(
        child: Container(
      decoration: bottomBoxShadow(),
      alignment: Alignment.center,
      child: _tabBar(),
    ));
  }

  _tabBar() {
    return HiTab(
      TABS.map<Tab>((tab) {
        return Tab(
          text: tab['name'],
        );
      }).toList(),
      controller: _controller,
      unselectedLabelColor: Colors.black54,
      borderWidth: 3,
      fontSize: 16,
    );
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: TABS.map((tab) {
              return Container();
            }).toList()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
