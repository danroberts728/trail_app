// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/util/open_hours_methods.dart';
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
}
