import 'package:chewie/chewie.dart'
    hide MaterialControls; // MaterialControls隐藏chewie自带的ui
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

import 'hi_video_controls.dart';

class VideoView extends StatefulWidget {
  final String url; //视频url
  final String cover; // 视频的封面
  final bool autoPlay;
  final bool looping; //是否循环播放
  final double aspectRadio; // 视频缩放比例  16：9
  final Widget? overlayUI; // 覆盖的UI
  final Widget? barrageUI; // 弹幕UI

  const VideoView(
    this.url, {
    Key? key,
    required this.cover,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRadio = 16 / 9,
    this.overlayUI,
    this.barrageUI,
  }) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController; //video_player播放器Controller
  late ChewieController _chewieController; //chewie播放器Controller

  // 封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1, // 填满FractionallySizedBox
        child: cachedImage(widget.cover),
      );

  // 进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: primary,
      handleColor: primary,
      backgroundColor: Colors.grey,
      bufferedColor: primary[50]!);

  @override
  void initState() {
    super.initState(); //父类先initState
    // 初始化播放器
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRadio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      placeholder: _placeholder,
      allowMuting: false, // 是否允许静音
      allowPlaybackSpeedChanging: false, // 不显示播放速度
      customControls: MaterialControls(
        showLoadingOnInitialize: false, //初始不显示loading
        showBigPlayIcon: false, // 不显示中间播放按钮
        bottomGradient: blackLinearGradient(), // 底部渐变
        overlayUI: widget.overlayUI,
        barrageUI: widget.barrageUI,
      ),
      materialProgressColors: _progressColors,
    );
    _chewieController.addListener(_fullScreenListener); //fix iOS无法正常退出全屏播放问题
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 视频宽度
    double playerHeight = screenWidth / widget.aspectRadio; // 视频高度

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _chewieController
        .removeListener(_fullScreenListener); // 先释放_fullScreenListener
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose(); // 父类后dispose
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size; //通过size判断全屏状态
    if (size.width > size.height) {
      // 强制设置竖屏  DeviceOrientation.portraitUp  如果是全屏状态，退出全屏时强制设置为非全屏状态
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
