/// Copyright (c) 2021, Fermented Software.

/// A BLoC for the StampedIcon widget
class StampedPlaceIconBloc {
  /// Helper method to get a shortened version of [text]
  ///
  /// The function does not cut off words, so instead of
  /// "Birmingham District Brewi", it will return
  /// "Birmingham District"
  static String getShortText(String text, int maxLength) {
    String retval = "";

    if (text.length < maxLength) {
      retval = text;
    } else {
      for (int i = 0; i < text.length; i++) {
        if (text[i] == ' ' && i < maxLength) {
          retval = text.substring(0, i);
        } else if (text[i] == ' ' && i >= maxLength) {
          break;
        } else {
          continue;
        }
      }
    }

    if (retval.isEmpty) {
      retval = text.substring(0, maxLength - 3) + '...';
    } else if (retval.endsWith('and')) {
      retval = retval.substring(0, retval.length - 4);
    } else if (retval.endsWith('&')) {
      retval = retval.substring(0, retval.length - 2);
    }

    return retval;
  }
}
