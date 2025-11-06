import 'package:intl/intl.dart';

extension IntExtention on int{
  String get dayAndMonthToString{
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);

    return DateFormat("dd\nMMM").format(date);
  }

  String get fullDateWithNameOfMonthToString{
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat("dd MMMM yyyy").format(date);
  }

  String get fullDateWithNumberOfMonthToString{
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat("dd/MM/yyyy").format(date);
  }

  String get timeToString{
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat("h:mm a").format(date);
  }
}