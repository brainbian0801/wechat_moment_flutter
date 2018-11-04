import 'dart:convert' show json;
import 'comment_model.dart';
import 'image_model.dart';
import 'sender_model.dart';

class TweetModel{
  String content;
  List<CommentModel> comments;
  List<ImageModel> images;
  SenderModel sender;

  TweetModel.fromParams({this.content,this.comments,this.images,this.sender});

  TweetModel.fromJson(jsonRes){
    this.content = jsonRes['content'];
    this.sender = jsonRes['sender'] == null ? null : new SenderModel.fromJson(jsonRes['sender']);

    var imagesData = jsonRes['images'] == null ? null : jsonRes['images'];

    images = jsonRes['images'] == null ? null : [];
    for (var imagesItem in imagesData == null ? [] : imagesData){
      this.images.add(imagesItem == null ? null : new ImageModel.fromJson(imagesItem));
    }

    var commentsData = jsonRes['comments'] == null ? null : jsonRes['comments'];
    comments = jsonRes['comments'] == null ? null : [];
    for (var commentsItem in commentsData == null ? [] : commentsData){
      this.comments.add(commentsItem == null ? null : new CommentModel.fromJson(commentsItem));
    }
  }

  @override
  String toString() {
    return '{"content": ${content != null?'${json.encode(content)}':'null'},"comments": $comments,"images": $images,"sender": $sender}';
  }
}