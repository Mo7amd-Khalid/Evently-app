import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:flutter/material.dart';

import '../../firebase/event_firebase.dart';
import '../../wigdets/event_card.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: locale.searchForEvent,
                hintStyle: Theme.of(context).textTheme.titleMedium,
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Theme.of(context).colorScheme.primary,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary
                  )
                )
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: EventManagementFirebase.getEventsFav(FirebaseAuthServices.getUserData()!.uid),
              builder: (_,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasData)
                {
                  var events = snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                  return ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index)=>EventCart(event: events[index],),
                      separatorBuilder: (context, index)=>SizedBox(height: 10,),
                      itemCount: events.length);
                }
                else if(snapshot.hasError)
                {
                  return Center(child: Text(snapshot.error.toString()));
                }
                else
                {
                  return SizedBox();
                }

              },
            ),
          )
        ],
      ),
    );
  }
}
