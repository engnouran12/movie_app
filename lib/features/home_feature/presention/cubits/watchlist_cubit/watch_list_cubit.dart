import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/data/datasource/watch_list_repo.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository watchlistRepository;

  WatchlistCubit({required this.watchlistRepository, required String apiKey}) : super(WatchlistInitial());

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
      fetchWatchlist();  // Refresh the watchlist after adding/removing a movie
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }
}


