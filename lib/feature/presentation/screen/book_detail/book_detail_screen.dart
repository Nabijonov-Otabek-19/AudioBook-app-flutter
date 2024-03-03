import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobook_app/feature/presentation/screen/book_detail/bloc/book_detail_bloc.dart';
import 'package:audiobook_app/feature/presentation/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_handler.dart';
import '../../../../main.dart';
import '../../../data/model/book_model.dart';
import '../../widget/book_title_widget.dart';
import '../../widget/player_service_widget.dart';

class BookDetailScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool toplay;
  late StreamSubscription<PlaybackState> playbackStateListener;

  final bloc = di.get<BookDetailBloc>();

  @override
  void initState() {
    toplay = false;
    playbackStateListener = audioHandler.playbackState.listen((state) {
      if (state.processingState == AudioProcessingState.idle) {
        if (toplay && mounted) {
          toplay = false;
        }
      }
    });

    bloc.add(GetAudioFilesEvent(bookId: widget.book.id));
    super.initState();
  }

  @override
  void dispose() {
    print("BOOKDETAIL DISPOSE");
    playbackStateListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: BlocBuilder<BookDetailBloc, BookDetailState>(
        builder: (context, state) {
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(
                  20.0,
                  20.0,
                  20.0,
                  bloc.state.url != null ? 20 : 20,
                ),
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Flexible(
                          child: Hero(
                            tag: "${widget.book.id}_image",
                            child: CachedNetworkImage(
                              imageUrl: widget.book.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: BookTitle(widget.book.title)),
                              Text(
                                "${widget.book.author}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "Total time: ${widget.book.totalTime}",
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      final audios = bloc.state.audioFiles;
                      if (audios.isNotEmpty) {
                        return Column(
                          children: audios
                              .map(
                                (item) => ListTile(
                                  title: Text(item.title!),
                                  leading:
                                      const Icon(Icons.play_circle_filled),
                                  onTap: () async {
                                    final mediaItems = audios
                                        .map((chapter) => MediaItem(
                                              id: chapter.url ?? '',
                                              album: widget.book.title,
                                              title: chapter.name ?? '',
                                              extras: {
                                                'url': chapter.url,
                                                'bookId': chapter.bookId
                                              },
                                            ))
                                        .toList();

                                    await audioHandler
                                        .updateQueue(mediaItems);
                                    await audioHandler.skipToQueueItem(
                                        audios.indexOf(item));
                                    audioHandler.play();

                                    di.get<BookDetailBloc>().add(
                                          ChangeAudioUrlEvent(
                                            title: item.title ?? "",
                                            url: item.url ?? "",
                                          ),
                                        );
                                  },
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return const LoadingWidget();
                      }
                    },
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.grey.shade100,
                  child: const PlayerService(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
