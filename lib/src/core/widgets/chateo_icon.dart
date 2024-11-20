import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChateoIcon extends StatelessWidget {
  const ChateoIcon({
    super.key,
    required this.icon,
    this.isDisabled = false,
    required this.height,
    this.color,
  });
  final Color? color;
  final String icon;
  final bool isDisabled;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      color: color ?? (isDisabled
              ? Theme.of(context).disabledColor
              : Theme.of(context).primaryColor),
      height: height,
    );
  }
}
