import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

abstract class NowPlayingMoviesState {}

class NowPlayingMoviesInitial extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {
  final List<Movie> previousMovies;
  final bool isFirstFetch;

  NowPlayingMoviesLoading({
    required this.previousMovies,
    required this.isFirstFetch,
  });
}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;
  final bool hasReachedEnd;

  NowPlayingMoviesLoaded({
    required this.movies,
    required this.hasReachedEnd,
  });
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;
  final List<Movie> previousMovies;

  NowPlayingMoviesError({
    required this.message,
    required this.previousMovies,
  });
}
