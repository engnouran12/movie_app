import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

abstract class NowPlayingMoviesState {}

class NowPlayingMoviesInitial extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;
  final bool hasReachedEnd;

  NowPlayingMoviesLoaded(
     {required this.movies,
     required this.hasReachedEnd});
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  NowPlayingMoviesError({required this.message});
}
