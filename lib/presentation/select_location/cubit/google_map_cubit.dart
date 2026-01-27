import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/domain/mapper/string_mapper.dart';
import 'package:evently/presentation/select_location/cubit/google_map_contract.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class GoogleMapCubit
    extends BaseCubit<GoogleMapState, GoogleMapAction, GoogleMapNavigation> {
  GoogleMapCubit(this.setupCubit) : super(GoogleMapState());

  final SetupCubit setupCubit;

  @override
  Future<void> doAction(GoogleMapAction action) async {
    switch (action) {
      case LoadGoogleMapStyle():
        {
          _loadGoogleMapStyle();
        }
      case GetPermissionOfLocation():
        _getPermissionOfLocation();
      case GoToCurrentLocation():
        _goToCurrentLocation(action.googleMapController);
      case TabToSelectLocation():
        _selectLocation(action.location);
    }
  }

  void _loadGoogleMapStyle() async {
    emit(state.copyWith(isLoading: true));

    if (setupCubit.state.mode == ThemeMode.dark) {
      String? googleMapAsset = await rootBundle.loadString(
        AssetsConstant.googleMapDarkModeAsset,
      );
      emit(state.copyWith(googleMapStyle: googleMapAsset));
    }
    emit(state.copyWith(isLoading: false));
  }

  void _getPermissionOfLocation() async {
    emit(state.copyWith(isLoading: true, currentLocation: null));
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      Position currentLocation = await GeolocatorPlatform.instance
          .getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.medium,
            ),
          );
      emit(
        state.copyWith(
          isGranted: true,
          currentLocation: LatLng(
            currentLocation.latitude,
            currentLocation.longitude,
          ),
        ),
      );
    } else {
      emitNavigation(
        ShowDialog(
          "We need the access of location to show your current location on the map",
        ),
      );
      emit(
        state.copyWith(
          isGranted: false,
          currentLocation: LatLng(30.068693157980046, 31.200270121519395),
        ),
      );
    }
    emit(state.copyWith(isLoading: false));
  }

  void _goToCurrentLocation(GoogleMapController googleMapController) async {
    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: state.currentLocation!, zoom: 14),
      ),
    );
  }

  void _selectLocation(LatLng selectedLocation) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    String address = StringMapper.convertPlaceMarkToValidAddress(placemarks.first);
    emit(state.copyWith(selectedLocation: address, latLngOfSelectedLocation: selectedLocation));
    emitNavigation(NavigateToEventManagementScreen());
  }


}
