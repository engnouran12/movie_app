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
import 'package:movie_app/features/now.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MovieRepository(apiKey: apiKey).getNowPlayingMovies(1);
  final sharedPrefService = SharedPrefService();
  final tmdbAuth = TMDBAuth(
    apiKey: apiKey,
    sharedPrefService: sharedPrefService,
  );

  await tmdbAuth.checkLoginStatus();

  final sessionId = tmdbAuth.sessionId;
  final accountId = tmdbAuth.currentUser?.id;

  runApp(MyApp(tmdbAuth: tmdbAuth, sessionId: sessionId, accountId: accountId));
}

class MyApp extends StatelessWidget {
  final TMDBAuth tmdbAuth;
  final String? sessionId;
  final String? accountId;

  const MyApp(
      {Key? key, required this.tmdbAuth, this.sessionId, this.accountId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(tmdbAuth: tmdbAuth)..checkLoginStatus(),
        ),
        BlocProvider(
          create: (context) => NowPlayingMoviesCubit(
              movieRepository: MovieRepository(apiKey: apiKey)),
        ),
        BlocProvider(
          create: (context) => WatchlistCubit(
              apiKey: apiKey,
              watchlistRepository: WatchlistRepository(
                  apiKey: apiKey,
                  sessionId: sessionId!,
                  accountId: accountId!)),
        ),
      ],
      child: MaterialApp(
        title: 'TMDB Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomeScreen();
            } else if (state is AuthUnauthenticated) {
              return LoginScreen();
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
