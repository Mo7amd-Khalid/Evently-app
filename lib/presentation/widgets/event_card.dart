import 'package:evently/core/di/di.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/core/utils/int_extention.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/favorite/cubit/favorite_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/favorite/cubit/favorite_cubit.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCart extends StatelessWidget {
  EventCart({required this.event, super.key});

  final EventDM event;
  final FavoriteCubit favoriteCubit = getIt();
  final HomeCubit homeCubit = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favoriteCubit,
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder:
            (_, state) => InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.eventDetails,
                  arguments: event,
                );
              },
              child: AspectRatio(
                aspectRatio: 361 / 203,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(event.category.image),
                    ),
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
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge!.copyWith(fontSize: 16),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                favoriteCubit.doAction(
                                  UpdateFavUserList(
                                    event,
                                    homeCubit.state.userData.data!.uid,
                                  ),
                                );
                              },
                              child: Icon(
                                size: 26,
                                event.favUsers!.contains(
                                      homeCubit.state.userData.data!.uid,
                                    )
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
