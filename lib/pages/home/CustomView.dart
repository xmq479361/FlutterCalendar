import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_scroll/pages/home/Model.dart';

class CustomView extends StatefulWidget {
  CalendarModel mModel;
  int pos;
  CustomView(this.pos, this.mModel);
  @override
  _CustomViewState createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  // _onPageChanged(page) {
  //   offsetPage += page - 1;
  //   print("page ${page}, ${offsetPage}");
  //   onPageChange(page);
  //   // _pageController.jumpToPage(1);
  // }

  @override
  void dispose() {
    super.dispose();
    print("    CustomView dispose(${widget.pos})");
  }

  @override
  void initState() {
    super.initState();
  }

  GlobalKey containerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(
        "     build:: ${widget.mModel.getDateTime(widget.pos)} ${widget.pos} ");
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) {
          Offset offset = details.localPosition;
          print(">>>onTapUp ${containerKey.currentContext.size}. $offset");
          List<Week> _currDates = DateGenerator.generateMonthDate(
              Date.from(widget.mModel.getDateTime(widget.pos)));
          // _painter.onPressed(details.localPosition);
          int focusIndexOfWeek = -1;
          for (int i = 0; i < 6; i++) {
            Week week = _currDates[i];
            if (week.hasDate(widget.mModel.focusDateTime)) {
              // print("week hasDate: ${model.focusDateTime}, $i");
              focusIndexOfWeek = i;
              break;
            }
          }
          int indexDay =
              (offset.dx / (containerKey.currentContext.size.width / 7))
                  .toInt();
          int indexWeek = focusIndexOfWeek;
          switch (widget.mModel.mode) {
            case Mode.WEEK:
              break;
            default:
              indexWeek =
                  (offset.dy / (containerKey.currentContext.size.height / 6))
                      .toInt();
          }
          widget.mModel.focusDate(_currDates[indexWeek].dates[indexDay]);
          setState(() {});
        },
        child: Container(
            height: double.infinity,
            key: containerKey,
            child: CustomPaint(
                painter: CustomXPainter(widget.pos, widget.mModel))));
  }
}

class CustomXPainter extends CustomPainter {
  TextPainter textPainter = TextPainter()..textDirection = TextDirection.ltr;
  CalendarModel mModel;
  int pos;
  CalendarRender render = CalendarRender();
  CustomXPainter(this.pos, this.mModel);
  @override
  void paint(Canvas canvas, Size size) {
    DateTime dateTIme = mModel.getDateTime(pos);
    _currDates = DateGenerator.generateMonthDate(Date.from(dateTIme));
    _curSize = size;
    print("     paint:: ${Date.from(dateTIme)} =>${_currDates}");
    canvas.save();
    render.render(canvas, size, mModel, _currDates);
    canvas.restore();
    textPainter.text = TextSpan(
        text:
            "paint(${mModel.mode}) ${size}, ${pos}, ${dateTIme.year}-${dateTIme.month}-${dateTIme.day}",
        style: TextStyle(color: Colors.white));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            size.width - textPainter.width, size.height - textPainter.height));

    // print(
    //     "    CustomXPainter paint:  ${size}, pos:${pos} == ${dateTIme}");
  }

  @override
  bool shouldRepaint(CustomXPainter oldDelegate) => true;

  Size _curSize;
  List<Week> _currDates;
  onPressed(Offset offset) {
    double itemHeight = max(_curSize.height / 6, mModel.minHeight);
    double offsetTop = _curSize.height - mModel.centerHeight;
    int focusIndexOfWeek = 0;
    for (int i = 0; i < 6; i++) {
      Week week = _currDates[i];
      if (week.hasDate(mModel.focusDateTime)) {
        // print("week hasDate: ${model.focusDateTime}, $i");
        focusIndexOfWeek = i;
        break;
      }
    }
    int indexDay = (offset.dx / (_curSize.width / 7)).toInt();
    int indexWeek = focusIndexOfWeek;
    switch (mModel.mode) {
      case Mode.WEEK:
        break;
      default:
        indexWeek = (offset.dy / (_curSize.height / 6)).toInt();
    }
    print(
        "onPressed::: ${offset}, ${mModel.mode}, ${itemHeight} ${offsetTop}, ${focusIndexOfWeek} ${indexDay}");

    mModel.focusDate(_currDates[indexWeek].dates[indexDay]);
  }
}

class CalendarRender {
  void render(Canvas canvas, Size size, CalendarModel model,
      List<Week> generateMonthDate) {
    double itemHeight = max(size.height / 6, model.minHeight);

    double offsetTop = size.height - model.centerHeight;
    int focusIndexOfWeek = -1;
    if (offsetTop > 0) {}
    for (int i = 0; i < 6; i++) {
      Week week = generateMonthDate[i];
      if (week.hasDate(model.focusDateTime)) {
        // print("week hasDate: ${model.focusDateTime}, $i");
        focusIndexOfWeek = i;
        break;
      }
    }

    if (offsetTop > 0) offsetTop = 0;

    canvas.translate(0, offsetTop - itemHeight);
    double offsetWithIndex = ((focusIndexOfWeek - 5) * itemHeight);
    double offsetTrans = -size.height + itemHeight;
    if (offsetWithIndex < offsetTrans) offsetWithIndex = offsetTrans;
    print(
        "======translate: ${offsetWithIndex}, ${offsetTrans}, ${focusIndexOfWeek}, ${model.centerHeight}=${size} (${((focusIndexOfWeek - 5) * itemHeight)} :: ${offsetTop}");
    for (int i = 0; i < 6; i++) {
      canvas.translate(0, itemHeight);
      Week week = generateMonthDate[i];
      if (i == focusIndexOfWeek) continue;
      renderWeek(canvas, Size(size.width, itemHeight), model, week);
    }
    // offsetWithIndex = offsetTrans;
    if (focusIndexOfWeek == -1) return;
    Week week = generateMonthDate[focusIndexOfWeek];
    canvas.translate(0, offsetWithIndex);
    renderWeek(canvas, Size(size.width, itemHeight), model, week);
  }

  Paint painter = Paint()..color = Colors.cyan;
  void renderWeek(
      Canvas canvas, Size weekSize, CalendarModel model, Week week) {
    double itemWidth = weekSize.width / 7;
    canvas.save();
    canvas.drawRect(
        Rect.fromLTRB(0, 0, weekSize.width, weekSize.height), painter);
    for (Date date in week.dates) {
      renderDate(canvas, Size(itemWidth, weekSize.height), model, date);
      canvas.translate(itemWidth, 0);
    }
    canvas.restore();
  }

  Paint dateCirclePainter = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = 1
    ..isAntiAlias = true;
  TextPainter dateTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;
  void renderDate(Canvas canvas, Size size, CalendarModel model, Date date) {
    // print(
    //     "renderDate: ${mModel.focusDateTime} == ${date}, ${mModel.focusDateTime.isEquals(date)} == ${mModel.focusDateTime.date == date.date}  && ${mModel.focusDateTime.month == date.month} && ${mModel.focusDateTime.year == date.year}");
    if (model.focusDateTime.isEquals(date)) {
      double circleSize = size.width * 0.55;
      // canvas.drawOval(
      // Rect.fromLTRB(
      //     offset, offset, offset + circleSize, offset + circleSize),
      // dateCirclePainter);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: circleSize,
              height: circleSize),
          dateCirclePainter);
      dateTextPainter.text =
          TextSpan(text: "${date.date}", style: TextStyle(color: Colors.cyan));
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
