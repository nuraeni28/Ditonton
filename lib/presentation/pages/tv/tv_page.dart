import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_list.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_state.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rate.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_series';

  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();
    context.read<ListTv>().add(OnListTv());
    context.read<PopularTv>().add(OnListTv());
    context.read<TopRatedTv>().add(OnListTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, "/home");
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_sharp),
              title: Text('TV Series'),
              onTap: () {
                Navigator.pushNamed(context, TvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              // onTap: () {
              //   Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              // },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist TV Series'),
              // onTap: () {
              //   Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              // },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, SearchMoviesPage.ROUTE_NAME);
          //   },
          //   icon: Icon(Icons.search),
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<ListTv, StateTv>(
                builder: (context, state) {
                  if (state is TvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvHasData) {
                    final tv = state.result;
                    return TvList(tv);
                  } else if (state is TvError) {
                    final tv = state.message;
                    return (Center(
                      child: Text(tv),
                    ));
                  } else {
                    return (Center(
                      child: Text("Failed to load tv series"),
                    ));
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTv, StateTv>(
                builder: (context, state) {
                  if (state is TvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvHasData) {
                    final tv = state.result;
                    return TvList(tv);
                  } else if (state is TvError) {
                    final tv = state.message;
                    return (Center(
                      child: Text(tv),
                    ));
                  } else {
                    return (Center(
                      child: Text("Failed to load tv series"),
                    ));
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTv, StateTv>(
                builder: (context, state) {
                  if (state is TvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvHasData) {
                    final movie = state.result;
                    return TvList(movie);
                  } else if (state is TvError) {
                    final movie = state.message;
                    return (Center(
                      child: Text(movie),
                    ));
                  } else {
                    return (Center(
                      child: Text("Failed to load top rated tv"),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<TvShow> movies;

  TvList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
