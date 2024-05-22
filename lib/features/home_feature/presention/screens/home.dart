import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home_feature/presention/cubits/nowplaying_cubit/now_playing_state.dart';
import 'package:movie_app/features/home_feature/presention/widgets/movie_list.dart';
import 'package:movie_app/features/home_feature/presention/widgets/custom_drawer.dart';

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
      drawer: const CustomDrawer(),
      body: BlocBuilder<NowPlayingMoviesCubit, NowPlayingMoviesState>(
        builder: (context, state) {
          return MovieList(
            scrollController: _scrollController,
            state: state,
          );
        },
      ),
    );
  }
}
