import 'package:audiobook_app/core/error/failures.dart';
import 'package:audiobook_app/feature/data/model/audiofile_model.dart';
import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, List<BookModel>>> getBooks(int offset, int limit);

  Future<Either<Failure, List<BookModel>>> getTopBooks();

  Future<Either<Failure, List<AudioFileModel>>> getAudioFiles(String? bookId);
}
