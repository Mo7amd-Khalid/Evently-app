import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({this.cubit ,super.key});
  final SetupCubit? cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      builder: (_, state) => AnimatedToggleSwitch.rolling(
          current: state.language,
          values:
          [
            "en",
            "ar"
          ],
          onChanged: (value)
          {
          cubit?.doAction(ChangeLanguage(value));
          },
          iconBuilder: (value, selected) {
            if(value == "en") {
              return Image.asset("assets/images/en.png");
            }
            else
              {
                return Image.asset("assets/images/ar.png");
              }
          },
        borderWidth: 1,
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height*0.04,
        indicatorSize: Size.fromWidth(40),
        style: ToggleStyle(
          indicatorColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
