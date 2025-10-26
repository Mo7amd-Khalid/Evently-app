import 'package:evently/modules/event_dm.dart';
import 'package:evently/ui/firebase/event_firebase.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:evently/ui/wigdets/int_extention.dart';
import 'package:flutter/material.dart';

class EventCart extends StatelessWidget {
  EventCart({required this.event,super.key});
  final EventDM event;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
                event.date.dateToString,
                textAlign: TextAlign.center,
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
                      await EventManagementFirebase.addEventToFav(event);
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
    );
  }
}
