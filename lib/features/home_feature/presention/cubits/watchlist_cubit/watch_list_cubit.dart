import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/data/datasource/watch_list_repo.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_state.dart';
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository watchlistRepository;

  WatchlistCubit({required this.watchlistRepository}) : super(WatchlistInitial());

  Future<void> fetchWatchlist() async {
    try {
      emit(WatchlistLoading());
      final watchlist = await watchlistRepository.getWatchlist();
      emit(WatchlistLoaded(watchlist: watchlist));
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }

  Future<void> addToWatchlist(String movieId, bool add) async {
    try {
      await watchlistRepository.addToWatchlist(movieId, add);

      if (state is WatchlistLoaded) {
        final List<Movie> updatedWatchlist = List.from((state as WatchlistLoaded).watchlist);
        if (add) {
          // Fetch the movie details and add to the list
          final movie = await watchlistRepository.getWatchlist();
          updatedWatchlist.add(movie as Movie);
        } else {
          updatedWatchlist.removeWhere((movie) => movie.id.toString() == movieId);
        }
        emit(WatchlistLoaded(watchlist: updatedWatchlist));
      } else {
        fetchWatchlist();
      }
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }

  Future<void> removeFromWatchlist(String movieId) async {
    try {
      await watchlistRepository.removeToWatchlist(movieId, false);
      fetchWatchlist();
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }
}
