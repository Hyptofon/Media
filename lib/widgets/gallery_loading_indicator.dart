import 'package:flutter/material.dart';

class GalleryLoadingIndicator extends StatelessWidget {
  const GalleryLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
