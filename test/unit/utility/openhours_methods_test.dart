// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/util/open_hours_methods.dart';
import 'package:test/test.dart';

List<Map<String, dynamic>> testHours = [
  { // Sunday 1 PM - 10 PM
    'close': <String, dynamic>{
      'day': 0,
      'time': "2200"
    },
    'open': <String, dynamic>{
      'day': 0,
      'time': "1300",
    },
  },
  // Closed Monday
  { // Tuesday 12 PM - 10 PM
    'close': <String, dynamic>{
      'day': 2,
      'time': "2200"
    },
    'open': <String, dynamic>{
      'day': 2,
      'time': "1200",
    },
  },
  { // Wednesday 12 PM - 10 PM
    'close': <String, dynamic>{
      'day': 3,
      'time': "2200"
    },
    'open': <String, dynamic>{
      'day': 3,
      'time': "1200",
    },
  },
  { // Thursday 12 PM - 11 PM
    'close': <String, dynamic>{
      'day': 4,
      'time': "2300"
    },
    'open': <String, dynamic>{
      'day': 4,
      'time': "1200",
    },
  },
  { // Friday 12 PM - Saturday 12 AM
    'close': <String, dynamic>{
      'day': 6,
      'time': "0000"
    },
    'open': <String, dynamic>{
      'day': 5,
      'time': "1200",
    },
  },
  { // Saturday 12 PM - Sunday 2 AM
    'close': <String, dynamic>{
      'day': 0,
      'time': "0200"
    },
    'open': <String, dynamic>{
      'day': 6,
      'time': "1200",
    },
  },
];

