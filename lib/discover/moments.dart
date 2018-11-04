import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'model/profile_model.dart';
import 'model/tweets_model.dart';
import 'model/tweet_model.dart';
import 'model/image_model.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';



class MomentListPage extends StatefulWidget{

  @override
  createState() => new MomentListPageState();

}

class MomentListPageState extends State<MomentListPage>{

  List<TweetModel> mDatas;//显示在页面中的数据
  List<TweetModel> mDataAll;//总数据
  ProfileModel mProfileData;
  double screenWidth;//屏幕宽度
  RefreshController _refreshController;
  int _mTotalPage;//根据JSON返回的数据计算每次显示5条，一共分几页，TODO:实际业务中要考虑重新加载的数据，或者在后台Server端实现此逻辑
  int _currentPage;


  @override
  Widget build(BuildContext context){
    // 获取屏幕宽度
    screenWidth = MediaQuery.of(context).size.width;
    return new Container(
      child: new SmartRefresher(
          child: ListView.builder(
        itemBuilder: (context,i) => renderRow(i),
        itemCount: mDatas == null ? 0 :mDatas.length*2  + 1),
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onOffsetChange: _onOffsetCallback,
        onRefresh: (up){
          onRefreshTweet(up);
        }
      ),
    );
  }

  onRefreshTweet(bool up){
    if(up){
      new Future.delayed(const Duration(milliseconds: 2000))
          .then((val) {
        _refreshController.scrollTo(_refreshController.scrollController.offset+100.0);
        _refreshController.sendBack(true, RefreshStatus.idle);
        //refresh data
        setState(() {
          _currentPage = 1;
          mDatas = mDataAll.sublist(0,5);
        });
      });
    }else{
      new Future.delayed(const Duration(milliseconds: 2000))
          .then((val) {
        setState(() {
          if(_currentPage + 1 > _mTotalPage){
            //TODO:no more data
            _refreshController.sendBack(false,RefreshStatus.noMore);
          }else{
            _currentPage++;
            if(_currentPage != _mTotalPage){
              mDatas.addAll(mDataAll.sublist((_currentPage - 1) * 5, _currentPage * 5));
            }else{
              mDatas.addAll(mDataAll.sublist((_currentPage - 1) * 5, mDataAll.length));
            }
          }
          _refreshController.sendBack(false,RefreshStatus.completed);
        });
        _refreshController.sendBack(false, RefreshStatus.idle);
      });
    }
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
  }

  renderRow(i){
    if(i == 0){
      //背景和头像
      return backgroundAndProfile(mDatas[i]);
    }else{
      --i;
      if(i.isOdd){
        return new Divider(
          height: 1.0,
        );
      }else{
        i = i ~/ 2;
        return getRowWidget(mDatas[i]);
      }
    }
  }
  
