import 'package:flutter/material.dart';
import 'package:flutter_bilibili_lcq/util/color.dart';

class LoginButton extends StatefulWidget {
  final String title;
  final bool enable;
  final VoidCallback? onPressed;

  const LoginButton(this.title, {Key? key, this.enable = true, this.onPressed})
      : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1, // 填满宽度
        child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          height: 45,
          disabledColor: primary[50],
          color: primary,
          child: Text(widget.title,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: widget.enable ? widget.onPressed : null,
        ));
  }
}
