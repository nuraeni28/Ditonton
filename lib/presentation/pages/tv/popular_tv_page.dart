import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular_tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTv>().add(OnListTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTv, StateTv>(
          builder: (context, state) {
            if (state is TvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data[index];
                  return TvCard(tv);
                },
                itemCount: data.length,
              );
            } else {
              return Center(
                child: Text('Failed to load popular Tv'),
              );
            }
          },
        ),
      ),
    );
  }
}