/// Tests for the OpenHours utility class
main() {
  group('convertMilitaryTime', () {
    test('Before Noon', () {
      String time = "0800";
      String converted = OpenHoursMethods.convertMilitaryTime(time);
      expect(converted, "8:00 AM");
    });

    test('Between Noon and 1 PM', () {
      String time = "1203";
      String converted = OpenHoursMethods.convertMilitaryTime(time);
      expect(converted, "12:03 PM");
    });

    test('After 1 PM', () {
      String time = "1533";
      String converted = OpenHoursMethods.convertMilitaryTime(time);
      expect(converted, "3:33 PM");
    });

    test('Midnight', () {
      String time = "0000";
      String converted = OpenHoursMethods.convertMilitaryTime(time);
      expect(converted, "12:00 AM");
    });

    test('Between midnight and 1 AM', () {
      String time = "0004";
      String converted = OpenHoursMethods.convertMilitaryTime(time);
      expect(converted, "12:04 AM");
    });
  });

  group('isOpenNow', () {
    test("Simple yes", () {
      DateTime now = DateTime.parse("2020-10-14 13:27:00"); // Wed at 1:27 PM
      bool isOpen = OpenHoursMethods.isOpenNow(testHours, now);
      expect(isOpen, true);
    });
    test("Simple no - too early", () {
      DateTime now = DateTime.parse("2020-10-14 11:27:00"); // Wed at 11:27 AM
      bool isOpen = OpenHoursMethods.isOpenNow(testHours, now);
      expect(isOpen, false);
    });
    test("Simple no - too late", () {
      DateTime now = DateTime.parse("2020-10-14 22:27:00"); // Wed at 10:27 PM
      bool isOpen = OpenHoursMethods.isOpenNow(testHours, now);
      expect(isOpen, false);
    });
    test("Open after midnight", () {
      DateTime now = DateTime.parse("2020-10-18 00:27:00"); // Sun at 12:27 AM
      bool isOpen = OpenHoursMethods.isOpenNow(testHours, now);
      expect(isOpen, true);
    });
    test('Not open after midnight', () {
      DateTime now = DateTime.parse("2020-10-17 00:27:00"); // Sat at 12:01 AM
      bool isOpen = OpenHoursMethods.isOpenNow(testHours, now);
      expect(isOpen, false);
    });
  });

  group('isOpenToday', () {
    test('Open later today', () {
      DateTime now = DateTime.parse("2020-10-22 08:27:00"); // Thu at 8:27 AM
      bool isOpenToday = OpenHoursMethods.isOpenToday(testHours, now);
      expect(isOpenToday, true);
    });
    test('Open now', () {
      DateTime now = DateTime.parse("2020-10-20 18:42:00"); // Tue at 6:42 PM
      bool isOpenToday = OpenHoursMethods.isOpenToday(testHours, now);
      expect(isOpenToday, true);
    });
    test('Open earlier today', () {
      DateTime now = DateTime.parse("2020-10-22 23:15:00"); // Thu at 11:15 PM
      bool isOpenToday = OpenHoursMethods.isOpenToday(testHours, now);
      expect(isOpenToday, true);
    });
    test('Closed today', () {
      DateTime now = DateTime.parse("2020-10-19 18:15:00"); // Mon at 6:15 PM
      bool isOpenToday = OpenHoursMethods.isOpenToday(testHours, now);
      expect(isOpenToday, false);
    });
  });

  group('isOpenLaterToday', () {
    test('Open Later today', () {
      DateTime now = DateTime.parse("2020-10-22 08:27:00"); // Thu at 8:27 AM
      bool isOpenToday = OpenHoursMethods.isOpenLaterToday(testHours, now);
      expect(isOpenToday, true);
    });
    test('Open now', () {
      DateTime now = DateTime.parse("2020-10-20 18:42:00"); // Tue at 6:42 PM
      bool isOpenToday = OpenHoursMethods.isOpenLaterToday(testHours, now);
      expect(isOpenToday, false);
    });
    test('Already closed', () {
      DateTime now = DateTime.parse("2020-10-20 23:42:00"); // Tue at 11:42 PM
      bool isOpenToday = OpenHoursMethods.isOpenLaterToday(testHours, now);
      expect(isOpenToday, false);
    });
    test('Closed today', () {
      DateTime now = DateTime.parse("2020-10-19 18:42:00"); // Mon at 6:42 PM
      bool isOpenToday = OpenHoursMethods.isOpenLaterToday(testHours, now);
      expect(isOpenToday, false);
    });
  });

  group('nextOpenString', () {
    test('Next open later today', () {
      DateTime now = DateTime.parse("2020-10-22 08:27:00"); // Thu at 8:27 AM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Thursday at 12:00 PM");
    });

    test('Open now and next open tomorrow', () {
      DateTime now = DateTime.parse("2020-10-20 23:42:00"); // Tue at 11:42 PM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Wednesday at 12:00 PM");
    });

    test('Closed now but next open tomorrow', () {
      DateTime now = DateTime.parse("2020-10-19 08:27:00"); // Mon at 8:27 AM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Tuesday at 12:00 PM");
    });

    test('Open now and next open later in week', () {
      DateTime now = DateTime.parse("2020-10-18 13:30:00"); // Sun at 1:30 PM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Tuesday at 12:00 PM");
    });

    test('Closed now and next open later in week', () {
      DateTime now = DateTime.parse("2020-10-17 23:30:00"); // Sat at 11:30 AM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Sunday at 1:00 PM");
    });

    test('Next open next week', () {
      DateTime now = DateTime.parse("2020-10-17 12:01:00"); // Sat at 12:01 PM
      String result = OpenHoursMethods.nextOpenString(testHours, now);
      expect(result, "Sunday at 1:00 PM");
    });

    test('No day', () {
      DateTime now = DateTime.parse("2020-10-17 12:01:00"); // Sat at 12:01 PM
      String result = OpenHoursMethods.nextOpenString(testHours, now, includeDay: false);
      expect(result, "1:00 PM");
    });
  });

  group('nextCloseString', () {
    test('Not yet open - closes later today', () {
      DateTime now = DateTime.parse("2020-10-18 12:00:00"); // Sun at 10:00 AM
      String result = OpenHoursMethods.nextCloseString(testHours, now);
      expect(result, "Sunday at 10:00 PM");
    });

    test('Not yet open - closes tomorrow', () {
      DateTime now = DateTime.parse("2020-10-17 10:42:00"); // Sat at 10:42 AM
      String result = OpenHoursMethods.nextCloseString(testHours, now);
      expect(result, "Sunday at 2:00 AM");
    });

    test('Closed - closes later in week', () {
      DateTime now = DateTime.parse("2020-10-18 23:27:00"); // Sun at 11:27 AM
      String result = OpenHoursMethods.nextCloseString(testHours, now);
      expect(result, "Tuesday at 10:00 PM");
    });

    test('Open now closes today', () {
      DateTime now = DateTime.parse("2020-10-18 13:30:00"); // Sun at 1:30 PM
      String result = OpenHoursMethods.nextCloseString(testHours, now);
      expect(result, "Sunday at 10:00 PM");
    });

    test('Open now and closes next week', () {
      DateTime now = DateTime.parse("2020-10-17 14:30:00"); // Sat at 2:30 PM
      String result = OpenHoursMethods.nextCloseString(testHours, now);
      expect(result, "Sunday at 2:00 AM");
    });
  });
}
