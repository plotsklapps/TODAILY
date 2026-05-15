import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late final List<String> _imagePaths = List<String>.from(widget.initialImages);
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_imagePaths.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 images allowed')),
      );
      return;
    }
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          itemCount: _imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Image.file(
                  File(_imagePaths[index]),
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
                      setState(() {
                        _imagePaths.removeAt(index);
                      });
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
                  if (_imagePaths.isEmpty) {
                    ToastService.showWarning(
                      title: 'Select an Image',
                      subtitle:
                          'Please add between 1 and 6 images to illustrate '
                          'your day.',
                    );
                    return;
                  } else {
                    widget.onSave(_imagePaths);
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
