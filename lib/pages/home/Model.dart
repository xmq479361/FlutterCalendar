import 'dart:math';

import 'dart:ui';

typedef DateTime CalcDateTime(int offset);
enum Mode { WEEK, MONTH, DETAIL }

class Date {
  int year, month, date;

  DateTime toDateTime() => DateTime(year, month, date);

  Date(this.year, this.month, this.date);
  Date.from(DateTime dateTime)
      : this(dateTime.year, dateTime.month, dateTime.day);

  @override
  String toString() => "$year-$month-$date";

  bool isBefore(Date date) => toDateTime().isBefore(date.toDateTime());
  bool isAfter(Date date) => toDateTime().isAfter(date.toDateTime());
  bool isEquals(Date dates) =>
      date == dates.date && month == dates.month && year == dates.year;
}

class Week {
  List<Date> dates = [];
  Week({this.dates});
  Date first() {
    return dates[0];
  }

  Date last() {
    return dates[dates.length - 1];
  }

  add(Date date) {
    if (dates == null) dates = [];
    dates.add(date);
  }

  hasDate(Date date) {
    return !first().isAfter(date) && !last().isBefore(date);
  }
}

int firstDayInWeek = DateTime.monday;

class DateGenerator {
  static List<Week> generateMonthDate(Date date) {
    // DateTime dateTime = date.toDateTime();
    DateTime firstDateInMonth = DateTime(date.year, date.month, 1);
    int offset2FirstWeekDay =
        (firstDateInMonth.weekday + DateTime.daysPerWeek - firstDayInWeek) %
            DateTime.daysPerWeek;
    DateTime firstDate =
        firstDateInMonth.subtract(Duration(days: offset2FirstWeekDay));
    print(
        "generateMonthDate: ${date}, ${firstDateInMonth.weekday}, offset: ${offset2FirstWeekDay}, ${firstDate}");
    List<Week> monthDate = [];
    for (int weekIndex = 0; weekIndex < 6; weekIndex++) {
      Week week = Week();
      for (int dayIndex = 0; dayIndex < DateTime.daysPerWeek; dayIndex++) {
        Date date =
            Date.from(firstDate.add(Duration(days: weekIndex * 7 + dayIndex)));
        // print("generateMonthDate week: ${week.dates}, date: ${date}");
        week.add(date);
        // week.add(date);
      }
      monthDate.add(week);
    }
    return monthDate;
  }

  static Week generateWeekDate(Date date) {}
}

class CalendarModel {
  // CalcDateTime calcDateTime;
  // Date selectDateTime = Date.from(DateTime.now());
  DateTime pageDateTime;
  Mode mode;
  int currPage = offsetMid;
  CalendarModel({this.mode = Mode.WEEK}) {
    fullHeight = window.physicalSize.height / window.devicePixelRatio;
    print(
        "fullHeight: ${fullHeight}, ${window.physicalSize.height}, ${window.physicalSize.aspectRatio} ${window.devicePixelRatio}");
  }
  focusDateByPage(int page) {
    Date _focusDateTime = Date.from(getDateTime(page));
    print(
        "focusDateByPage: ${page}/${currPage}, ${mode}, ${focusDateTime} = ${_focusDateTime}");
    focusDateTime = _focusDateTime;
    currPage = page;
  }

  focusDate(Date date) {
    print("focusDate: ${date}/${currPage}, ${mode}, ${focusDateTime} ");
    focusDateTime = date;
  }

  // Date focusDateTime = Date.from(DateTime.now());
  Date focusDateTime = Date.from(DateTime(2020, 4, 20));

  DateTime getDateTime(int offs) {
    int offset = offs - currPage;
    print("getDateTime($mode): ${offset}, ${focusDateTime}");
    switch (mode) {
      case Mode.WEEK:
        return getDateTimeByWeek(focusDateTime, offset);
      default:
        return getDateTimeByMonth(focusDateTime, offset);
    }
  }

  static CalendarModel from() => CalendarModel();

  double fullHeight, centerHeight, minHeight = 50;
}

int maxSize = 1000;
int offsetMid = maxSize >> 1;

// DateTime baseDate = DateTime.now();
int maxMonth = 12;
DateTime getDateTimeByMonth(baseDate, offset) {
  // int month = baseDate.month;
  int offsetYear = (offset / maxMonth).toInt();
  int offsetMonth = (offset % maxMonth).toInt();
  int toYear = baseDate.year + offsetYear;
  int toMonth = baseDate.month + offsetMonth;
  if (toMonth > maxMonth) {
    toYear++;
    toMonth -= 12;
  }
  DateTime toMonthFirstDate = DateTime(toYear, toMonth, 1);
  DateTime toMonthMaxDate =
      DateTime(toYear, toMonth + 1, 1).subtract(Duration(days: 1));
  print(
      "    toMonthFirstDate: $toMonthFirstDate, toMonthMaxDate ${toMonthMaxDate}");
  // int nextMonth = toMonthFirstDate.

  print(
      "getDateTime: $offset, ${toYear}, ${toMonth}, ${baseDate.date} == ${toMonthMaxDate.day}");
  // baseDate.add(Duration(m))
  return DateTime(toYear, toMonth, min(toMonthMaxDate.day, baseDate.date));
}

DateTime getDateTimeByWeek(baseDate, offs) {
  return baseDate.toDateTime().add(Duration(days: offs * 7));
}
