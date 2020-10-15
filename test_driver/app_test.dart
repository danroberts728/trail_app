import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the Test', () {
    final mainAppBarFinder = find.byValueKey('MainAppBarTitle');

    FlutterDriver driver;

    setUpAll(() async {
      if(Platform.isAndroid) {
        final envVars = Platform.environment;
        final String adbPath = envVars['ANDROID_SDK_ROOT'] + '/platform-tools/adb.exe';
        await Process.run(adbPath, [
          'shell',
          'pm',
          'grant',
          'org.alabamabrewers.albeertrail',
          'android.permission.ACCESS_COARSE_LOCATION',        
        ]);
        await Process.run(adbPath, [
          'shell',
          'pm',
          'grant',
          'org.alabamabrewers.albeertrail',
          'android.permission.ACCESS_FINE_LOCATION',        
        ]);
      }

      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });

    test('Home loads', () async {
      expect(await driver.getText(mainAppBarFinder), "Alabama Beer Trail");
    });

  });
}