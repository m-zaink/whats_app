extension XInt on int {
  String get toSecondsAndMinutes {
    final numberOfMinutes = this ~/ 60;
    final numberOfSeconds = this % 60;

    if (numberOfMinutes < 10) {
      if (numberOfSeconds < 10) {
        return '0$numberOfMinutes:0$numberOfSeconds'; //
      } else {
        return '0$numberOfMinutes:$numberOfSeconds'; //
      }
    } else {
      if (numberOfSeconds < 10) {
        return '$numberOfMinutes:0$numberOfSeconds'; //
      } else {
        return '$numberOfMinutes:$numberOfSeconds'; //
      }
    }
  }
}
