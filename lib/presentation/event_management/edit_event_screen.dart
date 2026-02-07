import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/presentation/event_management/cubit/event_contract.dart';
import 'package:evently/presentation/event_management/cubit/event_cubit.dart';
import 'package:evently/presentation/select_location/cubit/google_map_contract.dart';
import 'package:evently/presentation/select_location/cubit/google_map_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:evently/validation/data_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key, required this.event});

  final EventDM event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  EventCubit eventCubit = getIt();
  SetupCubit setupCubit = getIt();
  GoogleMapCubit googleMapCubit = getIt();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? date;
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    googleMapCubit.state.selectedLocation = widget.event.address;
    googleMapCubit.state.latLngOfSelectedLocation = LatLng(widget.event.latitude, widget.event.longitude);
    eventCubit.doAction(ChangeSelectedCategory(widget.event.category.id));
    titleController.text = widget.event.title;
    descriptionController.text = widget.event.description;
    date = DateTime.fromMillisecondsSinceEpoch(widget.event.date);
    time = TimeOfDay.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(widget.event.time),
    );
    eventCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case NavigateToMapScreen():
          Navigator.pushNamed(context, Routes.selectLocation);
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
          AppDialogs.actionDialog(
            context: context,
            content: navigationState.message,
            posActionTitle: context.locale!.tryAgain,
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: eventCubit),
        BlocProvider.value(value: setupCubit),
        BlocProvider.value(value: googleMapCubit),
      ],
      child: BlocBuilder<EventCubit, EventState>(
        builder:
            (_, state) => Scaffold(
              appBar: AppBar(
                title: Text(
                  context.locale!.editEvent,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 360 / 200,
                        child: Image.asset(widget.event.category.image),
                      ),
                    ),
                    10.verticalSpace,
                    DefaultTabController(
                      length: state.categoriesList.length,
                      child: TabBar(
                        onTap: (index) {
                          eventCubit.doAction(ChangeSelectedCategory(index));
                        },
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        dividerHeight: 0,
                        indicatorPadding: EdgeInsets.zero,
                        tabAlignment: TabAlignment.start,
                        tabs:
                            state.categoriesList
                                .map(
                                  (category) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          state.selectedCategoryIndex ==
                                                  category.id
                                              ? AppColors.purple
                                              : AppColors.lightBlue,
                                      border: Border.all(
                                        color: AppColors.purple,
                                      ),
                                    ),
                                    child: Tab(
                                      child: Row(
                                        spacing: 5,
                                        children: [
                                          Icon(
                                            category.icon,
                                            color:
                                                state.selectedCategoryIndex ==
                                                        category.id
                                                    ? AppColors.white
                                                    : AppColors.purple,
                                          ),
                                          Text(
                                            setupCubit.state.language == "en"
                                                ? category.nameEN
                                                : category.nameAR,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge!.copyWith(
                                              color:
                                                  state.selectedCategoryIndex ==
                                                          category.id
                                                      ? AppColors.white
                                                      : AppColors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      context.locale!.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    10.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => DataValidation.titleEventValidator(
                            value!,
                            AppLocalizations.of(context)!,
                          ),
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: context.locale!.eventTitle,
                        prefixIcon: Icon(Icons.edit),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      context.locale!.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    10.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => DataValidation.descriptionEventValidator(
                            value!,
                            AppLocalizations.of(context)!,
                          ),
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: context.locale!.eventDescription,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        10.horizontalSpace,
                        Text(DateFormat("dd/MM/yyyy").format(date!)),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: date,
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then((dateValue) {
                              setState(() {
                                date = dateValue;
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: Text(context.locale!.chooseDate),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        10.horizontalSpace,
                        Text(
                          DateFormat(
                            "h:mm a",
                          ).format(DateTime(0, 0, 0, time!.hour, time!.minute)),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: time!,
                            ).then((value) {
                              setState(() {
                                time = value;
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: Text(context.locale!.chooseTime),
                        ),
                      ],
                    ),

                    10.verticalSpace,
                    Text(
                      context.locale!.location,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    10.verticalSpace,
                    OutlinedButton(
                      onPressed: () {
                        eventCubit.doAction(GoToMapScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(8),
                      ),
                      child: Row(
                        spacing: 5,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: context.heightSize * 0.05,
                            width: context.widthSize * 0.11,
                            child: Icon(
                              Icons.my_location_outlined,
                              color: AppColors.lightBlue,
                              size: 24,
                            ),
                          ),
                          BlocBuilder<GoogleMapCubit, GoogleMapState>(
                            builder:
                                (_, state) => Expanded(
                                  child: Text(
                                    state.selectedLocation ??
                                        widget.event.address,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),

                    10.verticalSpace,
                    FilledButton(
                      onPressed: () {
                        EventDM event = EventDM(
                          id: widget.event.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          category:
                              state.categoriesList[state.selectedCategoryIndex],
                          date: date!.millisecondsSinceEpoch,
                          address: googleMapCubit.state.selectedLocation!,
                          latitude:
                              googleMapCubit
                                  .state
                                  .latLngOfSelectedLocation!
                                  .latitude,
                          longitude:
                              googleMapCubit
                                  .state
                                  .latLngOfSelectedLocation!
                                  .longitude,
                          time:
                              DateTime(
                                0,
                                0,
                                0,
                                time!.hour,
                                time!.minute,
                              ).millisecondsSinceEpoch,
                          favUsers: widget.event.favUsers,
                        );
                        eventCubit.doAction(UpdateEvent(event, context));
                      },
                      child: Text(
                        context.locale!.editEvent,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
