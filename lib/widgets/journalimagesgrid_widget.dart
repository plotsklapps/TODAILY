import 'dart:io';
import 'package:flutter/material.dart';

class JournalImagesGrid extends StatelessWidget {
  const JournalImagesGrid({
    required this.imagePaths,
    super.key,
  }) : assert(
         imagePaths.length >= 1 && imagePaths.length <= 6,
         'imagePaths must have between 1 and 6 elements',
       );
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) return const SizedBox.shrink();

    final int count = imagePaths.length;
    final int crossAxisCount = _getCrossAxisCount(count);
    final double aspectRatio = _getAspectRatio(count);

    return SizedBox(
      width: 120,
      height: 100,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: aspectRatio,
        ),
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(imagePaths[index]),
              fit: BoxFit.cover, // Fills the box as requested
              errorBuilder:
                  (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 20),
                  ),
            ),
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(int count) {
    if (count == 1) return 1;
    if (count <= 4) return 2;
    return 3;
  }

  double _getAspectRatio(int count) {
    // Total width: 120, Total height: 100
    // Gap: 4
    if (count == 1) {
      return 120 / 100; // 1.2
    } else if (count == 2) {
      // 2 columns, 1 row
      // Each width: (120 - 4) / 2 = 58
      // Each height: 100
      return 58 / 100;
    } else if (count <= 4) {
      // 2 columns, 2 rows
      // Each width: (120 - 4) / 2 = 58
      // Each height: (100 - 4) / 2 = 48
      return 58 / 48;
    } else {
      // 3 columns, 2 rows
      // Each width: (120 - 2 * 4) / 3 = 112 / 3 = 37.33
      // Each height: (100 - 4) / 2 = 48
      return 37.33 / 48;
    }
  }
}
