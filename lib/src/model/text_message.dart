part of 'message.dart';

class TextMessage extends Message {
  String? text;

  TextMessage(Map json) : super(json) {
    text = json['content'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['content'] = text;
    _chatSaveFormat['type'] = 'text';
    return _chatSaveFormat;
  }
}
