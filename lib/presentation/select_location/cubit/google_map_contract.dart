import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapState {
  bool isLoading;
  String? googleMapStyle;
  bool? isGranted;
  LatLng? currentLocation;
  LatLng? latLngOfSelectedLocation;
  String? selectedLocation;

  GoogleMapState({
    this.isLoading = false,
    this.googleMapStyle,
    this.isGranted,
    this.currentLocation,
    this.selectedLocation,
    this.latLngOfSelectedLocation
  });

  GoogleMapState copyWith({
    bool? isLoading,
    String? googleMapStyle,
    bool? isGranted,
    LatLng? currentLocation,
    String? selectedLocation,
    LatLng? latLngOfSelectedLocation
  }) {
    return GoogleMapState(
      isLoading: isLoading ?? this.isLoading,
      googleMapStyle: googleMapStyle ?? this.googleMapStyle,
      isGranted: isGranted ?? this.isGranted,
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      latLngOfSelectedLocation: latLngOfSelectedLocation ?? this.latLngOfSelectedLocation,
    );
  }
}

sealed class GoogleMapAction {}

class GoToCurrentLocation extends GoogleMapAction {
  GoogleMapController googleMapController;

  GoToCurrentLocation(this.googleMapController);
}

class LoadGoogleMapStyle extends GoogleMapAction {}

class GetPermissionOfLocation extends GoogleMapAction {}

class TabToSelectLocation extends GoogleMapAction{
  LatLng location;
  TabToSelectLocation(this.location);
}



sealed class GoogleMapNavigation{}

class ShowDialog extends GoogleMapNavigation{
  String message;
  ShowDialog(this.message);
}

class NavigateToEventManagementScreen extends GoogleMapNavigation{}
