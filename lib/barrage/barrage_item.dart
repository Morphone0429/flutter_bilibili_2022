import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/barrage/barrage_transition.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top; //
  final Widget child; //
  final ValueChanged onComplete; // 弹幕播放完成
  final Duration duration; // 弹幕播放duration

  BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  //fix 动画状态错乱  因为HiBarrage中每播放一个动画都会调用  setState(() {})用来刷新页面
  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          child: child,
          key: _key,
          onComplete: (v) {
            onComplete(id);
          },
          duration: duration,
        ));
  }
}
