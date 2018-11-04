import 'dart:convert' show json;

class ImageModel{
  String url;

  ImageModel.fromParams({this.url});

  ImageModel.fromJson(jsonRes){
    this.url = jsonRes['url'];
  }

  @override
  String toString() {

    return '{"url":${url != null ? '${json.encode(url)}' : 'null'}}';
  }
}