import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/dao/favorite_dao.dart';
import 'package:flutter_bilibili_lcq/http/dao/like_dao.dart';
import 'package:flutter_bilibili_lcq/http/dao/video_detail_dao.dart';
import 'package:flutter_bilibili_lcq/model/video_detail_mo.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:flutter_bilibili_lcq/widget/appbar.dart';
import 'package:flutter_bilibili_lcq/widget/expandable_content.dart';
import 'package:flutter_bilibili_lcq/widget/hi_tab.dart';
import 'package:flutter_bilibili_lcq/widget/navigation_bar.dart';
import 'package:flutter_bilibili_lcq/widget/video_header.dart';
import 'package:flutter_bilibili_lcq/widget/video_toolbar.dart';
import 'package:flutter_bilibili_lcq/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  List tabs = ["简介", "评论288"];
  late TabController _controller;
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel; // 新的数据 实时的是数据

  @override
  void initState() {
    super.initState();

    // 黑色状态栏 仅安卓
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);

    _controller = TabController(length: tabs.length, vsync: this);

    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: Platform.isIOS, // MediaQuery.removePadding移出黑色条
        child: videoModel?.url != null
            ? Column(
                children: [
                  KNavigationBar(
                    color: Colors.black,
                    statusStyle: StatusStyle.LIGHT_CONTENT,
                    height: Platform.isAndroid ? 0 : 46,
                  ),
                  _buildVideoView(),
                  _buildTabNavigation(),
                  Flexible(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        _buildDetailList(),
                        Container(
                          child: Text('敬请期待'),
                        )
                      ],
                    ),
                  )
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildVideoView() {
    var model = videoModel!;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }

  Widget _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(text: name);
      }).toList(),
      controller: _controller,
    );
  }

  Widget _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        buildContents(),
        ExpandableContent(
          mo: videoModel!,
        ),
        VideoToolBar(
          videoModel: videoModel!,
          detailMo: videoDetailMo,
          onLike: _onLike,
          onUnLike: _onUnLike,
          onFavorite: _onFavorite,
        )
      ],
    );
  }

  Widget buildContents() {
    return VideoHeader(
      owner: videoModel!.owner,
    );
  }

  _onLike() async {
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      print(result);
      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _onUnLike() {}

  _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      setState(() {
        videoDetailMo = result;
        // 更新旧数据
        videoModel = result.videoInfo;
      });

      print('print::::::::::::-------->>>>>$result');
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
