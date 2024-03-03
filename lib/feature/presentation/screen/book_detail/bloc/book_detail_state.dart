part of 'book_detail_bloc.dart';

@immutable
class BookDetailState {
  final List<AudioFileModel> audioFiles;
  final String? url;
  final String? title;
  final LoadingState? loadingState;
  final String? errorMessage;

  const BookDetailState({
    this.audioFiles = const [],
    this.url = "",
    this.title = "",
    this.loadingState = LoadingState.EMPTY,
    this.errorMessage = "",
  });

  BookDetailState copyWith({
    List<AudioFileModel>? audioFiles,
    String? url,
    String? title,
    LoadingState? loadingState,
    String? errorMessage,
  }) {
    return BookDetailState(
      audioFiles: audioFiles ?? this.audioFiles,
      url: url ?? this.url,
      title: title ?? this.title,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
