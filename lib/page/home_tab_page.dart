import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_lcq/http/dao/home_dao.dart';
import 'package:flutter_bilibili_lcq/model/home_mo.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/widget/hi_banner.dart';
import 'package:flutter_bilibili_lcq/widget/video_card.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String? name;
  final List<BannerMo>? bannerList;
  const HomeTabPage({Key? key, this.name, this.bannerList}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: HiBanner(widget.bannerList!),
    );
  }

  @override
  get contentChild => CustomScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          if (widget.name == '推荐')
            SliverList(
              delegate: SliverChildBuilderDelegate((content, index) {
                return Padding(padding: EdgeInsets.only(bottom: 8), child: _banner());
              }, childCount: 1),
            ),

          SliverGrid.count(
              crossAxisCount: 2,
              children: List.generate(dataList.length, (index) {
                return VideoCard(videoMo: dataList[index]);
              }).toList()),
          // SliverList
        ],
      );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(widget.name!, pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList;
  }
}
