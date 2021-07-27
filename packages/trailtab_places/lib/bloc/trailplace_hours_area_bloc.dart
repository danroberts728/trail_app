import 'package:trailtab_places/util/open_hours_methods.dart';

class TrailPlaceHoursAreaBloc {
  bool isOpenNow(List<Map<String,dynamic>> hours) {
    return OpenHoursMethods.isOpenNow(hours, DateTime.now());
  } 

  String getStatusString(List<Map<String, dynamic>> hours) {
    DateTime now = DateTime.now();
    String status = "Closed today";
    if (OpenHoursMethods.isOpenNow(hours, now)) {
      status = "Open until " + OpenHoursMethods.nextCloseString(hours, now, includeDay: false);
    } else if (OpenHoursMethods.isOpenLaterToday(hours, now)) {
      status = "Open today at " +
          OpenHoursMethods.nextOpenString(hours, now, includeDay: false);
    } else {
      status = "Open " + OpenHoursMethods.nextOpenString(hours, now);
    }

    return status;
  }
}
