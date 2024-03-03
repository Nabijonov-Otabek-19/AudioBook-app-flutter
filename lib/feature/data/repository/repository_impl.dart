import 'package:audiobook_app/core/error/failures.dart';
import 'package:audiobook_app/feature/data/datasource/local_data_source.dart';
import 'package:audiobook_app/feature/data/datasource/remote_data_source.dart';
import 'package:audiobook_app/feature/data/model/audiofile_model.dart';
import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:audiobook_app/feature/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSourceImpl remoteDataSource;
  final DatabaseHelperImpl localDataSource;

  const RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<AudioFileModel>>> getAudioFiles(
      String? bookId) async {
    try {
      List<AudioFileModel> audioFiles;
      audioFiles = await localDataSource.fetchAudioFiles(bookId);
      if (audioFiles.isEmpty) {
        audioFiles = await remoteDataSource.fetchAudioFiles(bookId);
        localDataSource.saveAudioFiles(audioFiles);
      }
      return Right(audioFiles);
    } catch (e) {
      print("REPOSITORY AUDIOS ERROR = $e");
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getBooks(
      int offset, int limit) async {
    try {
      List<BookModel> books = [];
      books = await localDataSource.getBooks(offset, limit);

      if (books.isEmpty) {
        books = await remoteDataSource.fetchBooks(offset, limit);
        await localDataSource.saveBooks(books);
      }
      return Right(books);
    } catch (e) {
      print("REPOSITORY BOOKS ERROR = $e");
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getTopBooks() async {
    try {
      final result = await remoteDataSource.fetchTopBooks();
      return Right(result);
    } catch (e) {
      print("REPOSITORY TOPBOOKS ERROR = $e");
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
