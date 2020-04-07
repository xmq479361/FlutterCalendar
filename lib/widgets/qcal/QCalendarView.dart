import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';
import 'QCalculator.dart';
import 'QCalendarPainter.dart';
import 'QCalendarRender.dart';

typedef RebuildView = void Function();

class QCalendarView extends StatefulWidget {
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  RebuildView rebuildView;
  QCalendarView(this.pos, this.mModel, this.render, this.rebuildView);
  @override
  _QCalendarViewState createState() => _QCalendarViewState();
}

class _QCalendarViewState extends State<QCalendarView> {
  GlobalKey containerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) {
          Offset offset = details.localPosition;
          print("  >>>onTapUp ${containerKey.currentContext.size}. $offset");
          Date focusDate = QCalculator.calcFocusDateByOffset(
              offset,
              containerKey.currentContext.size,
              widget.mModel,
              QCalculator.generate(widget.mModel.getDateTime(widget.pos)));
          if (widget.mModel.focusDateTime.isEquals(focusDate)) return;
          widget.mModel.focusDate(context, focusDate);
          widget.rebuildView();
        },
        child: Container(
            height: double.infinity,
            key: containerKey,
            child: CustomPaint(
                painter: QCalendarPainter(
                    context, widget.pos, widget.mModel, widget.render))));
  }
}
