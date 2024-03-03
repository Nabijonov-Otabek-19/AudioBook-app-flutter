import 'package:audiobook_app/core/error/failures.dart';
import 'package:audiobook_app/core/usecase/usecase.dart';
import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:audiobook_app/feature/data/repository/repository_impl.dart';
import 'package:dartz/dartz.dart';

class GetTopBooksUseCase implements UseCase<List<BookModel>, NoParams> {
  final RepositoryImpl repository;

  const GetTopBooksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BookModel>>> call(NoParams params) async {
    return await repository.getTopBooks();
  }
}
