import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/provider/theme_provider.dart';
import 'package:flutter_bilibili_lcq/util/format_util.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoMo;

  const VideoCard({Key? key, required this.videoMo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    return InkWell(
      onTap: () {
        HiNavigator.getInstance()?.onJumpTo(RouteStatus.detail, args: {'videoMo': videoMo});
      },
      child: SizedBox(
        child: Card(
          margin: EdgeInsets.only(
            left: 4,
            right: 4,
            bottom: 8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [_itemImage(context), _infoText(textColor)],
            ),
          ),
        ),
        height: 200,
      ),
    );
  }

  _itemImage(_) {
    final size = MediaQuery.of(_).size;
    return Stack(
      children: [
        cachedImage(
          videoMo.cover,
          height: 110,
          width: size.width / 2 - 10,
        ),
        Positioned(
          child: Container(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: const [Colors.black54, Colors.transparent]),
            ),
            child: (Row(
              children: [
                _iconText(Icons.ondemand_video, videoMo.view),
                _iconText(Icons.favorite_border, videoMo.favorite),
                _iconText(null, videoMo.duration),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )),
          ),
          left: 0,
          right: 0,
          bottom: 0,
        )
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = '';
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoMo.duration);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(views, style: TextStyle(color: Colors.white, fontSize: 10)),
        )
      ],
    );
  }

  _infoText(Color textColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(videoMo.title,
                maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: textColor)),
            _owner(textColor)
          ],
        ),
      ),
    );
  }

  _owner(Color textColor) {
    var owner = videoMo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // child: NetworkImage(owner.face, height: 24, width: 24),
              child: Image.network(
                owner.face,
                height: 24,
                width: 24,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner.name,
                style: TextStyle(fontSize: 11, color: textColor),
              ),
            )
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
