import 'package:flutter/material.dart';

class BookTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const BookTitle(this.title, {Key? key, this.style}) : super(key: key);

  final TextStyle titleStyle = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.merge(
            titleStyle.merge(style),
          ),
    );
  }
}
