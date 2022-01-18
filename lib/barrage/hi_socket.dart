// ISocket 类接口
import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/model/barrage_model.dart';
import 'package:flutter_bilibili_lcq/util/hi_constants.dart';
import 'package:web_socket_channel/io.dart';

abstract class ISocket {
  /// 和服务端建立链接 vid 视频id
  ISocket open(String vid);

  /// 发送弹幕
  ISocket send(String message);

  ///关闭连接 (如关闭页面时断开链接)
  void close();

  ///接受弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}

class HiSocket implements ISocket {
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;

  ///心跳间隔秒数，根据服务器实际timeout时间来调整，这里Nginx服务器的timeout为60
  final int _intervalSeconds = 50;

  @override
  void close() {
    if (_channel != null) {
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
    _callBack = callBack;
    return this; //返回this可以在外部链式调用
  }

  //建立长链接  初始化channel  headers用于鉴权
  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(
      _URL + vid,
      headers: HiConstants.headers(),
      pingInterval: Duration(seconds: _intervalSeconds),
    );
    _channel?.stream.handleError((error) {
      print('连接发生错误:$error');
    }).listen((message) {
      _handleMessage(message);
    });
    return this;
  }

  ///处理服务端的返回
  void _handleMessage(message) {
    print('received: $message');
    var result = BarrageModel.fromJsonString(message);
    if (_callBack != null) {
      _callBack!(result);
    }
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }
}
