import 'package:evently/core/di/di.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/presentation/select_location/cubit/google_map_contract.dart';
import 'package:evently/presentation/select_location/cubit/google_map_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  GoogleMapController? _controller;

  GoogleMapCubit googleMapCubit = getIt();

  @override
  void initState() {
    super.initState();
    googleMapCubit.doAction(LoadGoogleMapStyle());
    googleMapCubit.doAction(GetPermissionOfLocation());
    googleMapCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case ShowDialog():
          {
            AppDialogs.actionDialog(
              context: context,
              title: "Location Permission",
              content: navigationState.message,
              posActionTitle: "Allow",
              posAction: () {
                googleMapCubit.doAction(GetPermissionOfLocation());
              },
              negActionTitle: "Cancel",
            );
          }
        case NavigateToEventManagementScreen():
          {
            Navigator.pop(context);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: googleMapCubit,
      child: BlocBuilder<GoogleMapCubit, GoogleMapState>(
        builder:
            (_, state) => Scaffold(
              body:
                  state.isLoading || state.currentLocation == null
                      ? Center(child: CircularProgressIndicator())
                      : GoogleMap(
                        onTap: (position) {
                          googleMapCubit.doAction(TabToSelectLocation(position));
                        },
                        style: state.googleMapStyle,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: state.currentLocation!,
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                    markers: {
                          Marker(
                        markerId: MarkerId("My location"),
                        position: state.currentLocation!,
                          ),
                    },
                      ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: context.heightSize * 0.07,
                color: AppColors.purple,
                child: Text(
                  "Tap on location to select",
                  style: context.textStyle.titleMedium!.copyWith(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (state.isGranted!) {
                    googleMapCubit.doAction(GoToCurrentLocation(_controller!));
                  } else {
                    googleMapCubit.doAction(GetPermissionOfLocation());
                  }
                },
                child: Icon(Icons.my_location_outlined, size: 26),
              ),
            ),
      ),
    );
  }
}
