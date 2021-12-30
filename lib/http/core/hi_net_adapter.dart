import 'dart:convert';
import 'package:flutter_bilibili_lcq/http/request/base_request.dart';

// 统一网络层返回格式
class HiNetResponse<T> {
  HiNetResponse({
    this.data,
    required this.request,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });
  T? data;
  BaseRequest request;
  int? statusCode;
  String? statusMessage;
  late dynamic extra; //额外数据

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}

// 网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}
