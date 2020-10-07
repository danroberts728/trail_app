import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';

class TrailPlaceHoursAreaBloc extends Bloc {
  bool isOpenNow(List<Map<String,dynamic>> hours) {
    return OpenHoursMethods.isOpenNow(hours);
  } 

  String getStatusString(List<Map<String, dynamic>> hours) {
    String status = "Closed today";
    if (OpenHoursMethods.isOpenNow(hours)) {
      status = "Open until " + OpenHoursMethods.nextOpenString(hours);
    } else if (OpenHoursMethods.isOpenLaterToday(hours)) {
      status = "Open today at " +
          OpenHoursMethods.nextOpenString(hours, includeDay: false);
    } else {
      status = "Open " + OpenHoursMethods.nextOpenString(hours);
    }

    return status;
  }

  @override
  void dispose() {}
}
