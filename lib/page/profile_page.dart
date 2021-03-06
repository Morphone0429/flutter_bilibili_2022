import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/dao/profile_dao.dart';
import 'package:flutter_bilibili_lcq/model/profile_mo.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:flutter_bilibili_lcq/util/view_util.dart';
import 'package:flutter_bilibili_lcq/widget/benefit_card.dart';
import 'package:flutter_bilibili_lcq/widget/course_card.dart';
import 'package:flutter_bilibili_lcq/widget/dark_mode_item.dart';
import 'package:flutter_bilibili_lcq/widget/hi_banner.dart';
import 'package:flutter_bilibili_lcq/widget/hi_blur.dart';
import 'package:flutter_bilibili_lcq/widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [_buildAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
        ),
      ),
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160, // 扩展高度
      pinned: true, // 标题栏是否固定
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: [
            Positioned.fill(
              child: cachedImage(
                  'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg'),
            ),
            Positioned.fill(
              child: HiBlur(sigma: 20),
            ),
            Positioned(child: _buildProfileTab(), left: 0, bottom: 0, right: 0)
          ],
        ),
        title: _buildHead(),
        titlePadding: EdgeInsets.only(left: 0),
      ), // 定义滚动空间
    );
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
      name: _profileMo!.name,
      face: _profileMo!.face,
      controller: _controller,
    );
  }

  _buildContentList() {
    if (_profileMo == null) return [Container()];
    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo!.courseList),
      BenefitCard(
        benefitList: _profileMo!.benefitList,
      ),
      DarkModeItem(),
    ];
  }

  _buildBanner() {
    return HiBanner(
      _profileMo!.bannerList,
      bannerHeight: 120,
      padding: EdgeInsets.only(left: 10, right: 10),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      color: Colors.white54,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileMo!.favorite),
          _buildIconText('点赞', _profileMo!.like),
          _buildIconText('浏览', _profileMo!.browsing),
          _buildIconText('金币', _profileMo!.coin),
          _buildIconText('粉丝', _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black54)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600]))
      ],
    );
  }
}
