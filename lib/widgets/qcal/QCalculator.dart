import 'dart:math';
import 'dart:ui';

import 'QCalHolder.dart';
import 'QCalModel.dart';

class QCalculator {
  // @override
  static List<Week> generate(Date date) {
    // DateTime start =DateTime.now();
    DateTime firstDateInMon = DateTime(date.year, date.month, 1);
    int offset2FirstWeekDay =
        (firstDateInMon.weekday + DAYS_PERWEEK - firstDayInWeek) % DAYS_PERWEEK;
    DateTime firstDate =
        firstDateInMon.subtract(Duration(days: offset2FirstWeekDay));
    List<Week> monthDate = [];
    for (int weekIndex = 0; weekIndex < WEEK_IN_MONTH; weekIndex++) {
      Week week = Week();
      for (int dayIndex = 0; dayIndex < DAYS_PERWEEK; dayIndex++) {
        week.add(
            Date.from(firstDate.add(Duration(days: weekIndex * 7 + dayIndex))));
      }
      monthDate.add(week);
    }
    // print(
    //     "generateMonthDate: ${date}, ${firstDateInMon.weekday}, offset: ${offset2FirstWeekDay}, ${firstDate}");
    // print(
    //     "generateMonthDate: ${date}, ${DateTime.now().difference(start).inMilliseconds} ms");
    return monthDate;
  }

  static Date offsetMonthTo(Date baseDate, int offset) {
    // int offsetYear = (offset + baseDate.month) ~/ MAX_MONTH;
    // int offsetMonth = ((offset + baseDate.month + MAX_MONTH) % MAX_MONTH).toInt() + 1;
    // int toYear = baseDate.year + offsetYear;
    // int toMonth = offsetMonth;
    // if (toMonth > MAX_MONTH+1) {
    //   toMonth -= MAX_MONTH +1;
    // }
    DateTime toMonthMaxDate =
        DateTime(baseDate.year, baseDate.month + offset + 1, 1)
            .subtract(Duration(days: 1));
    // Date date = ;
    // print(
    //     "\n\n ++++++++++offsetMonthTo:: ${offset}, ${baseDate} ， ${toMonthMaxDate} => ${date}");
    return Date.from(DateTime(baseDate.year, baseDate.month + offset,
        min(toMonthMaxDate.day, baseDate.date)));
  }

  static Date offsetWeekTo(Date date, int offset) {
    return Date.from(
        date.toDateTime().add(Duration(days: offset * DAYS_PERWEEK)));
  }

  static Date calcFocusDateByOffset(
      Offset offset, Size size, QCalHolder model, List<Week> weeks) {
    int focusIndexOfWeek = -1;
    for (int i = 0; i < WEEK_IN_MONTH; i++) {
      Week week = weeks[i];
      if (week.hasDate(model.focusDateTime)) {
        focusIndexOfWeek = i;
        break;
      }
    }
    int indexDay = offset.dx ~/ (size.width / DAYS_PERWEEK);
    int indexWeek = focusIndexOfWeek;
    switch (model.mode) {
      case Mode.WEEK:
        break;
      default:
        indexWeek = offset.dy ~/ (size.height / WEEK_IN_MONTH);
    }
    return weeks[indexWeek].dates[indexDay];
  }

  static Date calcFocusDate(
      Offset offset, Size size, QCalHolder model, List<Week> weeks) {
    int focusIndexOfWeek = 0;
    for (int i = 0; i < WEEK_IN_MONTH; i++) {
      Week week = weeks[i];
      if (week.hasDate(model.focusDateTime)) {
        focusIndexOfWeek = i;
        break;
      }
    }
    int indexDay = offset.dx ~/ (size.width / DAYS_PERWEEK);
    int indexWeek = focusIndexOfWeek;
    switch (model.mode) {
      case Mode.WEEK:
        break;
      default:
        indexWeek = offset.dy ~/ (size.height / WEEK_IN_MONTH);
    }
    return weeks[indexWeek].dates[indexDay];
  }
}
