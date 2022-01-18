import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/barrage/barrage_item.dart';
import 'package:flutter_bilibili_lcq/barrage/hi_socket.dart';
import 'package:flutter_bilibili_lcq/model/barrage_model.dart';

import 'barrage_view_util.dart';

enum BarrageStatus { play, pause } //弹幕状态 播放暂停

class HiBarrage extends StatefulWidget {
  final int lineCount; //弹幕显示的行数
  final String vid; // 弹幕vid
  final int speed; // 弹幕速度
  final double top; //弹幕距离顶部的距离
  final bool autoPlay; // 自动播放
  // final Map<String dynamic> headers;  //

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false})
      : super(key: key);

  @override
  HiBarrageState createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> {
  late HiSocket _hiSocket;
  late double _height; //弹幕高度
  late double _width; // 弹幕宽度
  List<BarrageItem> _barrageItemList = []; //弹幕Widget集合
  List<BarrageModel> _barrageModelList = []; //弹幕数据类型集合
  int _barrageIndex = 0; //第几条弹幕
  Random _random = Random(); // 创建随机数
  BarrageStatus? _barrageStatus; //弹幕状态
  Timer? _timer; // 计时器

  @override
  void initState() {
    super.initState();
    // 初始化HiSocket 开启监听
    _hiSocket = HiSocket();
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width; // 获取屏幕宽度
    _height = _width / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          //防止Stack的child为空
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  /// 处理消息 instant = true 马上发送
  _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList); //优先显示弹幕
    } else {
      _barrageModelList.addAll(modelList);
    }
    // 收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }

    // 收到新的的幕后播放  如第一次进入!= BarrageStatus.pause 会执行这行代码
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  // 播放
  play() {
    _barrageStatus = BarrageStatus.play;
    print('action:play');
    if (_timer != null && (_timer?.isActive ?? false)) {
      return;
    } // 说明定时器已经开启 无需再次开启
    //每间隔一段时间发一次弹幕
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        //将发送的弹幕将集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('start:${temp.content}');
      } else {
        print('All barrage are sent.');
        //弹幕发送完毕后关闭定时器
        _timer?.cancel();
      }
    });
  }

  // 添加弹幕
  addBarrage(BarrageModel model) {
    double perRowHeight = 30; // 每行弹幕所占高度
    var line = _barrageIndex % widget.lineCount; // 当前弹幕所处第几行
    _barrageIndex++;
    var top = line * perRowHeight + widget.top; // 当前弹幕距离顶部的距离
    // 为每条弹幕生成一个id
    String id = '${_random.nextInt(10000)}:${model.content}';

    var item = BarrageItem(
      child: BarrageViewUtil.barrageView(model),
      onComplete: _onComplete,
      id: id,
      top: top,
    );
    _barrageItemList.add(item); // 弹幕创建好之后 添加到集合
    setState(() {}); // 刷新页面
  }

  // 暂停
  pause() {
    _barrageStatus = BarrageStatus.pause; // 先修改弹幕状态为暂停
    // 清空屏幕上的弹幕
    _barrageItemList.clear();
    setState(() {}); // 刷新屏幕
    print('print::::::::::::-------->>>>>action:pause');
    _timer?.cancel();
  }

  // 发送弹幕
  send(String? message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }

  _onComplete(id) {
    print('Done:$id');
    //弹幕播放完毕将其从弹幕widget集合中剔除
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
