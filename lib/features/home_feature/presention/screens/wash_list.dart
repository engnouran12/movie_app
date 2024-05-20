import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/watchlist_cubit/watch_list_state.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_item.dart';


class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final watchlistCubit = context.read<WatchlistCubit>();
    watchlistCubit.fetchWatchlist();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistLoaded) {
            return ListView.builder(
              itemCount: state.watchlist.length,
              itemBuilder: (context, index) {
                final movie = state.watchlist[index];
                return MovieListItem(
                  movie: movie,
                  onRemoveFromWatchlist: () {
                    watchlistCubit.addToWatchlist
                    (movie.id.toString(), false);
                  },
                );
              },
            );
          } else if (state is WatchlistError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Failed to load watchlist'));
          }
        },
      ),
    );
  }
}
