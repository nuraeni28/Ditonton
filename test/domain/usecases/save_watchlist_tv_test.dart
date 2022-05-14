import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases_tv/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockTvRepository.saveWatchlist(testTVSeriesDetailEntity))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVSeriesDetailEntity);
    // assert
    verify(mockTvRepository.saveWatchlist(testTVSeriesDetailEntity));
    expect(result, Right('Added to Watchlist'));
  });
}
