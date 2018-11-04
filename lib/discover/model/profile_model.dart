import 'dart:convert';

class ProfileModel{

  String profileImage;
  String avatar;
  String nick;
  String userName;

  ProfileModel.fromParams({this.profileImage,this.avatar,this.nick,this.userName});

  ProfileModel.fromJson(jsonRes){
    var jsonData = json.decode(jsonRes);
    this.profileImage = jsonData['profile-image'] != null ? jsonData['profile-image'] : null;
    this.avatar = jsonData['avatar'] != null ? jsonData['avatar'] : null;
    this.nick = jsonData['nick'] != null ? jsonData['nick'] : null;
    this.userName = jsonData['username'] != null ? jsonData['username'] : null;
  }

  @override
  String toString() {
    return '{"profile": ${profileImage != null?'${json.encode(profileImage)}':'null'},'
        '"nick": ${nick != null?'${json.encode(nick)}':'null'},'
        '"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},'
        '"username": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}