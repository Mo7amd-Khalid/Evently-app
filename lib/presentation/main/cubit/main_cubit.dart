import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/presentation/main/cubit/main_contract.dart';
import 'package:injectable/injectable.dart';


@injectable
class MainCubit extends BaseCubit<MainState, MainAction, MainNavigation>{

  MainCubit() : super(MainState());

  @override
  Future<void> doAction(MainAction action) async{
    switch (action) {

      case ChangeSelectedIndex():
        _changeSelectedIndex(action.index);
      case GoToEventManagementScreen():
        _goToEventManagementScreen();

    }
  }

  void _changeSelectedIndex(int index) {
    if(index == 2)
      {
        emitNavigation(NavigateToEventManagementScreen());
      }
    else
      {
        emit(state.copyWith(selectedIndex: index));
      }
  }

  void _goToEventManagementScreen() {
    emitNavigation(NavigateToEventManagementScreen());
  }


}