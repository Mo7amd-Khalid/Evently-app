import 'package:evently/core/routes/routes.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:evently/core/utils/int_extention.dart';
import 'package:flutter/material.dart';

class EventCart extends StatelessWidget {
  const EventCart({required this.event,super.key});
  final EventDM event;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, Routes.eventDetails,arguments: event);
      },
      child: AspectRatio(
        aspectRatio: 361/203,
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2
            ),
            image: DecorationImage(image: AssetImage(event.category.image)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.date.dayAndMonthToString,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          event.title,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        //await EventManagementFirebase.addEventToFav(event);
                      },
                      child: Icon(
                        size: 26,
                          event.favUsers!.contains(FirebaseAuthServices.getUserData()!.uid)? Icons.favorite : Icons.favorite_border_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
