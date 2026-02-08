import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/di/di.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/profile/cubit/profile_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit
    extends BaseCubit<ProfileState, ProfileAction, ProfileNavigation> {
  ProfileCubit(this._authUseCase) : super(ProfileState());
  final AuthUseCase _authUseCase;
  final HomeCubit homeCubit = getIt();

  @override
  Future<void> doAction(ProfileAction action) async {
    switch (action) {
      case ChangeProfilePicture():
        _changeProfilePicture(action.context);
      case LogoutConfirmation():
        _logoutConfirmation(action.message);
      case Logout():
        _logout();

    }
  }

  Future<void> _changeProfilePicture(BuildContext context) async{
    emitNavigation(ShowLoadingDialog());
    final ImagePicker picker =  ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var response = await _authUseCase.updateUserImage(pickedImage!.path, context);
    switch (response)
        {
      case Success<void>():
        homeCubit.doAction(GetUserData());
        emitNavigation(ShowUpdatedDialog(response.message!));
      case Failure<void>():
        {
          emitNavigation(ShowUpdatedDialog(response.message));
        }
    }
    }

  Future<void> _logout() async{
    await _authUseCase.logout();
    emitNavigation(NavigateToLoginScreen());
  }

  void _logoutConfirmation(String message) {
    emitNavigation(ShowLogoutConfirmationDialog(message));
  }
}
