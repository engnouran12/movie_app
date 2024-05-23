// import 'package:flutter/material.dart';
// import 'package:movie_app/features/Auth_features/data/models/movie_model.dart';
// import 'package:movie_app/features/search_feature/data/datasource/repo_search';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
// final   SearchlistRepository  _searchlistRepository =
//   SearchlistRepository();
//   List<Movie> _searchResults = [];
//   bool _isLoading = false;

//   Future<void> _searchNowPlayingMovies(String query) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final searchResults =
//           await SearchlistRepository.searchNowPlayingMovies(query);
//       setState(() {
//         _searchResults = searchResults;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter movie name',
//                 suffixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _searchResults.isEmpty
//                     ? const Center(child: Text('No movies found'))
//                     : ListView.builder(
//                         itemCount: _searchResults.length,
//                         itemBuilder: (context, index) {
//                           final movie = _searchResults[index];
//                           return ListTile(
//                             title: Text(movie.title),
//                             // Implement other functionalities as needed
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _searchNowPlayingMovies(_searchController.text);
//         },
//         child: const Icon(Icons.search),
//       ),
//     );
//   }
// }
