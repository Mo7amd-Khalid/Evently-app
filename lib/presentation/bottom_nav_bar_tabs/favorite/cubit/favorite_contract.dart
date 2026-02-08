import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/event_dm.dart';

class FavoriteState {
  Resources<List<EventDM>> favEvents;
  Resources<List<EventDM>> searchedList;

  FavoriteState({this.favEvents = const Resources.initial(), this.searchedList = const Resources.initial()});

  FavoriteState copyWith({Resources<List<EventDM>>? favEvents, Resources<List<EventDM>>? searchedList})
  {
    return FavoriteState(favEvents: favEvents ?? this.favEvents, searchedList: searchedList ?? this.searchedList);
  }
}

sealed class FavoriteAction{}

class UpdateFavUserList extends FavoriteAction{
  EventDM event;
  String userID;
  UpdateFavUserList(this.event, this.userID);
}

class SearchInFavList extends FavoriteAction{
  List<EventDM> events;
  String search;
  SearchInFavList(this.events, this.search);
}

