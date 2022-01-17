import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_lcq/http/dao/ranking_dao.dart';
import 'package:flutter_bilibili_lcq/model/ranking_mo.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key? key, required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  // TODO: implement contentChild
  get contentChild => Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return VideoLargeCard(videoModel: dataList[index]);
          },
          itemCount: dataList.length,
          controller: scrollController,
          padding: EdgeInsets.only(top: 10),
          physics: AlwaysScrollableScrollPhysics(),
        ),
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result = await RankingDao.get(widget.sort, pageIndex: pageIndex, pageSize: 20);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
