import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_item.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';

class MovieList extends StatelessWidget {
  final ScrollController scrollController;
  final NowPlayingMoviesState state;

  const MovieList({
    super.key,
    required this.scrollController,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is NowPlayingMoviesLoading && (state as NowPlayingMoviesLoading).isFirstFetch) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NowPlayingMoviesLoaded) {
      return ListView.builder(
        controller: scrollController,
        itemCount: (state as NowPlayingMoviesLoaded).hasReachedEnd
            ? (state as NowPlayingMoviesLoaded).movies.length
            : (state as NowPlayingMoviesLoaded).movies.length + 1,
        itemBuilder: (context, index) {
          final movies = (state as NowPlayingMoviesLoaded).movies;
          if (index >= movies.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final movie = movies[index];
          return MovieListItem(
            movie: movie,
            onAddToWatchlist: () {
              final watchlistCubit = context.read<WatchlistCubit>();
              watchlistCubit.addToWatchlist(movie.id.toString(), true);
            },
          );
        },
      );
    } else if (state is NowPlayingMoviesLoading) {
      return ListView.builder(
        controller: scrollController,
        itemCount: (state as NowPlayingMoviesLoading).previousMovies.length + 1,
        itemBuilder: (context, index) {
          final previousMovies = (state as NowPlayingMoviesLoading).previousMovies;
          if (index >= previousMovies.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final movie = previousMovies[index];
          return MovieListItem(
            movie: movie,
            onAddToWatchlist: () {
              final watchlistCubit = context.read<WatchlistCubit>();
              watchlistCubit.addToWatchlist(movie.id.toString(), true);
            },
          );
        },
      );
    } else if (state is NowPlayingMoviesError) {
      return Center(child: Text((state as NowPlayingMoviesError).message));
    } else {
      return const Center(child: Text('Failed to load movies'));
    }
  }
}
