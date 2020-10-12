const List<String> _googleWeekdays = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
];

const List<String> _iso8601WeekDays = [
  'filler',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

DateTime get _now {
  return DateTime.now().toLocal();
}

String get _nowDayIso8601 {
  return _iso8601WeekDays[_now.weekday];
}

class OpenHoursMethods {
  static String convertMilitaryTime(String time) {
    String amPm = "AM";
    int milTime = int.tryParse(time);
    int civTime = milTime;
    if(milTime >= 1200) {
      // PM if 1200 or later
      amPm = "PM";
    }
    if (milTime >= 1300) {
      // Convert to civilian PM times if after 1259
      civTime = milTime - 1200;
    }
    if(milTime == 0) {
      // If midnight, make it 1200
      civTime = 1200;
    }

    String hour = civTime.toString().padLeft(4, '0').substring(0, 2);
    String minute = civTime.toString().padLeft(4, '0').substring(2);

    if(hour[0] == "0") {
      // Remove leading zero
      hour = hour[1];
    }

    return hour + ":" + minute + " " + amPm;
  }

  /// Returns true if [hours] shows that it is currently open
  static bool isOpenNow(List<Map<String, dynamic>> hours) {
    bool retval = false;
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601);
    var nowTime = _now.hour * 100 + _now.minute;
    for (int i = 0; i < hours.length; i++) {
      Map<String, dynamic> value = hours[i];
      int openDay = value['open']['day'];
      int openTime = int.tryParse(value['open']['time']);
      int closeDay = value['close']['day'];
      int closeDayCalc = closeDay;
      if (closeDay < nowDayGoogle) {
        // This has wrapped around to next week
        closeDayCalc = closeDay + 7;
      }
      int closeTime = int.tryParse(value['close']['time']);

      bool afterOpenDay = nowDayGoogle >= openDay;
      bool beforeCloseDay = nowDayGoogle <= closeDayCalc;
      bool afterOpenTime = nowDayGoogle >= openDay && nowTime >= openTime;
      bool beforeCloseTime = (nowDayGoogle == closeDayCalc && nowTime <= closeTime)
        || (nowDayGoogle <= closeDayCalc);

      if (afterOpenDay && afterOpenTime && beforeCloseDay && beforeCloseTime) {
        retval = true;
        break;
      }
    }
    return retval;
  }

  /// Returns true if [hours] shows that it open at some time today but in the future
  static bool isOpenLaterToday(List<Map<String, dynamic>> hours) {
    bool retval = false;
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601);
    var nowTime = _now.hour * 100 + _now.minute;
    for (int i = 0; i < hours.length; i++) {
      Map<String, dynamic> value = hours[i];
      int openDay = value['open']['day'];
      int openTime = int.tryParse(value['open']['time']);
      int closeDay = value['close']['day'];
      int closeDayCalc = closeDay;
      if (closeDay < nowDayGoogle) {
        // This has wrapped around to next week
        closeDayCalc = closeDay + 7;
      }

      bool afterOpenDay = nowDayGoogle >= openDay;
      bool beforeCloseDay = nowDayGoogle <= closeDayCalc;
      bool beforeOpenTime = afterOpenDay && beforeCloseDay && nowTime < openTime; 

      if (afterOpenDay && beforeCloseDay && beforeOpenTime) {
        retval = true;
        break;
      }
    }
    return retval;
  }

  /// Returns a string for the next closing time from DateTime.now() for [hours]
  /// Format example: Tuesday at 10:00 PM
  static String nextCloseString(List<Map<String, dynamic>> hours, {bool includeDay = true}) {
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601);
    var nowTime = _now.hour * 100 + _now.minute;
    int nextDay = 100;
    int nextDayCalc = 100;
    int nextTime = 100000;
    // Get the close time closest (but after) now
    for (int i = 0; i < hours.length; i++) {
      Map<String, dynamic> value = hours[i];
      int closeDay = value['close']['day'];
      int closeDayCalc = closeDay;
      int closeTime = int.tryParse(value['close']['time']);
      if (closeDay < nowDayGoogle) {
        // This has wrapped around to next week
        closeDayCalc = closeDay + 7;
      }

      // See if this is sooner than the current
      if (closeDayCalc - nowDayGoogle == nextDayCalc - nowDayGoogle &&
          closeTime - nowTime < nextTime - nowTime) {
        // Same day but earlier time
        nextDay = closeDay;
        nextDayCalc = closeDayCalc;
        nextTime = closeTime;
      } else if (closeDayCalc - nowDayGoogle < nextDayCalc - nowDayGoogle) {
        // Earlier Day
        nextDay = closeDay;
        nextDayCalc = closeDayCalc;
        nextTime = closeTime;
      }
    }
    String nextDayString = _googleWeekdays[nextDay][0].toUpperCase() +
        _googleWeekdays[nextDay].substring(1);

    return includeDay
      ? nextDayString +
        " at " +
        OpenHoursMethods.convertMilitaryTime(nextTime.toString())
      : OpenHoursMethods.convertMilitaryTime(nextTime.toString());
  }

  /// Returns a string for the next open time from DateTime.now() for [hours]
  /// Format example: Tuesday at 2:00 PM
  static String nextOpenString(List<Map<String, dynamic>> hours, {bool includeDay = true}) {
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601);
    var nowTime = _now.hour * 100 + _now.minute;
    int nextDay = 100;
    int nextDayCalc = 100;
    int nextTime = 100000;
    // Get the next-highest open day
    for (int i = 0; i < hours.length; i++) {
      Map<String, dynamic> value = hours[i];
      int openDay = value['open']['day'];
      int openDayCalc = openDay;
      int openTime = int.tryParse(value['open']['time']);
      if (openDay < nowDayGoogle) {
        // This has wrapped around to next week
        openDayCalc = openDay + 7;
      }

      // See if this is sooner than the current
      if (openDayCalc - nowDayGoogle == nextDayCalc - nowDayGoogle &&
          openTime - nowTime < nextTime - nowTime) {
        // Same day but earlier time
        nextDay = openDay;
        nextDayCalc = openDayCalc;
        nextTime = openTime;
      } else if (openDayCalc - nowDayGoogle < nextDayCalc - nowDayGoogle) {
        // Earlier Day
        nextDay = openDay;
        nextDayCalc = openDayCalc;
        nextTime = openTime;
      }
    }
    String nextDayString = _googleWeekdays[nextDay][0].toUpperCase() +
        _googleWeekdays[nextDay].substring(1);

    return includeDay
      ? nextDayString +
        " at " +
        OpenHoursMethods.convertMilitaryTime(nextTime.toString())
      : OpenHoursMethods.convertMilitaryTime(nextTime.toString());
  }
}
