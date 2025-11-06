import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/modules/event_dm.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:flutter/material.dart';

import '../../firebase/event_firebase.dart';
import '../../wigdets/event_card.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController searchController = TextEditingController();

  List<EventDM>? searchEvents;

  List<EventDM>? events;

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
              onChanged: (val){
                if(val.isNotEmpty)
                  {
                    search(val);
                  }
                else
                  {
                    searchEvents = null;
                    setState(() {

                    });
                  }

              },
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
                  events = snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                  return ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index)=>EventCart(event: searchEvents == null ? events![index] : searchEvents![index],),
                      separatorBuilder: (context, index)=>SizedBox(height: 10,),
                      itemCount: searchEvents == null ?events!.length : searchEvents!.length);
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

  void search(String searchedTitle){
    if(events != null && events!.isNotEmpty)
      {
        searchEvents = [];
        events!.forEach((e){
          if(e.title.toLowerCase().contains(searchedTitle))
            {
              if(!searchEvents!.contains(e))
              {
                searchEvents!.add(e);
              }
            }
          else
            {
              searchEvents!.remove(e);
            }
          setState(() {});
        });
      }
  }
}
