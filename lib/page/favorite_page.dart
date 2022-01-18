import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_lcq/http/dao/favorite_dao.dart';
import 'package:flutter_bilibili_lcq/model/ranking_mo.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/page/video_detail_page.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:flutter_bilibili_lcq/widget/navigation_bar.dart';
import 'package:flutter_bilibili_lcq/widget/video_large_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState
    extends HiBaseTabState<RankingMo, VideoModel, FavoritePage> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance()?.addListener(listener = (current, pre) {
      if (pre.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance()?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNavigationBar(),
        Expanded(child: super.build(context)), // 继承父类的样式
      ],
    );
  }

  _buildNavigationBar() {
    return KNavigationBar(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: Text('收藏', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  // TODO: implement contentChild
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: 10),
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoLargeCard(
            videoModel: dataList[index],
          );
        },
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result =
        await FavoriteDao.favoriteList(pageIndex: 1, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
