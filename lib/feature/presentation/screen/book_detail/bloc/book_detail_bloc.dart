import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/loading_state_enum.dart';
import '../../../../data/model/audiofile_model.dart';
import '../../../../domain/usecase/get_audiofiles_usecase.dart';

part 'book_detail_event.dart';

part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final GetAudioFilesUseCase getAudioFilesUseCase;

  BookDetailBloc({
    required this.getAudioFilesUseCase,
  }) : super(const BookDetailState()) {
    on<BookDetailEvent>((event, emit) async {
      switch (event) {
        case GetAudioFilesEvent():
          final result = await getAudioFilesUseCase(event.bookId);
          await _getAudioFiles(state, emit, result);
          break;

        case ChangeAudioUrlEvent():
          emit(state.copyWith(url: event.url, title: event.title));
          break;
      }
    });
  }

  Future<void> _getAudioFiles(
    BookDetailState state,
    Emitter<BookDetailState> emit,
    Either<Failure, List<AudioFileModel>> result,
  ) async {
    result.fold(
      (failure) async =>
          emit(state.copyWith(errorMessage: failure.errorMessage)),
      (success) async {
        emit(state.copyWith(audioFiles: success));
      },
    );
  }
}
