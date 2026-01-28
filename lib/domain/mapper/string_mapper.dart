import 'package:geocoding/geocoding.dart';

abstract class StringMapper {
  static bool _isPlusCode(String? text) {
    if (text == null) return false;
    return RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,}$').hasMatch(text);
  }

  static String convertPlaceMarkToValidAddress(Placemark p){
    final street = _isPlusCode(p.street) ? null : p.street;
    return [
      street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
      p.country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

  }
}