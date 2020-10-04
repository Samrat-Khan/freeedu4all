class MonthFormat {
  String getMonth(int month) {
    String mon;
    switch (month) {
      case 1:
        mon = "Jan";
        break;
      case 2:
        mon = "Feb";
        break;
      case 3:
        mon = "Mar";
        break;
      case 4:
        mon = "Apr";
        break;
      case 5:
        mon = "May";
        break;
      case 6:
        mon = "Jun";
        break;
      case 7:
        mon = "Jul";
        break;
      case 8:
        mon = "Aug";
        break;
      case 9:
        mon = "Sep";
        break;
      case 10:
        mon = "Oct";
        break;
      case 11:
        mon = "Nov";
        break;
      case 12:
        mon = "Dec";
        break;
    }
    return mon;
  }
}

class MicroToMin {
  int second = 0;
  int min = 0, currentMin = 0;
  int milliSecond = 0, currentMilliSecond = 0;
  int nowMicroSecond = 0, current;
  DateTime dateTime = DateTime.now();
  int minConvert(int microSecond) {
    nowMicroSecond = dateTime.microsecondsSinceEpoch - microSecond;
    milliSecond = nowMicroSecond ~/ 1000;
    second = milliSecond ~/ 1000;
    min = second ~/ 60;
    print(min);
    return min;
  }
}
