import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/core/hi_state.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';

///通用底层带分页和刷新的页面框架   T约束  它继承StatefulWidget
///M为Dao返回数据模型，L为列表数据模型，T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T> with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  final ScrollController scrollController = ScrollController();

  get contentChild; // 显示内容

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent - scrollController.position.pixels; // 滚动距离
      //当距离底部不足300时加载更多
      if (dis < 300 &&
          !loading &&
          //fix 当列表高度不满屏幕高度时不执行加载更多
          scrollController.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: loadData,
      color: primary,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: contentChild,
      ),
    );
  }

  // 获取对应页面的数据
  Future<M> getData(int pageIndex);

  // 从M(M为Dao返回数据模型)中解析出list 数据
  List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print("上次加载还没完成...");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0); // 加载更多 就 +1 其他保持不变
    print('loading:currentIndex:$currentIndex');
    try {
      var result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).isNotEmpty) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      // 防止数据 到渲染 这中间  再次进行加载更多的操作   因为渲染需要时间
      Future.delayed(Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }
}
