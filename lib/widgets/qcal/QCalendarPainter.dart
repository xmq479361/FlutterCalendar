import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';
import 'QCalculator.dart';
import 'QCalendarRender.dart';

class QCalendarPainter extends CustomPainter {
  TextPainter textPainter = TextPainter()..textDirection = TextDirection.ltr;
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  final BuildContext context;
  QCalendarPainter(this.context, this.pos, this.mModel, this.render);
  @override
  void paint(Canvas canvas, Size size) {
    final Date date = mModel.getDateTime(pos);
    if (render != null){
      // var now = DateTime.now();
      render.render(canvas, size, mModel, QCalculator.generate(date));
      // print("     paint:: ${date} =>${pos} ${DateTime.now().difference(now).inMilliseconds} ms");
    }
    textPainter.text = TextSpan(
        text: "paint(${mModel.mode}), ${date}",
        style: TextStyle(color: Colors.white));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            size.width - textPainter.width, size.height - textPainter.height));
  }

  @override
  bool shouldRepaint(QCalendarPainter oldDelegate) {
    // print("      QCalendarPainter:::shouldRepaint: ${pos} == ${oldDelegate.pos}");
    // return pos != oldDelegate.pos || mModel.mode == oldDelegate.mo;
    return true;
  }
}
