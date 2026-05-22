import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todaily/services/signal_service.dart';
import 'package:todaily/services/toast_service.dart';
import 'package:todaily/themes/iconlibrary.dart';

class ImagePickerModal extends StatefulWidget {
  const ImagePickerModal({
    required this.onSave,
    this.initialImages = const <String>[],
    super.key,
  });
  final ValueChanged<List<String>> onSave;
  final List<String> initialImages;

  @override
  State<ImagePickerModal> createState() => _ImagePickerModalState();
}

class _ImagePickerModalState extends State<ImagePickerModal> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch previous images or create empty Signal.
    sSelectedImages.value = List<String>.from(widget.initialImages);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (sSelectedImages.value.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 images allowed')),
      );
      return;
    }
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final List<String> current = List<String>.from(sSelectedImages.value)
        ..add(pickedFile.path);
      sSelectedImages.value = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = sSelectedImages.watch(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: 'galleryFAB',
              onPressed: () async {
                await _pickImage(ImageSource.gallery);
              },
              label: Row(
                children: <Widget>[
                  IconLibrary.iconImage,
                  const SizedBox(width: 8),
                  const Text('Gallery'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              heroTag: 'cameraFAB',
              onPressed: () async {
                await _pickImage(ImageSource.camera);
              },
              label: Row(
                children: <Widget>[
                  IconLibrary.iconCamera,
                  const SizedBox(width: 8),
                  const Text('Camera'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Image.file(
                  File(imagePaths[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      final List<String> current = List<String>.from(
                        sSelectedImages.value,
                      )..removeAt(index);
                      sSelectedImages.value = current;
                    },
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton(
                onPressed: () {
                  if (imagePaths.isEmpty) {
                    ToastService.showWarning(
                      title: 'Select an Image',
                      subtitle:
                          'Please add between 1 and 6 images to illustrate '
                          'your day.',
                    );
                    return;
                  } else {
                    widget.onSave(imagePaths);
                  }
                },
                child: const Text('Save Journal Entry'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
