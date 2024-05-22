import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';
import 'package:movie_app/features/home_feature/presention/screens/wash_list.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_item.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final nowPlayingMoviesCubit = context.read<NowPlayingMoviesCubit>();
    nowPlayingMoviesCubit.fetchNowPlayingMovies();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<NowPlayingMoviesCubit>().fetchNowPlayingMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocBuilder<NowPlayingMoviesCubit, NowPlayingMoviesState>(
        builder: (context, state) {
          if (state is NowPlayingMoviesLoading && state.isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NowPlayingMoviesLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedEnd ? state.movies.length : state.movies.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = state.movies[index];
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
              controller: _scrollController,
              itemCount: state.previousMovies.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.previousMovies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = state.previousMovies[index];
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
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Failed to load movies'));
          }
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.tmdbAuth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: const Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePath ?? ''),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WishlistScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
