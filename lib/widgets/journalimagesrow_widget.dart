import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todaily/themes/iconlibrary.dart';

class JournalImagesRow extends StatelessWidget {
  const JournalImagesRow({
    required this.imagePaths,
    super.key,
  });

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (imagePaths.isEmpty) return const SizedBox.shrink();

    final List<String> images = imagePaths.take(6).toList();
    final double screenWidth = MediaQuery.sizeOf(context).width;

    // We want to fit all images in a row.
    // Assuming the row has a fixed height of 100 and a little spacing of 4px.
    // If we have N images, we have N-1 gaps of 4px.
    final int count = images.length;
    final double totalSpacing = (count - 1) * 4.0;

    // Calculate width per image: (AvailableWidth - TotalSpacing) / Count
    // We cap it at 120px to prevent images from getting too huge.
    final double imageWidth = ((screenWidth - 64 - totalSpacing) / count).clamp(
      0.0,
      120.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: images.map((String path) {
        return Padding(
          padding: EdgeInsets.only(right: images.last == path ? 0 : 4),
          child: SizedBox(
            width: imageWidth,
            height: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return ColoredBox(
                        color: theme.colorScheme.error,
                        child: IconLibrary.iconBrokenImage,
                      );
                    },
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
