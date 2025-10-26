import 'package:intl/intl.dart';

extension IntExtention on int{
  String get dateToString{
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);

    return DateFormat("dd\nMMM").format(date);
  }
}