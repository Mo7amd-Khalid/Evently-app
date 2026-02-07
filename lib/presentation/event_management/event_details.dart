import 'package:evently/core/di/di.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/presentation/event_management/cubit/event_contract.dart';
import 'package:evently/presentation/event_management/cubit/event_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:evently/core/utils/int_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';

class EventDetails extends StatefulWidget {
  EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final SetupCubit setupCubit = getIt();
  final EventCubit eventCubit = getIt();

  @override
  void initState() {
    super.initState();
    eventCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case NavigateToMapScreen():
        case NavigateToHomeScreen():
          Navigator.pushReplacementNamed(context, Routes.main);
        case ShowLoadingDialog():
          AppDialogs.loadingDialog(
            context: context,
            loadingMessage: context.locale!.loading,
          );
        case ShowInfoDialog():
          AppDialogs.actionDialog(
            context: context,
            content: navigationState.message,
            posActionTitle: context.locale!.ok,
            posAction: () {
              eventCubit.doAction(GoToHomeScreen());
            },
          );
        case ShowErrorDialog():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EventDM event = ModalRoute.of(context)!.settings.arguments as EventDM;

    return BlocProvider.value(
      value: eventCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.locale!.eventDetails),
          centerTitle: true,
          actions: [
            //Edit Icon
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, Routes.editEvent, arguments: event);
              },
              icon: Icon(Icons.edit_outlined),
            ),
            //Delete Icon
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AppDialogs.actionDialog(
                  context: context,
                  title: context.locale!.deleteEvent,
                  content: context.locale!.deleteEventConfirmation,
                  posActionTitle: context.locale!.yes,
                  posAction: () {
                    eventCubit.doAction(DeleteEvent(event.id));
                  },
                  negActionTitle: context.locale!.no,
                );
              },
              icon: Icon(Icons.delete_outline_outlined, color: Colors.red),
            ),
          ],
          actionsPadding: EdgeInsets.zero,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 360 / 200,
                child: Image.asset(event.category.image),
              ),
            ),
            10.verticalSpace,
            Text(
              event.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 24),
            ),
            10.verticalSpace,
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(padding: EdgeInsets.all(8)),
              child: Row(
                spacing: 5,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    width: MediaQuery.sizeOf(context).width * 0.11,
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.date.fullDateWithNameOfMonthToString,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        event.time.timeToString,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color:
                              setupCubit.state.mode == ThemeMode.dark
                                  ? AppColors.white
                                  : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            10.verticalSpace,
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(padding: EdgeInsets.all(8)),
              child: Row(
                spacing: 5,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    width: MediaQuery.sizeOf(context).width * 0.11,
                    child: Icon(
                      Icons.my_location_outlined,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      event.address,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            10.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: context.heightSize * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(event.latitude, event.longitude),
                    zoom: 16
                  ),
                  markers: {
                    Marker(markerId: MarkerId(event.id), position: LatLng(event.latitude, event.longitude))
                  },
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              context.locale!.description,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(fontSize: 16),
            ),
            10.verticalSpace,
            Text(
              event.description,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
