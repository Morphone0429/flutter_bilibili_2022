import 'package:flutter_bilibili_lcq/http/core/hi_net.dart';
import 'package:flutter_bilibili_lcq/http/request/ranking_request.dart';
import 'package:flutter_bilibili_lcq/model/ranking_mo.dart';

class RankingDao {
  //https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=40
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstance()?.fire(request);

    return RankingMo.fromJson(result["data"]);
  }
}
