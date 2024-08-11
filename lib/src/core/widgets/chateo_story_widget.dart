import 'package:ehsan_chat/src/core/utils/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChateoStoryWidget extends StatelessWidget {
  ChateoStoryWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  final Gradient gradient = LinearGradient(
    colors: [
      HexColor.fromHexColor("#D2D5F9"),
      HexColor.fromHexColor("#2C37E1"),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      
          _getStoryContent(),
          _getStoryText(),
        ],
      ),
    );
  }

  _getStoryContent() {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: CustomBorder(
          gradient: gradient,
          radius: const Radius.circular(18),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _getStoryText() {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 12,
      ),
    );
  }
}

class CustomBorder extends BoxBorder {
  final Radius? radius;
  final Gradient gradient;
  CustomBorder({
    this.radius,
    required this.gradient,
  });
  @override
  BorderSide get bottom => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    var borderPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        radius ?? const Radius.circular(0),
      ),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }

  @override
  // TODO: implement top
  BorderSide get top => throw UnimplementedError();
}
