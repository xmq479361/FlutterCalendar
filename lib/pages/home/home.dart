import 'package:flutter/material.dart';
import '../../widgets/qcal/QCalNotification.dart';
import '../../widgets/qcal/QCalHolder.dart';
import '../../widgets/qcal/QCalModel.dart';
import '../../widgets/qcal/QCalendarRender.dart';
import '../../widgets/qcal/QCalendarWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// class MyTitleInherted extends InheritedWidget {
//   Date date = Date.from(DateTime.now());
//   @override
//   bool updateShouldNotify(MyTitleInherted oldWidget) {
//     return !date.isEquals(oldWidget.date);
//   }
// }

class MyTitleInheritedContainer extends InheritedWidget {
  Date date = Date.from(DateTime.now());
  MyTitleInheritedContainer({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(MyTitleInheritedContainer oldWidget) {
    print(" ======updateShouldNotify(${date})=> ${oldWidget.date}");
    return !date.isEquals(oldWidget.date);
  }

  static MyTitleInheritedContainer of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<MyTitleInheritedContainer>()
        as MyTitleInheritedContainer;
  }

  update(Date date) {
    print(" ======update(${this.date})=> ${date}");
    date = date;
  }
}

// class TitleView extends StatefulWidget {
//   @override
//   _TitleViewState createState() => _TitleViewState();
// }

// class _TitleViewState extends State<TitleView> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     MyTitleInheritedContainer.of(context).date
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
class TitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MyTitle(this.text);
    MyTitleInheritedContainer container = MyTitleInheritedContainer.of(context);
    return Text(container.date.toString());
  }
}

class _HomePageState extends State<HomePage>
    with QCalendarWidgetMixin<HomePage> {
  ScrollController _scrollController;
  String focusDateTime = Date.from(DateTime.now()).toString();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  final Key scrollViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return
        // MyTitleInheritedContainer(
        //     child:

        Scaffold(
            appBar: AppBar(
                // title: Container(child: TitleView()),
                title: Container(child: Text(focusDateTime)),
                centerTitle: false,
                leading: Icon(Icons.arrow_back_ios)),
            backgroundColor: Colors.cyan,
            body: SafeArea(
                top: false,
                bottom: false,
                child: Container(
                    //   child: LayoutBuilder(builder: (context, constraint) {
                    // return
                    child: NotificationListener<QCalNotification>(
                        onNotification: (QCalNotification notification) {
                          print(
                              "QCalNotification: ${notification.model.focusDateTime}");
                          focusDateTime =
                              notification.model.focusDateTime.toString();
                          // MyTitleInheritedContainer.of(context)
                          //     .update(notification.model.focusDateTime);
                          setState(() {});
                        },
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
                                sliverHeader(
                                    // render: MyQCalendarRender()
                                    ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return new Container(
                                      height: 85,
                                      alignment: Alignment.center,
                                      color: Colors
                                          .lightBlue[100 * ((index % 9) + 1)],
                                      child: new Text(
                                          'item($index) ${studys[index]}'),
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
                            ))))));
  }
}

class MyQCalendarRender extends QCalendarRender {
  Paint dateCirclePainter = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = 1
    ..isAntiAlias = true;
  TextPainter dateTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;
  @override
  void renderDate(Canvas canvas, Size size, QCalHolder model, Date date) {
    if (model.focusDateTime.isEquals(date)) {
      double circleSize = size.width * 0.55;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: circleSize,
              height: circleSize),
          dateCirclePainter);
      dateTextPainter.text = TextSpan(
          text: "${date.date}", style: TextStyle(color: Colors.blueAccent));
    } else {
      dateTextPainter.text =
          TextSpan(text: "${date.date}", style: TextStyle(color: Colors.white));
    }
    dateTextPainter.layout();
    dateTextPainter.paint(
        canvas,
        Offset((size.width - dateTextPainter.width) / 2,
            (size.height - dateTextPainter.height) / 2));
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
