import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:flutter_bilibili_lcq/util/format_util.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:provider/provider.dart';

class VideoLargeCard extends StatelessWidget {
  final VideoModel videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance()
            ?.onJumpTo(RouteStatus.detail, args: {'videoMo': videoModel});
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(
          children: [
            _itemImage(context),
            _buildContent(themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _itemImage(context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoModel.cover,
              width: height * (16 / 9), height: height),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  durationTransform(videoModel.duration),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildContent(ThemeProvider themeProvider) {
    var textColor = themeProvider.isDark() ? Colors.grey : Colors.black87;
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              videoModel.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: textColor),
            ),
            _buildBottomContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Column(
      children: [
        _owner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.ondemand_video, videoModel.view),
                hiSpace(width: 5),
                ...smallIconText(
                  Icons.list_alt,
                  videoModel.reply,
                )
              ],
            ),
            Icon(Icons.more_vert_sharp, color: Colors.grey, size: 15)
          ],
        )
      ],
    );
  }

  Widget _owner() {
    var owner = videoModel.owner;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(2)),
          child: Text('UP', style: TextStyle(fontSize: 8, color: Colors.grey)),
        ),
        hiSpace(width: 8),
        Text(owner.name, style: TextStyle(fontSize: 11, color: Colors.grey))
      ],
    );
  }
}
