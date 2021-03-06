// import 'package:flutter/material.dart';
// import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
// import 'package:flutter_bilibili_lcq/http/dao/home_dao.dart';
// import 'package:flutter_bilibili_lcq/model/home_mo.dart';
// import 'package:flutter_bilibili_lcq/model/video_model.dart';
// import 'package:flutter_bilibili_lcq/util/color.dart';
// import 'package:flutter_bilibili_lcq/util/toast.dart';
// import 'package:flutter_bilibili_lcq/widget/hi_banner.dart';
// import 'package:flutter_bilibili_lcq/widget/video_card.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class HomeTabPage extends StatefulWidget {
//   final String? name;
//   final List<BannerMo>? bannerList;
//   const HomeTabPage({Key? key, this.name, this.bannerList}) : super(key: key);

//   @override
//   _HomeTabPageState createState() => _HomeTabPageState();
// }

// class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin {
//   List<VideoModel> videoList = [];
//   int pageIndex = 1;
//   bool _loading = false;
//   final ScrollController _scrollController = ScrollController();
//   @override
//   bool get wantKeepAlive => true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _scrollController.addListener(() {
//       var dis = _scrollController.position.maxScrollExtent - _scrollController.position.pixels; // 滚动距离
//       //当距离底部不足300时加载更多
//       if (dis < 300 && !_loading) {
//         print('------_loadData---');
//         _loadData(loadMore: true);
//       }
//     });
//     _loadData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return RefreshIndicator(
//       onRefresh: _loadData,
//       color: primary,
//       child: MediaQuery.removePadding(
//         removeTop: true,
//         context: context,
//         child: CustomScrollView(
//           controller: _scrollController,
//           physics: AlwaysScrollableScrollPhysics(),
//           slivers: [
//             if (widget.name == '推荐')
//               SliverList(
//                 delegate: SliverChildBuilderDelegate((content, index) {
//                   return Padding(padding: EdgeInsets.only(bottom: 8), child: _banner());
//                 }, childCount: 1),
//               ),

//             SliverGrid.count(
//                 crossAxisCount: 2,
//                 children: List.generate(videoList.length, (index) {
//                   return VideoCard(videoMo: videoList[index]);
//                 }).toList()),
//             // SliverList
//           ],
//         ),
//       ),
//     );
//   }

//   _banner() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5),
//       child: HiBanner(widget.bannerList!),
//     );
//   }

//   Future<void> _loadData({loadMore = false}) async {
//     _loading = true;
//     if (!loadMore) {
//       pageIndex = 1;
//     }
//     var currentIndex = pageIndex + (loadMore ? 1 : 0); // 加载更多 就 +1 其他保持不变
//     print('loading:currentIndex:$currentIndex');
//     try {
//       HomeMo result = await HomeDao.get(widget.name!, pageIndex: currentIndex, pageSize: 10);
//       setState(() {
//         if (loadMore) {
//           if (result.videoList.isNotEmpty) {
//             //合成一个新数组
//             videoList = [...videoList, ...result.videoList];
//             pageIndex++;
//           }
//         } else {
//           videoList = result.videoList;
//         }
//       });
//       // 防止数据 到渲染 这中间  再次进行加载更多的操作   因为渲染需要时间
//       Future.delayed(Duration(milliseconds: 1000), () {
//         _loading = false;
//       });
//     } on NeedAuth catch (e) {
//       _loading = false;
//       print(e);
//       showWarnToast(e.message);
//     } on HiNetError catch (e) {
//       _loading = false;
//       print(e);
//       showWarnToast(e.message);
//     }
//   }
// }
