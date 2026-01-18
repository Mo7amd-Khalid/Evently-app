import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({this.cubit, super.key});

  final SetupCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      builder: (_, state) => AnimatedToggleSwitch.rolling(
            current: state.mode,
            values: [ThemeMode.light, ThemeMode.dark],
            onChanged: (value) {
              cubit?.doAction(ChangeThemeMode(value));
            },
            iconBuilder: (value, selected) {
              if (value == ThemeMode.light) {
                return Icon(Icons.light_mode_outlined);
              } else {
                return Icon(Icons.dark_mode_outlined);
              }
            },
            borderWidth: 1,
            padding: EdgeInsets.zero,
            height: MediaQuery.sizeOf(context).height * 0.04,
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
