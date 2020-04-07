import 'dart:math';

import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';

const double topOffset = 5;

/**
 * 视图渲染器
 */
class QCalendarRender {
  /**
   * 渲染月视图数据
   */
  void render(
      Canvas canvas, Size size, QCalHolder model, List<Week> monthDate) {
    canvas.save();
    // 获取焦点所在周索引位置
    int focusIndexOfWeek = -1;
    for (int i = 0; i < WEEK_IN_MONTH; i++) {
      Week week = monthDate[i];
      if (week.hasDate(model.focusDateTime)) {
        focusIndexOfWeek = i;
        break;
      }
    }
    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, size.height), paintWeekBgDef);
    double itemHeight = max(size.height / WEEK_IN_MONTH, model.minHeight);
    double offsetTop = min(0, size.height - model.centerHeight);
    canvas.translate(0, offsetTop - itemHeight);
    int firstVisibleItem = max(0, offsetTop.abs() ~/ itemHeight);
    // print(
    //     "======translate: first:${firstVisibleItem}, ${focusIndexOfWeek}, ${model.centerHeight}=${size} (${((focusIndexOfWeek - 5) * itemHeight)} :: ${offsetTop}, ${model.fullHeight}");
    // 循环绘制每周视图数据
    canvas.translate(0, firstVisibleItem * itemHeight);
    for (int i = firstVisibleItem; i < WEEK_IN_MONTH; i++) {
      canvas.translate(0, itemHeight);
      if (i == focusIndexOfWeek) continue;
      Week week = monthDate[i];
      renderWeek(canvas, Size(size.width, itemHeight), model, week);
    }

    if (focusIndexOfWeek > -1) {
      canvas.translate(0,
          max((focusIndexOfWeek - 5) * itemHeight, itemHeight - size.height));

      // 绘制焦点日期所在 周末数据
      Week week = monthDate[focusIndexOfWeek];
      canvas.drawRect(
          Rect.fromLTRB(0, 0, size.width, itemHeight), paintWeekBgDef);
      renderWeek(canvas, Size(size.width, itemHeight), model, week);
    }
    canvas.restore();

    if (model.mode == Mode.DETAIL && size.height >= model.fullHeight) {
      for (int i = firstVisibleItem; i < WEEK_IN_MONTH; i++) {
        canvas.drawLine(Offset(0, i * itemHeight),
            Offset(size.width, i * itemHeight), paintWeekBgDetail);
      }
      double itemWidth = size.width / DAYS_PERWEEK;
      for (int i = 0; i < DAYS_PERWEEK; i++) {
        canvas.drawLine(Offset(i * itemWidth, 0),
            Offset(i * itemWidth, size.height), paintWeekBgDetail);
      }
    }
  }

  _renderWeekWithPos() {}

  final Paint paintWeekBgDef = Paint()..color = Colors.cyan;

  final Paint paintWeekBgDetail = Paint()
    ..color = Colors.blueAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Paint weekBgPaint(QCalHolder model, Week week) {
    switch (model.mode) {
      case Mode.DETAIL:
        return paintWeekBgDetail;
        break;
      default:
        return paintWeekBgDef;
    }
  }

  /**
   * 周视图渲染
   */
  void renderWeek(Canvas canvas, Size weekSize, QCalHolder model, Week week) {
    final double itemWidth = weekSize.width / DAYS_PERWEEK;
    for (Date date in week.dates) {
      renderDate(canvas, Size(itemWidth, weekSize.height), model, date);
      canvas.translate(itemWidth, 0);
    }
    canvas.translate(-weekSize.width, 0);
  }

  final Paint dateFocusCirclePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = 1
    ..isAntiAlias = true;
  final Paint dateTodayCirclePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..isAntiAlias = true;
  final TextPainter dateTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;
  TextStyle dateTextStyle = TextStyle(color: Colors.black);

  double circleSize(Size size) {
    return size.width * 0.55;
  }

  double topMargin() {
    return topOffset;
  }

  Paint focusCirclePaint() {
    return dateFocusCirclePaint;
  }

  Paint todayCirclePaint() {
    return dateTodayCirclePaint;
  }

  TextStyle normalTextStyle() {
    return dateTextStyle;
  }

  TextSpan createTextSpan(Date date, QCalHolder model,
      {bool isFocus = false, bool isToday = false}) {
    if (isFocus) {
      return TextSpan(
          text: date.date.toString(), style: TextStyle(color: Colors.black));
    }
    return TextSpan(text: date.date.toString(), style: normalTextStyle());
  }

  /**
   * 日期对应视图渲染
   */
  void renderDate(Canvas canvas, Size size, QCalHolder model, Date date) {
    // print("")
    if (model.focusDateTime.isEquals(date)) {
      final double cirSize = circleSize(size);
      dateTextPainter.text = createTextSpan(date, model, isFocus: true);
      dateTextPainter.layout();
      canvas.drawOval(
          Rect.fromCenter(
              width: cirSize,
              height: cirSize,
              center:
                  Offset(size.width / 2, topMargin() + dateTextPainter.height)),
          focusCirclePaint());
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    } else if (date.isToday()) {
      final double cirSize = circleSize(size);
      dateTextPainter.text = createTextSpan(date, model, isToday: true);
      dateTextPainter.layout();
      canvas.drawOval(
          Rect.fromCenter(
              width: cirSize,
              height: cirSize,
              center:
                  Offset(size.width / 2, topMargin() + dateTextPainter.height)),
          todayCirclePaint());
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    } else {
      dateTextPainter.text = createTextSpan(date, model);
      dateTextPainter.layout();
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    }
  }
}
