import 'dart:ui';

import 'package:flutter/material.dart';

import 'QCalModel.dart';
import 'QCalNotification.dart';
import 'QCalculator.dart';

typedef DateTime CalcDateTime(int offset);
enum Mode { WEEK, MONTH, DETAIL }

const int maxSize = 200;
const int offsetMid = maxSize >> 1;

class QCalHolder {
  Mode mode;
  int currPage = offsetMid;
  double fullHeight, centerHeight, minHeight = 50;

  QCalHolder({this.mode = Mode.WEEK}) {
    fullHeight = window.physicalSize.height / window.devicePixelRatio;
  }

  focusDateByPage(BuildContext context,int page) {
    Date _focusDateTime = getDateTime(page);
    // print("focusDateByPage: ${page}/${currPage}, ${mode}, ${focusDateTime} = ${_focusDateTime}");
    focusDateTime = _focusDateTime;
    currPage = page;
    QCalNotification.dispatchTo(context, this);
  }

  focusDate(BuildContext context,Date date) {
    // print("focusDate: ${date}/${currPage}, ${mode}, ${focusDateTime} ");
    focusDateTime = date;
    QCalNotification.dispatchTo(context, this);
  }

  Date focusDateTime = Date.from(DateTime.now());
  // Date focusDateTime = Date.from(DateTime(2020, 4, 20));

  Date getDateTime(int offs) {
    int offset = offs - currPage;
    // print("  ===getDateTime($mode): ${offset}, ${focusDateTime}");
    switch (mode) {
      case Mode.WEEK:
        return QCalculator.offsetWeekTo(focusDateTime, offset);
      default:
        return QCalculator.offsetMonthTo(focusDateTime, offset);
    }
  }
}
