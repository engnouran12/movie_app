import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';
import 'package:movie_app/features/home_feature/presention/screens/wash_list.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocBuilder<NowPlayingMoviesCubit, NowPlayingMoviesState>(
        builder: (context, state) {
          if (state is NowPlayingMoviesLoading 
          //&& state.movie.isEmpty
          ) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NowPlayingMoviesLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent &&
                    !context.read<NowPlayingMoviesCubit>().state.isFetching) {
                  context.read<NowPlayingMoviesCubit>().fetchNowPlayingMovies();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: state.hasReachedEnd
                    ? state.movies.length
                    : state.movies.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.movies.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return MovieListItem(
                    movie: state.movies[index],
                    onAddToWatchlist: () {
                      final watchlistCubit = 
                      context.read<WatchlistCubit>();
                      watchlistCubit.addToWatchlist(state.movies[index].id.toString(), true);
                    },
                  );
                },
              ),
            );
          } else if (state is NowPlayingMoviesError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Failed to load movies'));
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
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePath ?? ''),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => 
                WishlistScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
