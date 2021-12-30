// ignore_for_file: unused_local_variable

import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_lcq/http/core/mock_adapter.dart';

import '../request/base_request.dart';

///1.支持网络库插拔设计，且不干扰业务层
///2.基于配置请求请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理
class HiNet {
  HiNet._();
  static HiNet? _instance; //单例写法  懒汉模式  使用时才创建
  static HiNet? getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      // on HiNetError获取错误的值
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    HiNetAdapter adapter = MockAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }
}
