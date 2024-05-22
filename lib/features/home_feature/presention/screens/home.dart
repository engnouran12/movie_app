import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';
import 'package:movie_app/features/home_feature/presention/screens/wash_list.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch now playing movies on initialization
    context.read<NowPlayingMoviesCubit>().
    fetchNowPlayingMovies();
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
          print(state);
          if (state is NowPlayingMoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NowPlayingMoviesLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieListItem(
                  movie: state.movies[index],
                  onAddToWatchlist: () {
                    final watchlistCubit = context.read<WatchlistCubit>();
                    watchlistCubit.addToWatchlist(
                        state.movies[index].id.toString(), true);
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
    final user = authCubit.tmdbAuth?.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePath ?? ''),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WishlistScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
