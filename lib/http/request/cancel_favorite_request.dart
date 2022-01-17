import 'package:flutter_bilibili_lcq/http/request/base_request.dart';
import 'package:flutter_bilibili_lcq/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
