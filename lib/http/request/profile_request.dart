import 'package:flutter_bilibili_lcq/http/request/base_request.dart';

class ProfileRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/profile";
  }
}
