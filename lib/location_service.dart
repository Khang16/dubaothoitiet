import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Thành phố không được cấp quyền truy cập vị trí',
          StrutStyle.fromTextStyle(TextStyle(fontSize: 20, color: Colors.black))
              as StackTrace?);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Thành phố không được cấp quyền truy cập vị trí',
            StrutStyle.fromTextStyle(
                TextStyle(fontSize: 20, color: Colors.black)) as StackTrace?);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Thành phố không được cấp quyền truy cập vị trí vĩnh viễn',
          StrutStyle.fromTextStyle(TextStyle(fontSize: 20, color: Colors.black))
              as StackTrace?);
    }

    return await Geolocator.getCurrentPosition();
  }
}
