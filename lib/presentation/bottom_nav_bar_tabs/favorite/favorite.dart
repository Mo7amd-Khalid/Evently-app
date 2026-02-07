import 'package:evently/core/di/di.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/padding.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/favorite/cubit/favorite_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/favorite/cubit/favorite_cubit.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:evently/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteCubit favoriteCubit = getIt();
  List<EventDM>? events;
  HomeCubit homeCubit = getIt();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favoriteCubit,
      child: SafeArea(
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder:(_, state) => Column(
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  favoriteCubit.doAction(SearchInFavList(events!, val));
                },
                decoration: InputDecoration(
                  hintText: context.locale!.searchForEvent,
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Theme.of(context).colorScheme.primary,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: favoriteCubit.getMyFavList(
                    homeCubit.state.userData.data!.uid,
                  ),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      events = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
                      if(state.searchedList.data != null)
                        {
                          if(events!.isEmpty || state.searchedList.data!.isEmpty)
                          {
                            return Center(child: Text(context.locale!.noEventToShow));
                          }
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: (context, index) => EventCart(event:state.searchedList.data!.isEmpty ? events![index] : state.searchedList.data![index]) ,
                            separatorBuilder: (context, index) => 10.verticalSpace,
                            itemCount: state.searchedList.data!.isEmpty ? events!.length : state.searchedList.data!.length,
                          );
                        }
                      else
                        {
                          if(events!.isEmpty)
                          {
                            return Center(child: Text(context.locale!.noEventToShow));
                          }
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: (context, index) => EventCart(event:events![index]) ,
                            separatorBuilder: (context, index) => 10.verticalSpace,
                            itemCount: events!.length,
                          );
                        }


                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ).allPadding(16),
        ),
      ),
    );
  }
}
