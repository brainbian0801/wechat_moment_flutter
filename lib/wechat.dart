import 'package:flutter/material.dart';
import 'package:wechat_flutter/discover/moments.dart';

void main() => runApp(new WeChatApp());

class WeChatApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new Scaffold(
        body: new MomentListPage(),
      ),
    );

  }

}