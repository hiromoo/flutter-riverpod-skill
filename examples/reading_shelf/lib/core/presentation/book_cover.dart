import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  const BookCover({this.width = 76, this.height = 112, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
      child: Icon(Icons.menu_book_rounded, size: width * 0.42, color: scheme.onPrimaryContainer),
    );
  }
}
