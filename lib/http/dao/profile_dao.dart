import 'package:flutter_bilibili_lcq/http/core/hi_net.dart';
import 'package:flutter_bilibili_lcq/http/request/profile_request.dart';
import 'package:flutter_bilibili_lcq/model/profile_mo.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance()?.fire(request);
    return ProfileMo.fromJson(result['data']);
  }
}
