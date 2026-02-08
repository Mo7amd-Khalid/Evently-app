import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/domain/use_case/use_case.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';


@singleton
class HomeCubit extends BaseCubit<HomeState, HomeAction, HomeNavigation>{
  HomeCubit(this._authUseCase, this._eventlyUseCase) : super(HomeState());

  final AuthUseCase _authUseCase;
  final EventlyUseCase _eventlyUseCase;


  @override
  Future<void> doAction(HomeAction action) async{
    switch (action) {

      case GetUserData():
        _getUserData();
      case ChooseSelectedCategory():
        _chooseSelectedCategory(action.index);
      case GetEvents():
        _getEvents(action.categoryID);

    }
  }

  Future<void> _getUserData() async{
    emit(state.copyWith(userData: const Resources.loading()));
    var response = await _authUseCase.getUserData();
    switch (response) {
      case Success<User>():
        emit(state.copyWith(userData: Resources.success(data: response.data)));
      case Failure<User>():
        emit(state.copyWith(userData: Resources.failure(exception: response.exception, message: response.message)));
    }
  }

  void _chooseSelectedCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
    _getEvents(state.categoriesList[state.selectedCategoryIndex].id);
  }

  Future<void> _getEvents(int categoryID) async{
    emit(state.copyWith(events: const Resources.loading()));
    var response = await _eventlyUseCase.getEvents(categoryID);
    switch (response) {

      case Success<List<EventDM>>():
        emit(state.copyWith(events: Resources.success(data: response.data)));
      case Failure<List<EventDM>>():
        emit(state.copyWith(events: Resources.failure(exception: response.exception, message: response.message)));
    }
  }



}