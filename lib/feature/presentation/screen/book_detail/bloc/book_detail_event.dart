part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailEvent {}

class GetAudioFilesEvent extends BookDetailEvent {
  final String bookId;

  GetAudioFilesEvent({required this.bookId});
}

class ChangeAudioUrlEvent extends BookDetailEvent {
  final String url;
  final String title;

  ChangeAudioUrlEvent({
    required this.title,
    required this.url,
  });
}
