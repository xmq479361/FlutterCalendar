import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'CustomView.dart';
import 'Model.dart';

mixin CalendarWidgetMixin<T extends StatefulWidget> on State<T> {
  initState() {
    if (_model == null) _model = CalendarModel(mode: Mode.WEEK);
    print("CalendarWidgetMixin initState");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // //获取position
      RenderBox box = containerKey.currentContext.findRenderObject();
      Offset offset = box.localToGlobal(Offset.zero);
      print(
          "CalendarWidgetMixin endOfFrame: ${box.size},  ${offset}, ${box.paintBounds}");
      _model.fullHeight = box.size.height;
      _model.minHeight = max(45, box.size.height / 3 / 6);
      _model.centerHeight = _model.minHeight * 6;
      setState(() {});
      modifyMode() ;
      // _pageController.jumpToPage(1);
      // RenderBox boxSliver = sliverHeaderKey.currentContext.findRenderObject();
      // Offset offsetSliver = boxSliver.localToGlobal(Offset.zero);
      //     print(
      //         "CalendarWidgetMixin endOfFrame: ${boxSliver.size}, ${offsetSliver} ");
    });
  }

  final GlobalKey containerKey = GlobalKey();
  CalendarModel _model;

  _onPageChanged(page) {
    _model.focusDateByPage(page);
    setState(() {
      
    });
    // onPageChange(page);
    // _pageController.jumpToPage(1);
  }

  sliverHeader({
    CalendarModel model,
    pinned = true,
  }) {
    if (model == null) model = _model;
    this._model = model;
    print("CalendarWidgetMixin sliverHeader ${model}");

    return SliverPersistentHeader(
      delegate: CustomSliverHeaderDelegate(
          model: model, onPageChange: _onPageChanged),
      pinned: pinned,
    );
  }

  ScrollController _scrollController;
  customScrollView(ScrollController _scrollController, CustomScrollView child) {
    this._scrollController = _scrollController;
    return NotificationListener<OverscrollNotification>(
        onNotification: (OverscrollNotification notification) {
          checkModifyMode(notification);
        },
        child: NotificationListener<ScrollEndNotification>(
            onNotification: (ScrollEndNotification notification) {
              if (checkModifyMode(notification)) modifyMode();
            },
            child: Container(
              child: child,
              height: double.infinity,
              key: containerKey,
            )));
  }

  modifyMode() {
    switch (_model.mode) {
      case Mode.MONTH:
        _scroll(_model.fullHeight - _model.centerHeight);
        break;
      case Mode.WEEK:
        _scroll(_model.fullHeight - _model.minHeight);
        break;
      case Mode.DETAIL:
      default:
        _scroll(-(_scrollController.offset));
    }
  }

  Timer _timer;
  _scroll(offset) {
    print("_scroll: ${offset}");
    // setState(() {});
    if (_timer != null) _timer.cancel();
    _timer = Timer(Duration(milliseconds: 20), () {
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    });
  }

  bool checkModifyMode(ScrollNotification notification) {
    print('------------------------');
    // print("ScrollEndNotification: ${notification}");
    if (notification.depth != 0) return false;
    ScrollMetrics metrics = notification.metrics;
    // print(metrics.pixels); // 当前位置
    // print("是否在顶部或底部: ${metrics.atEdge}"); //是否在顶部或底部
    // print(metrics.axis); //垂直或水平滚动
    // print(metrics.axisDirection); // 滚动方向是down还是up
    // print(metrics.extentAfter); //视口底部距离列表底部有多大
    print(
        "offset: ${metrics.extentBefore}, ${_scrollController.offset}"); //视口顶部距离列表顶部有多大
    print("列表长度: ${metrics.extentInside}"); //视口范围内的列表长度

    // print(metrics.maxScrollExtent); //最大滚动距离，列表长度-视口长度
    // print(
    //     "最小滚动距离: ${metrics.minScrollExtent} -- ${metrics.maxScrollExtent}"); //最小滚动距离
    // print(metrics.viewportDimension); //视口长度
    // print(metrics.outOfRange); //是否越过边界
    double offsets = (_model.fullHeight - _model.minHeight);
    int offset2Top = (_model.fullHeight - metrics.extentBefore).abs().toInt();
    int offset2Center =
        (_model.centerHeight - metrics.extentBefore).abs().toInt();
    int offset2Detail = (metrics.extentBefore).abs().toInt();
    Mode mode;
    if (offset2Top < offset2Center) {
      mode = offset2Top < offset2Detail ? Mode.WEEK : Mode.DETAIL;
    } else {
      // 0 ~ (fullHeight - minHeight)
      // Detail -> Month -> Week
      // (fullHeight - minHeight) ~ 0
      mode = offset2Center < offset2Detail ? Mode.MONTH : Mode.DETAIL;
    }
    print(
        "${offsets}::: offset2Top: ${offset2Top}, offset2Center: ${offset2Center}, offset2Detail: ${offset2Detail} == ${mode} ");
    if (_model.mode != mode) {
      _model.mode = mode;
      setState(() {});
    }

    if (metrics.extentBefore > offsets) return false;
    return true;
  }
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  CalendarModel model;
  ValueChanged<int> onPageChange;
  PageController _pageController;
  CustomSliverHeaderDelegate({this.model, this.onPageChange}) {
    _pageController = PageController(initialPage: offsetMid);
    if (model == null) model = CalendarModel(mode: Mode.WEEK);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return PageView.builder(
        itemCount: maxSize,
        controller: _pageController,
        physics: ClampingScrollPhysics(),
        onPageChanged: onPageChange,
        itemBuilder: (context, pos) => CustomView(pos, model));
  }

  @override
  double get maxExtent => model.fullHeight;

  @override
  double get minExtent => model.minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
