import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/presentation/event_management/cubit/event_contract.dart';
import 'package:evently/presentation/event_management/cubit/event_cubit.dart';
import 'package:evently/presentation/select_location/cubit/google_map_contract.dart';
import 'package:evently/presentation/select_location/cubit/google_map_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:evently/validation/data_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/event_dm.dart';

class EventManagementScreen extends StatefulWidget {
  final EventDM? eventNeedToUpdate;

  const EventManagementScreen({super.key, this.eventNeedToUpdate});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  EventCubit eventCubit = getIt();
  SetupCubit setupCubit = getIt();
  GoogleMapCubit googleMapCubit = getIt();

  @override
  void initState() {
    super.initState();
    eventCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case NavigateToMapScreen():
          {
            Navigator.pushNamed(context, Routes.selectLocation);
          }
        case ShowLoadingDialog():
          AppDialogs.loadingDialog(
            context: context,
            loadingMessage: AppLocalizations.of(context)!.loading,
          );
        case ShowInfoDialog():
          Navigator.pop(context);
          AppDialogs.actionDialog(
            context: context,
            content: navigationState.message,
            posActionTitle: AppLocalizations.of(context)!.ok,
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
                  widget.eventNeedToUpdate == null
                      ? context.locale!.createEvent
                      : context.locale!.editEvent,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                centerTitle: true,
                leading: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 360 / 200,
                        child: Image.asset(
                          state
                              .categoriesList[state.selectedCategoryIndex]
                              .image,
                        ),
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
                        Text(
                          selectedDate == null
                              ? context.locale!.eventDate
                              : DateFormat("dd/MM/yyyy").format(selectedDate!),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: selectedDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then((dateValue) {
                              setState(() {
                                selectedDate = dateValue;
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
                          selectedTime == null
                              ? context.locale!.eventTime
                              : DateFormat("h:mm a").format(
                                DateTime(
                                  0,
                                  0,
                                  0,
                                  selectedTime!.hour,
                                  selectedTime!.minute,
                                ),
                              ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            ).then((value) {
                              setState(() {
                                selectedTime = value;
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
                            builder: (_, state) => Expanded(
                              child: Text(
                                state.selectedLocation ?? context.locale!.chooseEventLocation,
                                style: Theme.of(context).textTheme.titleMedium,
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
                        EventDM event;
                        if (widget.eventNeedToUpdate == null) {
                          event = EventDM(
                            id: "",
                            title: titleController.text,
                            description: descriptionController.text,
                            category: state.categoriesList[state.selectedCategoryIndex],
                            date: selectedDate!.millisecondsSinceEpoch,
                            address: googleMapCubit.state.selectedLocation!,
                            latitude: googleMapCubit.state.latLngOfSelectedLocation!.latitude,
                            longitude: googleMapCubit.state.latLngOfSelectedLocation!.longitude,
                            time:
                                DateTime(
                                  0,
                                  0,
                                  0,
                                  selectedTime!.hour,
                                  selectedTime!.minute,
                                ).millisecondsSinceEpoch,
                          );
                        } else {
                          event = EventDM(
                            id: widget.eventNeedToUpdate!.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            category: state.categoriesList[state.selectedCategoryIndex],
                            date: selectedDate!.millisecondsSinceEpoch,
                            address: googleMapCubit.state.selectedLocation ?? widget.eventNeedToUpdate!.address,
                            latitude:googleMapCubit.state.latLngOfSelectedLocation?.latitude ?? widget.eventNeedToUpdate!.latitude,
                            longitude: googleMapCubit.state.latLngOfSelectedLocation?.longitude ?? widget.eventNeedToUpdate!.longitude,
                            time: DateTime(
                                  0,
                                  0,
                                  0,
                                  selectedTime!.hour,
                                  selectedTime!.minute,
                                ).millisecondsSinceEpoch,
                          );
                        }
                        eventCubit.doAction(AddEvent(event, context));
                      },
                      child: Text(
                        widget.eventNeedToUpdate == null
                            ? context.locale!.addEvent
                            : context.locale!.updateEvent,
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
