import 'package:flutter_bilibili_lcq/http/core/hi_net.dart';
import 'package:flutter_bilibili_lcq/http/request/base_request.dart';
import 'package:flutter_bilibili_lcq/http/request/cancel_like_request.dart';
import 'package:flutter_bilibili_lcq/http/request/like_request.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1A5411L71X
  static like(String vid, bool like) async {
    BaseRequest request = like ? LikeRequest() : CancelLikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance()?.fire(request);
    return result;
  }
}
