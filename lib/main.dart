import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pin.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_list.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_top_rate.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/search/tv_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_list.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rate.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();
  await Firebase.initializeApp();

  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<ListMovie>()),
        BlocProvider(create: (_) => di.locator<PopularMovie>()),
        BlocProvider(create: (_) => di.locator<TopRatedMovie>()),
        BlocProvider(create: (_) => di.locator<DetailBlocMovie>()),
        BlocProvider(create: (_) => di.locator<WatchlistBlocMovie>()),
        BlocProvider(create: (_) => di.locator<SearchBlocMovie>()),
        BlocProvider(create: (_) => di.locator<ListTv>()),
        BlocProvider(create: (_) => di.locator<DetailBlocTv>()),
        BlocProvider(create: (_) => di.locator<PopularTv>()),
        BlocProvider(create: (_) => di.locator<TopRatedTv>()),
        BlocProvider(create: (_) => di.locator<SearchBlocTv>()),
        BlocProvider(create: (_) => di.locator<WatchlistBlocTv>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case TvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TvPage());
            case PopularMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularTvPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedTvPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvPage());
            case SearchMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchMoviesPage());
            case SearchTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchTvPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found. Check your connection!'),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
