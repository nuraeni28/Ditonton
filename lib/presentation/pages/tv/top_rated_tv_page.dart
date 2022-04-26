import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_state.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rate.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedTv>().add(OnListTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTv, StateTv>(
          builder: (context, state) {
            if (state is TvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvHasData) {
              final movies = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return TvCard(movie);
                },
                itemCount: movies.length,
              );
            } else {
              return Center(
                child: Text('Failed to load Top Rated Tv'),
              );
            }
          },
        ),
      ),
    );
  }
}
