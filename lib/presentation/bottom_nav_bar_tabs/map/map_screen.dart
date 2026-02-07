import 'package:evently/core/di/di.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:evently/presentation/select_location/cubit/google_map_contract.dart';
import 'package:evently/presentation/select_location/cubit/google_map_cubit.dart';
import 'package:evently/presentation/widgets/event_map_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final HomeCubit homeCubit = getIt();
  final GoogleMapCubit googleMapCubit = getIt();
  GoogleMapController? googleMapController;

  @override
  void initState() {
    super.initState();
    homeCubit.doAction(GetEvents(homeCubit.state.categoriesList[0].id));
    googleMapCubit.doAction(LoadGoogleMapStyle());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: googleMapCubit),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder:
            (_, state) =>
                state.events.data == null
                    ? Center(child: CircularProgressIndicator())
                    : state.events.data!.isEmpty ? Center(child: Text(context.locale!.noEventToShow),) : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GoogleMap(
                          style: googleMapCubit.state.googleMapStyle,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(state.events.data![0].latitude, state.events.data![0].longitude),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                          },
                          markers:
                              state.events.data!
                                  .map(
                                    (event) => Marker(
                                      markerId: MarkerId("Marker ${event.id}"),
                                      position: LatLng(
                                        event.latitude,
                                        event.longitude,
                                      ),
                                    ),
                                  )
                                  .toSet(),
                        ),
                        SizedBox(
                          height: context.heightSize * 0.15,
                          child: ListView.separated(
                            padding: EdgeInsets.all(8),
                            itemBuilder:
                                (context, index) => InkWell(
                                  onTap: () {
                                    googleMapController!.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(
                                            homeCubit
                                                .state
                                                .events
                                                .data![index]
                                                .latitude,
                                            homeCubit
                                                .state
                                                .events
                                                .data![index]
                                                .longitude,
                                          ),
                                          zoom: 14,
                                        ),
                                      ),
                                    );
                                  },
                                  child: EventMapItem(
                                    event: state.events.data![index],

                                  ),
                                ),
                            separatorBuilder:
                                (context, index) => 10.horizontalSpace,
                            itemCount: state.events.data!.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
      ),
    );
  }
}
