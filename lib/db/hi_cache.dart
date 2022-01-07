import 'package:shared_preferences/shared_preferences.dart';

///缓存管理类
class HiCache {
  SharedPreferences? prefs;

  HiCache._() {
    init();
  }

  static HiCache? _instance;

  // _pre初始化方法
  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  ///预初始化，防止在使用get时，prefs还未完成初始化  程序启动是对 hi_cache预初始化
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      // 为空时 才初始化   https://github.com/flutter/flutter/issues/65334
      // SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance!;
  }

  void init() async {
    if (prefs == null) {
      // 如果为空 创建SharedPreferences  .getInstance()获取实例
      prefs = await SharedPreferences.getInstance();
    }
  }

  // setString
  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  // setDouble
  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  // setInt
  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  // setBool
  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  // setStringList 向缓存添加一个集合
  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  remove(String key) {
    prefs?.remove(key);
  }

  // 读值操作
  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
