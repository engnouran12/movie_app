import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/const.dart';
import 'package:movie_app/features/Auth_features/data/datasource/local_data_source.dart';
import 'package:movie_app/features/Auth_features/data/datasource/remote_data_source.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_state.dart';
import 'package:movie_app/features/Auth_features/presentation/screens/login.dart';
import 'package:movie_app/features/home_feature/data/datasource/remote_movie_now_play.dart';
import 'package:movie_app/features/home_feature/data/datasource/watch_list_repo.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';
import 'package:movie_app/features/home_feature/presention/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
 // final sharedPreferences = await SharedPreferences.getInstance();
    // final sharedPrefService =
    //  SharedPrefService
    //  (sharedpref: sharedPreferences
    //   );

  
  //final sharedPrefService = SharedPrefService().saveSessionId(sessionId);
 
  await MovieRepository(apiKey: apiKey).getNowPlayingMovies(1);
  //final sharedPrefService = SharedPrefService();
  // final tmdbAuth = TMDBAuth(
  //     apiKey: apiKey, sharedPrefService:
  // sharedPrefService,
  // sessionId: '');
  // final watchlistRepository =
  //     WatchlistRepository(apiKey: apiKey, sharedPrefService: sharedPrefService);
  // final movieRepository = MovieRepository(apiKey: 'YOUR_API_KEY');

  runApp(
    MyApp(
        // authCubit: AuthCubit(tmdbAuth: tmdbAuth),
        // nowPlayingMoviesCubit:
        //     NowPlayingMoviesCubit(movieRepository: movieRepository),
        // watchlistCubit:
        // WatchlistCubit(
        //   watchlistRepository: watchlistRepository
        //watchlistRepository: watchlistRepository
        ),
  );
}

class MyApp extends StatelessWidget {
  TMDBAuth tmdbAuth = TMDBAuth(
       apiKey: apiKey,
        
   sessionId: '', sharedPrefService: SharedPrefService(),
    currentUser: null);
  AuthCubit authCubit = AuthCubit(tmdbAuth: TMDBAuth(
       apiKey: apiKey,
        
   sessionId: '', sharedPrefService: SharedPrefService(), currentUser: null));
  //TMDBAuth(apiKey: apiKey, sharedPrefService: sharedPrefService, sessionId: '');;
  NowPlayingMoviesCubit nowPlayingMoviesCubit =
      NowPlayingMoviesCubit(movieRepository: MovieRepository(apiKey: apiKey));
  
  WatchlistCubit watchlistCubit = WatchlistCubit(
      watchlistRepository: WatchlistRepository(
          apiKey: apiKey, 
          sharedPrefService:SharedPrefService(
            
           )));

  MyApp({super.key}

      // required this.authCubit,
      // required this.nowPlayingMoviesCubit,
      // required this.watchlistCubit,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => authCubit),
          BlocProvider<NowPlayingMoviesCubit>(
              create: (_) => nowPlayingMoviesCubit),
          BlocProvider<WatchlistCubit>(create: (_) => watchlistCubit),
        ],
        child:  MaterialApp(title: 'Movie App', 
        home: LoginScreen()
        //HomeScreen()
            // BlocBuilder<AuthCubit, AuthState>(
            //   builder: (context, state) {
            //     print(state);

            //     if (state is AuthAuthenticated) {
            //       return HomeScreen();
            //     } else if (state is AuthUnauthenticated) {
            //       return LoginScreen();
            //     } else if (state is AuthLoading) {
            //       return const Center(child: CircularProgressIndicator());
            //     } else if (state is AuthError) {
            //       return Center(child: Text(state.message));
            //     } else {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //},
            ));
  }
}
