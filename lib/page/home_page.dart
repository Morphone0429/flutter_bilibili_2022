import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/video_model.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel>? onJumpToDetail;

  const HomePage({Key? key, this.onJumpToDetail}) : super(key: key);

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
              onPressed: () => widget.onJumpToDetail!(VideoModel(1111)),
              child: Text('跳转至详情页'),
            )
          ],
        ),
      ),
    );
  }
}
