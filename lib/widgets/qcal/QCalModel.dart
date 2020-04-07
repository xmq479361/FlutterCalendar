const int MAX_MONTH = 12;
const int DAYS_PERWEEK = 7;
const int WEEK_IN_MONTH = 6;
const int firstDayInWeek = DateTime.monday;

class Date {
  int year, month, date;

  DateTime toDateTime() => DateTime(year, month, date);

  Date(this.year, this.month, this.date);
  Date.from(DateTime dateTime)
      : this(dateTime.year, dateTime.month, dateTime.day);

  @override
  String toString() => "$year-$month-$date";

  bool isBefore(Date date) =>
      date == null || toDateTime().isBefore(date.toDateTime());
  bool isAfter(Date date) =>
      date == null || toDateTime().isAfter(date.toDateTime());
  bool isEquals(Date dates) =>
      dates != null &&
      date == dates.date &&
      month == dates.month &&
      year == dates.year;

  bool isToday() => isEquals(Date.from(DateTime.now()));
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
