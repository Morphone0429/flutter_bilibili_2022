import 'package:flutter_bilibili_lcq/http/core/hi_net.dart';
import 'package:flutter_bilibili_lcq/http/request/base_request.dart';
import 'package:flutter_bilibili_lcq/http/request/cancel_favorite_request.dart';
import 'package:flutter_bilibili_lcq/http/request/favorite_list_request.dart';
import 'package:flutter_bilibili_lcq/http/request/favorite_request.dart';
import 'package:flutter_bilibili_lcq/model/ranking_mo.dart';

class FavoriteDao {
  // https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance()?.fire(request);
    return result;
  }

  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    BaseRequest request = FavoriteListRequest();
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance()?.fire(request);
    return RankingMo.fromJson(result['data']);
  }
}
