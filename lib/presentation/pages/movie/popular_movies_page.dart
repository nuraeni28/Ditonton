import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular_movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularMovie>().add(OnListMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovie, StateMovie>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data[index];
                  return MovieCard(movie);
                },
                itemCount: data.length,
              );
            } else {
              return Center(
                child: Text('Failed to load popular movies'),
              );
            }
          },
        ),
      ),
    );
  }
}
