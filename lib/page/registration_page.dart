import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/http/core/hi_error.dart';
import 'package:flutter_bilibili_lcq/http/dao/login_dao.dart';
import 'package:flutter_bilibili_lcq/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_lcq/util/string_util.dart';
import 'package:flutter_bilibili_lcq/util/toast.dart';
import 'package:flutter_bilibili_lcq/widget/appbar.dart';
import 'package:flutter_bilibili_lcq/widget/login_button.dart';
import 'package:flutter_bilibili_lcq/widget/login_effect.dart';
import 'package:flutter_bilibili_lcq/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  // final VoidCallback? onJumpToLogin; //跳转至登录
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false; //是否允许点击
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        HiNavigator.getInstance()?.onJumpTo(RouteStatus.login);
      }),
      body: ListView(
        children: [
          LoginEffect(protect: protect),
          LoginInput(
            "用户名",
            "请输入用户名",
            onChanged: (text) {
              userName = text;
              checkInput();
            },
          ),
          LoginInput(
            "密码",
            "请输入密码",
            obscureText: true,
            onChanged: (text) {
              password = text;
              checkInput();
            },
            focusChanged: (facus) {
              setState(() {
                protect = facus;
              });
            },
          ),
          LoginInput(
            "确认密码",
            "请再次输入密码",
            lineStretch: true,
            obscureText: true,
            onChanged: (text) {
              rePassword = text;
              checkInput();
            },
            focusChanged: (facus) {
              setState(() {
                protect = facus;
              });
            },
          ),
          LoginInput(
            "慕课网ID",
            "请输入你的慕课网用户ID",
            keyboardType: TextInputType.number,
            onChanged: (text) {
              imoocId = text;
              checkInput();
            },
          ),
          LoginInput(
            "课程订单号",
            "请输入课程订单号后四位",
            keyboardType: TextInputType.number,
            lineStretch: true,
            onChanged: (text) {
              orderId = text;
              checkInput();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(
              '注册',
              onPressed: checkParams,
              enable: loginEnable,
            ),
          )
        ],
      ),
    );
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(userName!, password!, imoocId!, orderId!);
      if (result['code'] == 0) {
        showToast('注册成功');
        HiNavigator.getInstance()?.onJumpTo(RouteStatus.login);
        // if (widget.onJumpToLogin != null) {
        //   widget.onJumpToLogin!();
        // }
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = "请输入订单号的后四位";
    }
    if (tips != null) {
      return;
    }
    send();
  }
}
