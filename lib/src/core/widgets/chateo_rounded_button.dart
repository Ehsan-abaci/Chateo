import 'package:flutter/material.dart';

class ChateoRoundedButton extends StatelessWidget {
  const ChateoRoundedButton({
    super.key,
    required this.text,
    required this.function,
    this.focusNode,
  });

  final String text;
  final Function() function;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      focusNode: focusNode,
      onPressed: function,
      style: ElevatedButton.styleFrom(
        side: BorderSide.none,
        fixedSize: Size(width * .8, 52),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
