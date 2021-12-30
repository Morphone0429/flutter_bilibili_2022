import 'package:flutter_bilibili_lcq/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_lcq/http/request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 403);
    });
  }
}
