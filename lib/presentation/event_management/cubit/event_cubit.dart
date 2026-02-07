import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/use_case.dart';
import 'package:evently/presentation/event_management/cubit/event_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class EventCubit extends BaseCubit<EventState, EventAction, EventNavigation> {
  EventCubit(this._eventlyUseCase) : super(EventState());

  final EventlyUseCase _eventlyUseCase;


  @override
  Future<void> doAction(EventAction action) async {
    switch (action) {
      case ChangeSelectedCategory():
        _changeSelectedCategory(action.index);
      case GoToMapScreen():
        _goToMapScreen();
      case AddEvent():
        _addEvent(action.event, action.context);
      case DeleteEvent():
        _deleteEvent(action.eventID);
      case GoToHomeScreen():
        _goToHomeScreen();
      case UpdateEvent():
        _updateEvent(action.event, action.context);
    }
  }

  void _changeSelectedCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void _goToMapScreen() {
    emitNavigation(NavigateToMapScreen());
  }

  Future<void> _addEvent(EventDM event, BuildContext context) async {
    emitNavigation(ShowLoadingDialog());
    var response = await _eventlyUseCase.addEvent(event, context);
    switch (response) {
      case Success<void>():
        emitNavigation(ShowInfoDialog(response.message!));
        emit(state.copyWith(statusMessage: Resources.success(message: response.message)));
      case Failure<void>():
        emitNavigation(ShowErrorDialog(response.message));
        emit(state.copyWith(statusMessage: Resources.failure(
            exception: response.exception, message: response.message)));
    }
  }

  Future<void> _updateEvent(EventDM event, BuildContext context) async{
    emitNavigation(ShowLoadingDialog());
    var response = await _eventlyUseCase.updateEvent(event, context);
    switch(response)
        {
      case Success<void>():
        emitNavigation(ShowInfoDialog(response.message!));
      case Failure<void>():
        emitNavigation(ShowInfoDialog("Event Updated Successfully"));
    }
  }

  Future<void> _deleteEvent(String eventID) async{
    emitNavigation(ShowLoadingDialog());
    var response = await _eventlyUseCase.deleteEvent(eventID);
    switch (response) {

      case Success<void>():
        emit(state.copyWith(statusMessage: Resources.success(message: response.message!)));
        emitNavigation(ShowInfoDialog(response.message!));
      case Failure<void>():
        emit(state.copyWith(statusMessage: Resources.failure(exception: response.exception, message: response.message)));
        emitNavigation(ShowInfoDialog(response.message));
    }
  }

  void _goToHomeScreen() {
    emitNavigation(NavigateToHomeScreen());
  }




}