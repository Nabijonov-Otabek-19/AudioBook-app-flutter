import 'package:audiobook_app/core/error/failures.dart';
import 'package:audiobook_app/core/usecase/usecase.dart';
import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:audiobook_app/feature/data/repository/repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetBooksUseCase implements UseCase<List<BookModel>, Params> {
  final RepositoryImpl repository;

  const GetBooksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BookModel>>> call(Params params) async {
    return await repository.getBooks(params.offset, params.limit);
  }
}

class Params extends Equatable {
  final int offset;
  final int limit;

  const Params({
    required this.offset,
    required this.limit,
  });

  @override
  List<Object?> get props => [offset, limit];
}
