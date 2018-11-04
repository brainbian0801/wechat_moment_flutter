import 'dart:convert' show json;

class SenderModel{
  String avatar;
  String nick;
  String username;

  SenderModel.fromParams({this.avatar,this.nick,this.username});

  SenderModel.fromJson(jsonResponse){
    this.avatar = jsonResponse['avatar'];
    this.nick = jsonResponse['nick'];
    this.username = jsonResponse['username'];
  }

  @override
  String toString() {

    return '{"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},'
        '"nick": ${nick != null?'${json.encode(nick)}':'null'},'
        '"username": ${username != null?'${json.encode(username)}':'null'}}';
  }
}