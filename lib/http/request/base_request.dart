enum HttpMethod { GET, POST, DELETE }
// 基础请求

abstract class BaseRequest {
  var pathParams;
  var useHttps = true; //http https动态切换
  String authority() {
    return "api.devio.org"; // 域名
  }

  HttpMethod httpMethod(); // 请求方法

  String path(); // uapi/test/test?requestPrams=11后缀

  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    print('url:${uri.toString()}');

    return uri.toString();
  }

  // 是否需要登录
  bool needLogin();

  Map<String, String> params = Map();

  // 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this; // return this 可以提供外部链式调用
  }

  // 鉴权
  Map<String, dynamic> header = {};
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
