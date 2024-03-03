part of 'home_bloc.dart';

@immutable
class HomeState {
  final List<BookModel> books;
  final List<BookModel> top;
  final bool isLoading;
  final bool hasReachedMax;
  final LoadingState? loadingState;
  final String? errorMessage;

  const HomeState({
    this.books = const [],
    this.top = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.loadingState = LoadingState.EMPTY,
    this.errorMessage = "",
  });

  HomeState copyWith({
    List<BookModel>? books,
    List<BookModel>? top,
    bool? isLoading,
    bool? hasReachedMax,
    LoadingState? loadingState,
    String? errorMessage,
  }) {
    return HomeState(
      books: books ?? this.books,
      top: top ?? this.top,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
