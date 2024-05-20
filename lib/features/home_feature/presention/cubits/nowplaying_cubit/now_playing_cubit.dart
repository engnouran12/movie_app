
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';
import 'package:movie_app/features/home_feature/data/datasource/remote_movie_now_play.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';

class NowPlayingMoviesCubit extends Cubit<NowPlayingMoviesState> {
   MovieRepository movieRepository;

  int currentPage = 1;
  List<Movie> movies = [];

  NowPlayingMoviesCubit({
    required this.movieRepository,
  }) : super(NowPlayingMoviesInitial());

  Future<void> fetchNowPlayingMovies() async {
    try {
      if (state is NowPlayingMoviesLoading) return;

      emit(NowPlayingMoviesLoading());
      final newMovies = await movieRepository.getNowPlayingMovies(currentPage);
      if (newMovies.isEmpty) {
        emit(NowPlayingMoviesLoaded(
          movies: movies,
         hasReachedEnd: true));
      } else {
        movies.addAll(newMovies);
        currentPage++;
        emit(NowPlayingMoviesLoaded(movies: movies, 
        hasReachedEnd: false));
      }
    } catch (e) {
      emit(NowPlayingMoviesError(message: e.toString()));
    }
  }
}
