import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return AnimatedToggleSwitch.rolling(
      current: provider.themeMode,
      values:
      [
        ThemeMode.light,
        ThemeMode.dark
      ],
      onChanged: (value){
        provider.changeTheme(value);
      },
      iconBuilder: (value, selected) {
        if(value == ThemeMode.light) {
          return Icon(Icons.light_mode_outlined);
        }
        else
        {
          return Icon(Icons.dark_mode_outlined);
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
    );
  }
}
