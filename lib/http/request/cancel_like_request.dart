import 'package:flutter_bilibili_lcq/http/request/base_request.dart';
import 'package:flutter_bilibili_lcq/http/request/like_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
