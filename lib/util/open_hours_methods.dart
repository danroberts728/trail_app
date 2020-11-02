// Copyright (c) 2020, Fermented Software.
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

class OpenHoursMethods {
  static String _nowDayIso8601(DateTime now) {
    return _iso8601WeekDays[now.weekday];
  }


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
    if(milTime >= 0 && milTime < 100) {
      // If midnight hour, make it 12xx
      civTime = milTime + 1200;
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
  static bool isOpenNow(List<Map<String, dynamic>> hours, DateTime now) {
    bool isOpenNow = false;    
    
    List<Map<String, dynamic>> matchedPeriods = _getOpenDaysPeriod(hours, now);
    int nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601(now));
    int nowTime = now.hour * 100 + now.minute;

    // We know that all matched periods include today (now day)
    // If there are no matched periods, this logic will be skipped
    // because we know we are not open at all today
    for(int i = 0; i < matchedPeriods.length; i++) {
      Map<String, dynamic> period = matchedPeriods[i];
      int openDay = period['open']['day'];
      int closeDay = period['close']['day'];
      int openTime = int.tryParse(period['open']['time']);
      int closeTime = int.tryParse(period['close']['time']);

      bool afterOpenTime = false;
      if(nowDayGoogle == openDay && nowTime < openTime) {
        // If today is the open day but it is before the
        // open time, then it is not after the open time
        afterOpenTime = false;
      } else {
        // Otherwise, it is after the open time, either
        // because it's after the open time on the open day
        // or because it's another day within the open 
        // period.
        afterOpenTime = true;
      }

      bool beforeCloseTime = false;
      if(nowDayGoogle == closeDay && nowTime > closeTime) {
        // If today is the close day and it's after the
        // close time, then it is not before the close time
        beforeCloseTime = false;
      } else {
        // Otherwise, it is after the close time, either
        // because it's before the close time on the close
        // day or because it's another day within the open
        // period
        beforeCloseTime = true;
      }

      if(afterOpenTime && beforeCloseTime) {
        isOpenNow = true;
        break;
      }
    }
    return isOpenNow;
  }

  /// Returns true if [hours] shows that it open at some time today
  static bool isOpenToday(List<Map<String, dynamic>> hours, DateTime now) {
    return _getOpenDaysPeriod(hours, now).isNotEmpty;
  }

  /// Returns tue if [hours] shows that it is open at some time today but in the future
  static bool isOpenLaterToday(List<Map<String, dynamic>> hours, DateTime now) {
    bool isOpenLaterToday = false;
    List<Map<String, dynamic>> matchedPeriods = _getOpenDaysPeriod(hours, now);
    int nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601(now));
    int nowTime = now.hour * 100 + now.minute;

    // We know that all matched periods include today (now day)
    // If there are no matched periods, this logic will be skipped
    // because we know we are not open at all today
    for(int i = 0; i < matchedPeriods.length; i++) {
      Map<String, dynamic> period = matchedPeriods[i];
      int openDay = period['open']['day'];
      int openTime = int.tryParse(period['open']['time']);

      if(nowDayGoogle == openDay && nowTime < openTime) {
        isOpenLaterToday = true;
        break;
      }
    }
    return isOpenLaterToday;
  }

  /// Gets the open/close periods that that are include the [now] day of the week.
  /// Returns an empty list if no open/close periods match
  static List<Map<String, dynamic>> _getOpenDaysPeriod(List<Map<String,dynamic>> hours, DateTime now) {
    List<Map<String, dynamic>> retval = List<Map<String,dynamic>>();
    int nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601(now));
    for(int i = 0; i < hours.length; i++) {
      Map<String, dynamic> period = hours[i];
      int openDay = period['open']['day'];
      int closeDay = period['close']['day'];

      List<int> openDays = List<int>();
      if(closeDay >= openDay) {
        openDays = List<int>.generate(closeDay - openDay + 1, (i) => openDay + i);
      } else {
        // Wraps around the week
        openDays = List<int>.generate(7 - openDay, (i) => openDay + i)
          + List<int>.generate(closeDay + 1, (i) => closeDay + i);
      }

      if(openDays.contains(nowDayGoogle)) {
        retval.add(period);
      }
    }
    return retval;
  }

  /// Returns a string for the next closing time from DateTime.now() for [hours]
  /// Format example: Tuesday at 10:00 PM
  static String nextCloseString(List<Map<String, dynamic>> hours, DateTime now, {bool includeDay = true}) {
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601(now));
    var nowTime = now.hour * 100 + now.minute;
    int nextDay = 100;
    int nextDayCalc = 100;
    int nextTime = nowTime;
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

      // If there's more than one period and
      // this is the same day and after close time, ignore
      if(hours.length > 1 &&
        closeDay == nowDayGoogle &&
        closeTime <= nowTime) {
          continue;
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
  static String nextOpenString(List<Map<String, dynamic>> hours, DateTime now, {bool includeDay = true}) {
    var nowDayGoogle = _googleWeekdays.indexOf(_nowDayIso8601(now));
    var nowTime = now.hour * 100 + now.minute;
    int nextDay = 100;
    int nextDayCalc = 100;
    int nextTime = nowTime;
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

      // If there's more than one period and
      // this is the same day and after open time, ignore
      if(hours.length > 1 &&
        openDayCalc == nowDayGoogle &&
        openTime <= nowTime) {
          continue;
      }
      // See if this is sooner than the current
      if (openDayCalc - nowDayGoogle == nextDayCalc - nowDayGoogle &&
          openTime - nowTime < nextTime - nowTime) {
        // Same day but earlier time
        nextDay = openDay;
        nextDayCalc = openDayCalc;
        nextTime = openTime;
      } else if (openDayCalc - nowDayGoogle < nextDayCalc - nowDayGoogle) {
        // Earlier day
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
