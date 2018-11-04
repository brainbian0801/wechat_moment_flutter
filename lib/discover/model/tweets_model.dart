import 'tweet_model.dart';
import 'dart:convert' show json;

class TweetsModel {

  List<TweetModel> list;

  TweetsModel.fromParams({this.list});

  factory TweetsModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TweetsModel.fromJson(json.decode(jsonStr)) : new TweetsModel.fromJson(jsonStr);

  TweetsModel.fromJson(jsonRes) {
    var data = jsonRes == null ? null : json.decode(jsonRes);

    list = jsonRes == null ? null : [];
    for(var tweet in data){
      TweetModel tm = TweetModel.fromJson(tweet);
      if(tm == null || (tm.content == null && tm.images == null)){
        continue;
      }else {
        this.list.add(tm);
      }
    }
  }


@override
  String toString() {
    return '{"json_list": $list}';
  }
}