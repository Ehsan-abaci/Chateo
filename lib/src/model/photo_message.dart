part of 'message.dart';

class PhotoMessage extends Message {
  String? fileUrl;
  String? text;
  PhotoMessage(Map json) : super(json) {
    if (json.containsKey('media')) {
      fileUrl = json['media'];
    }
    text = json['content'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['media'] = fileUrl;
    _chatSaveFormat['content'] = text;
    _chatSaveFormat['type'] = 'image';
    return _chatSaveFormat;
  }
}
