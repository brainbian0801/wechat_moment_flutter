import 'dart:convert' show json;
import 'sender_model.dart';

class CommentModel{
  String content;
  SenderModel sender;

  CommentModel.fromParam({this.content,this.sender});

  CommentModel.fromJson(jsonRes){
    this.content = jsonRes['content'];
    this.sender = jsonRes['sender'] == null ? null : new SenderModel.fromJson(jsonRes['sender']);
  }

  @override
  String toString() {

    return '{"content":${content != null ? '${json.encode(content)}' : 'null' },"sender":$sender}';
  }
}