import 'package:audiobook_app/core/usecase/usecase.dart';
import 'package:audiobook_app/core/utils/loading_state_enum.dart';
import 'package:audiobook_app/feature/domain/usecase/get_books_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../data/model/book_model.dart';
import '../../../../domain/usecase/get_top_books_usecase.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBooksUseCase getBooksUseCase;
  final GetTopBooksUseCase getTopBooksUseCase;

  HomeBloc({
    required this.getBooksUseCase,
    required this.getTopBooksUseCase,
  }) : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      switch (event) {
        case GetBooksEvent():
          final resultBooks = await getBooksUseCase(
            Params(offset: 20, limit: state.books.length),
          );
          final resultTopBooks = await getTopBooksUseCase(NoParams());
          await _getBooks(state, emit, resultBooks);
          await _getTopBooks(state, emit, resultTopBooks);
          break;
      }
    });
  }

  Future<void> _getBooks(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, List<BookModel>> result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(
          errorMessage: failure.errorMessage,
          loadingState: LoadingState.ERROR,
        ));
      },
      (success) async {
        if (success.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          List<BookModel> books = [];
          books.addAll(state.books);
          books.addAll(success);
          emit(state.copyWith(
              books: books, loadingState: LoadingState.LOADED));
        }
      },
    );
  }

  Future<void> _getTopBooks(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, List<BookModel>> result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(errorMessage: failure.errorMessage));
      },
      (success) async {
        emit(state.copyWith(top: success));
      },
    );
  }
}