  Widget getRowWidget(TweetModel tweetData){
    //一共两大列，第一列为头像
    var tweetHead = new Container(
      alignment: Alignment.topLeft,
      //TODO:need change to tweetData.sender.avatar
      //child: getHeadWidget(tweetData.sender.avatar,45.0,45.0),
      child: getHeadWidget('http://img.my.csdn.net/uploads/201407/26/1406383299_1976.jpg',45.0,45.0),
    );

    //第二列为4行分别为：网名，内容，图像，评论
    var tweetNickContentPicComm = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //网名
        new Padding(padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 0.0),
          child: new Text(tweetData.sender.nick,
              style: new TextStyle(fontSize: 16.0)),
        ),
        new Padding(padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 0.0),
          child: new Text(tweetData.content == null ? '' : tweetData.content,
              style: new TextStyle(fontSize: 16.0)),
        ),
        //图像
        calcPic(tweetData)
      ],
    );

    var tweetsTable = new Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        new TableRow(children: <Widget>[
          new Padding(padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
            child: tweetHead,
          ),
          tweetNickContentPicComm
        ])
      ],
      columnWidths: const <int,TableColumnWidth>{
        0:FixedColumnWidth(60.0)
      },
    );
    return tweetsTable;
  }

  Widget calcPic(TweetModel tweetData){
    List<Widget> _imgList = [];//九宫格
    List<ImageModel> _images = tweetData.images;
    num len = _images == null ? 0 : _images.length;
    List<List<Widget>> rows = [];
    // 通过双重for循环，生成每一张图片组件
    for (var row = 0; row < getRow(len); row++) { // row表示九宫格的行数，可能有1行2行或3行
      List<Widget> rowArr = [];
      for (var col = 0; col < 3; col++) { // col为列数，固定有3列
        num index = row * 3 + col;
        double cellWidth = (screenWidth - 100) / 3;
        if (index < len) {
          rowArr.add(new Padding(
            padding: const EdgeInsets.all(2.0),
            //TODO:image url needs change _images[index]
            child: new Image.network('http://img.my.csdn.net/uploads/201407/26/1406383299_1976.jpg',
              //child: new Image.network(_images[index],
                width: cellWidth, height: cellWidth),
          ));
        }
      }
      rows.add(rowArr);
    }
    for (var row in rows) {
      _imgList.add(new Row(
        children: row,
      ));
    }

    return new Padding(padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 20.0),
      child: new Column(
        children: _imgList,
      ),
    );
  }

  //背景图片及头像
  Widget backgroundAndProfile(TweetModel tweetModel){
    var avatarContainer = new Container(
      height: 220.0,//背景图片的高度
      child: new Stack(
        alignment:  const Alignment(1.0, 1.2),
        children: <Widget>[
//          new Image.network(tweetModel.sender.avatar,
          new Image.network('http://img.my.csdn.net/uploads/201407/26/1406383299_1976.jpg',
            fit: BoxFit.fill ,
            width: screenWidth,
          ),
          new Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                    child: new Text(mProfileData.nick == null ? 'Default Nick' : mProfileData.nick,
                      style: new TextStyle(color: Colors.white,fontSize: 16.0),
                    ),
                  )
                  ,
                  mProfileData.profileImage == null ? new Image.asset('images/ic_avatar_default.png',width: 60.0)
                  //: getHeadWidget(mProfileData.profileImage,60.0,60.0)//TODO:needs change available resource
                      :getHeadWidget('http://img.my.csdn.net/uploads/201407/26/1406383299_1976.jpg',60.0,60.0)
                ],
              ),
          ),
        ],
      ),
    );
    return new GestureDetector(
      onTap: (){
        //点击头像后到新路由
        //TODO:click head icon jump new route
      },
      child: avatarContainer,
    );
  }

  // 获取行数，n表示图片的张数
  int getRow(int n) {
    int a = n % 3;
    int b = n ~/ 3;
    if (a != 0) {
      return b + 1;
    }
    return b;
  }

  //头像widget
  Widget getHeadWidget(String avatarUrl,num avatarWidth,num avatarHeight){
    return new Container(
      width: avatarWidth,
      height: avatarHeight,
      decoration: new BoxDecoration(
        //头像显示为矩形
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        image: new DecorationImage(
          image: new NetworkImage(avatarUrl),
          fit: BoxFit.cover),
        //头像边框
        border: new Border.all(
          color: Colors.white,
          width: 2.0
        )
      ),
    );
  }

  //打开当前界面就加载数据
  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    getTweetsList();
  }

  //加载整个朋友圈列表信息
  getTweetsList() async{
    var _tweetsData = [];
    var _profileData;
    //async表示异步操作
    var httpClient = new HttpClient();
    final tweetsUrl = 'http://qiniu.gysjsj.com/homework/tweets.json';
    var request = await httpClient.getUrl(Uri.parse(tweetsUrl));
    var response = await request.close();
    if(response.statusCode == HttpStatus.ok){
      var jsonData = await response.transform(utf8.decoder).join();
      _tweetsData = TweetsModel.fromJson(jsonData.toString()).list;
    }

    final profileUrl = 'http://qiniu.gysjsj.com/homework/jsmith.json';
    request = await httpClient.getUrl(Uri.parse(profileUrl));
    response = await request.close();
    if(response.statusCode == HttpStatus.ok){
      var jsonData = await response.transform(utf8.decoder).join();
      _profileData = ProfileModel.fromJson(jsonData.toString());
    }

    setState(() {
      //更新Widget
      _currentPage = 1;
      mDataAll = _tweetsData;
      _mTotalPage = _tweetsData.length % 5 != 0 ? _tweetsData.length~/5 + 1 : _tweetsData.length~/5;
      mDatas = mDataAll.sublist(0,5);
      mProfileData = _profileData;
    });
  }
}









