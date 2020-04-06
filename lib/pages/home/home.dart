import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scroll/pages/home/CalendarWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with CalendarWidgetMixin<HomePage> {
  ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("_HomePageState initState");
    _scrollController = ScrollController();
  }

  // onPageChanged(page) {
  //   print("_HomePage page ${page}");
  //   setState(() {});
  // }
  final Key scrollViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
        ),
        body: SafeArea(
            // bottom: false,
            child: Container(
                child: customScrollView(
                    _scrollController,
                    CustomScrollView(
                      physics: ClampingScrollPhysics(),
                      /* 滑动效果
            * AlwaysScrollableScrollPhysics() 总是可以滑动，默认值
            * NeverScrollableScrollPhysics禁止滚动
            * BouncingScrollPhysics 内容超过一屏 上拉有回弹效果
            * ClampingScrollPhysics 包裹内容 不会有回弹
            */
                      key: scrollViewKey,
                      controller: _scrollController,
                      slivers: <Widget>[
                        sliverHeader(),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return new Container(
                              height: 85,
                              alignment: Alignment.center,
                              color: Colors.lightBlue[100 * ((index % 9) + 1)],
                              child: new Text('item($index) ${studys[index]}'),
                            );
                          }, childCount: studys.length),
                        ),
                        // SliverFillRemaining(
                        //     fillOverscroll: true,
                        //     // child: Padding(
                        //     //     padding: EdgeInsets.only(top: -50),
                        //     child: Container(
                        //         color: Colors.amberAccent,
                        //         child: Text("SliverFillRemaining"))),
                      ],
                    )))));
  }
}

const studys = [
  'android',
  'ios',
  'web',
  'flutter',
  'kotlin',
  'swift',
  'React Native',
  'java',
  'Object-C',
  'PHP'
];
