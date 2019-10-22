import 'dart:math';

import 'const.dart';

class GeoMethods {
  static const _R = 3958.756; // in miles
  
  static double calculateDistance(Point point1, Point point2) {
    if(point1 == null || point2 == null) {
      return null;
    }
    double dLat = _toRadians(point1.x - point2.x);
    double dLon = _toRadians(point1.y - point2.y);
    double lat1 = _toRadians(point2.x);
    double lat2 = _toRadians(point1.x);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return _R * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static String toFriendlyDistanceString(double d) {
    // In checkin distance, show 0
    if (d == null) {
      return '';
    }
    if (d < Constants.options.minDistanceToCheckin) 
      return 0.toString();
    // Greater than 10, just round to nearest int
    else if (d >= 10) 
      return d.round().toString();
    // Greater than 1, round to nearest 0.1
    else if (d >= 1)
      return d.toStringAsFixed(1);
    // Less than 1, round to nearest 0.01
    else
      return d.toStringAsFixed(2);
  }
}