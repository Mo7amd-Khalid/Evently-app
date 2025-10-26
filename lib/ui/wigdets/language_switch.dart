import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return AnimatedToggleSwitch.rolling(
        current: provider.locale,
        values:
        [
          "en",
          "ar"
        ],
        onChanged: (value)
        {
        provider.changeLocale(value);
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
    );
  }
}
