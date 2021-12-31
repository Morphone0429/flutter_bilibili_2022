import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';

// 登录输入input
class LoginInput extends StatefulWidget {
  final String title;
  final String hint; // 提示文案
  final ValueChanged<String>? onChanged; // 事件监听
  final ValueChanged<bool>? focusChanged; // 获取焦点事件
  final bool lineStretch; // input 底部线是否撑满
  final bool obscureText; // 密码
  final TextInputType? keyboardType; // 输入框类型

  const LoginInput(this.title, this.hint,
      {Key? key,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType})
      : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode(); // 输入框是否获取光标

  @override
  void initState() {
    super.initState();
    // 是否获取光标的监听
    _focusNode.addListener(() {
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(widget.title, style: TextStyle(fontSize: 16)),
            ),
            _input(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5,
            // color: Colors.grey.withOpacity(.5),
          ),
        )
      ],
    );
  }

  Widget _input() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText, // 不是密码类型，自动获取焦点
        cursorColor: primary, // 主题色
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 20), // 边距
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
      ),
    );
  }
}
