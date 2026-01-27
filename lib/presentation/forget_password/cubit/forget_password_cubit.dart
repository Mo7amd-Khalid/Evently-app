import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/presentation/forget_password/cubit/forget_password_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, ForgetPasswordAction, ForgetPasswordNavigation>{

  ForgetPasswordCubit(this._useCase) : super(ForgetPasswordState());

  final AuthUseCase _useCase;
  @override
  Future<void> doAction(ForgetPasswordAction action) async{
    switch (action) {

      case SendPasswordResetEmailAction():
        _sendPasswordResetEmail(action.email);
    }
  }

  Future<void> _sendPasswordResetEmail(String email) async{
    emitNavigation(ShowDialogLoadingNavigation());
    var response = await _useCase.sendPasswordResetEmail(email);
    switch (response) {
      case Success<void>():
        {
          emitNavigation(ShowDialogSuccessNavigation());
        }
      case Failure<void>():
        {
          emitNavigation(ShowDialogFailedNavigation(response.message));
        }
    }
  }

}