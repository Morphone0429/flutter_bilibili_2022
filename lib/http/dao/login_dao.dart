import 'package:flutter_bilibili_lcq/db/hi_cache.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_net.dart';
import 'package:flutter_bilibili_lcq/http/request/base_request.dart';
import 'package:flutter_bilibili_lcq/http/request/login_request.dart';
import 'package:flutter_bilibili_lcq/http/request/registration_request.dart';

class LoginDao {
  // 登录token

  static const BOARDING_PASS = 'boarding-pass';

  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }

    request
        .add('userName', userName)
        .add('password', password)
        .add('imoocId', imoocId ?? '')
        .add('orderId', orderId ?? '');
    var result = await HiNet.getInstance()?.fire(request);
    // 保存登录令牌
    if (result['code'] == 0 && result['data'] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }
}
