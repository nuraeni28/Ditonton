import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  const TvShow({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  const TvShow.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
    this.backdropPath,
    this.genreIds,
    this.originalName,
    this.popularity,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
  });

  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        genreIds,
        id,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
      ];
}
