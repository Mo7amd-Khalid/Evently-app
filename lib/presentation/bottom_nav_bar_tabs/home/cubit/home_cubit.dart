import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/category_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';


@injectable
class HomeCubit extends BaseCubit<HomeState, HomeAction, HomeNavigation>{
  HomeCubit(this._authUseCase) : super(HomeState());

  final AuthUseCase _authUseCase;

  @override
  Future<void> doAction(HomeAction action) async{
    switch (action) {

      case GetUserData():
        _getUserData();
      case ChooseSelectedCategory():
        _chooseSelectedCategory(action.index);
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
  }


}