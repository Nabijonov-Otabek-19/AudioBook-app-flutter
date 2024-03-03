import 'package:audiobook_app/core/error/failures.dart';
import 'package:audiobook_app/core/usecase/usecase.dart';
import 'package:audiobook_app/feature/data/model/audiofile_model.dart';
import 'package:audiobook_app/feature/data/repository/repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAudioFilesUseCase implements UseCase<List<AudioFileModel>, String> {
  final RepositoryImpl repository;

  const GetAudioFilesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AudioFileModel>>> call(String bookId) async {
    return await repository.getAudioFiles(bookId);
  }
}
