import 'package:audiobook_app/feature/data/model/book_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final BuildContext context;
  final BookModel book;
  final Function() onOpenDetailTap;

  const BookItem({
    super.key,
    required this.context,
    required this.book,
    required this.onOpenDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(book.title),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(book.image),
          ),
          onTap: onOpenDetailTap,
        ),
        const Divider(),
      ],
    );
  }
}
