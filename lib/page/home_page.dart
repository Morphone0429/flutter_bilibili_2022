import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<VideoModel>? onJumpToDetail;

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('home'),
            MaterialButton(
              // onPressed: () => widget.onJumpToDetail!(VideoModel(1111)),
              onPressed: () {
                HiNavigator.getInstance()?.onJumpTo(RouteStatus.detail,
                    args: {'videoMo': VideoModel(100)});
              },
              child: Text('跳转至详情页'),
            )
          ],
        ),
      ),
    );
  }
}
