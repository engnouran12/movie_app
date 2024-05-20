import 'package:flutter/material.dart';
import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onAddToWatchlist;
  final VoidCallback? onRemoveFromWatchlist;

  MovieListItem({
    required this.movie,
    this.onAddToWatchlist,
    this.onRemoveFromWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie.posterPath,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    movie.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text('Rating: ${movie.voteAverage}'),
                  if (onAddToWatchlist != null)
                    ElevatedButton(
                      onPressed: onAddToWatchlist,
                      child: Text('Add to Watchlist'),
                    ),
                  if (onRemoveFromWatchlist != null)
                    ElevatedButton(
                      onPressed: onRemoveFromWatchlist,
                      child: Text('Remove from Watchlist'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
