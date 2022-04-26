import 'package:ditonton/data/datasources/db/database_helper_movie.dart';
import 'package:ditonton/data/datasources/db/database_helper_tv.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository.impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases_movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases_movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases_movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases_movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases_movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases_movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases_movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases_movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases_movie/save_watchlist.dart';
import 'package:ditonton/domain/usecases_tv/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases_tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases_tv/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases_tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases_tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases_tv/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases_tv/remove_watchlist.dart';
import 'package:ditonton/domain/usecases_tv/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases_tv/search_tv.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_list.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_top_rate.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_list.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rate.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'domain/usecases_movie/search_movies.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => ListMovie(
      locator(),
    ),
  );
  locator.registerFactory(
    () => ListTv(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMovie(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTv(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMovie(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTv(
      locator(),
    ),
  );
  locator.registerFactory(
    () => DetailBlocMovie(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => DetailBlocTv(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistBlocMovie(
      locator(),
    ),
  );
  locator.registerFactory(
    () => SearchBlocMovie(
      locator(),
    ),
  );
  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  //use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));

  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository tv series
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  // data sources movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // data sources tv series
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper movie
  locator
      .registerLazySingleton<DatabaseHelperMovie>(() => DatabaseHelperMovie());
  // helper movie
  locator.registerLazySingleton<DatabaseHelperTv>(() => DatabaseHelperTv());
  // external
  locator.registerLazySingleton(() => http.Client());
}
