import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/modules/event_dm.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:evently/ui/firebase/event_firebase.dart';
import 'package:evently/ui/home/main_screen.dart';
import 'package:evently/ui/wigdets/app_dialogs.dart';
import 'package:evently/ui/wigdets/int_extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'event_management_screen.dart';

class EventDetails extends StatelessWidget {
  static const String routeName = "Event Details";
  const EventDetails({super.key});


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    EventDM event = ModalRoute.of(context)!.settings.arguments as EventDM;
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.eventDetails),
        centerTitle: true,
        actions: [
          //Edit Icon
          IconButton(
            padding: EdgeInsets.zero,
              onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EventManagementScreen(eventNeedToUpdate: event,)));
              },
              icon: Icon(Icons.edit_outlined)),
          //Delete Icon
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                AppDialogs.actionDialog(
                    context: context,
                    title: locale.deleteEvent,
                    content: locale.deleteEventConfirmation,
                    posActionTitle: locale.yes,
                    posAction: (){
                        AppDialogs.loadingDialog(context: context, loadingMessage: locale.loading);
                        EventManagementFirebase.deleteEvent(event.id).then((value){
                          Navigator.pop(context);
                          AppDialogs.actionDialog(
                              context: context,
                            title: locale.deleteEvent,
                            content: locale.eventDeletedSuccessfully,
                            posActionTitle: locale.ok,
                            posAction: (){
                             Navigator.pushReplacementNamed(context, MainScreen.routeName);
                            }
                          );
                      }).onError((error,_){
                          Navigator.pop(context);
                          AppDialogs.actionDialog(
                              context: context,
                              title: locale.deleteEvent,
                              content: error.toString(),
                              posActionTitle: locale.tryAgain,
                          );
                        });
                  },
                  negActionTitle: locale.no
                );
              },
              icon: Icon(Icons.delete_outline_outlined,color: Colors.red,)),
        ],
        actionsPadding: EdgeInsets.zero,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
                aspectRatio: 360/200,
                child: Image.asset(event.category.image)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              event.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
              onPressed: (){},
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(8)
              ),
              child: Row(
                spacing: 5,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    height: MediaQuery.sizeOf(context).height*0.05,
                    width: MediaQuery.sizeOf(context).width*0.11,
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.date.fullDateWithNameOfMonthToString,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        event.time.timeToString,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color:provider.isDark() ? AppColors.white: AppColors.black),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios)
                ],
              )),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
              onPressed: (){},
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(8)
              ),
              child: Row(
                spacing: 5,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    height: MediaQuery.sizeOf(context).height*0.05,
                    width: MediaQuery.sizeOf(context).width*0.11,
                    child: Icon(
                      Icons.my_location_outlined,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                  ),
                  Text(
                    "Cairo, Egypt",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios)
                ],
              )),
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset("assets/images/location_img.png"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            locale.description,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            event.description,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

}
