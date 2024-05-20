import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> watchlist;

  WatchlistLoaded({required this.watchlist});
}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError({required this.message});
}