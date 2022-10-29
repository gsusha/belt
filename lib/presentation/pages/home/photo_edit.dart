import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../styles.dart';
import '../../widgets/base_slider.dart';

class PhotoEdit extends StatefulWidget {
  final XFile file;

  const PhotoEdit({super.key, required this.file});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  int sliderIndex = 0;

  double saturation = 1;
  double brightness = 1;
  double contrast = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Редактировать изображение',
          style: Styles.titleStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await crop();
            },
          ),
        ],
      ),
      body: ExtendedImage(
        key: editorKey,
        mode: ExtendedImageMode.editor,
        fit: BoxFit.contain,
        image: ExtendedFileImageProvider(
          File(widget.file.path),
          cacheRawData: true,
        ),
      ),
      bottomSheet: Container(
        color: Styles.bgDark,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseSlider(
                label: 'Насыщенность',
                value: saturation,
                onChanged: (v) => setState(() => saturation = v),
              ),
              BaseSlider(
                label: 'Яркость',
                value: brightness,
                onChanged: (v) => setState(() => brightness = v),
              ),
              BaseSlider(
                label: 'Контрасность',
                value: contrast,
                onChanged: (v) => setState(() => contrast = v),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Styles.bgDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: crop,
              icon: const Icon(Icons.crop),
            ),
            IconButton(
              onPressed: flip,
              icon: const Icon(Icons.flip),
            ),
            IconButton(
              onPressed: () => rotate(false),
              icon: const Icon(Icons.rotate_right),
            ),
            IconButton(
              onPressed: () => rotate(true),
              icon: const Icon(Icons.rotate_left),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();
    if (rect == null) {
      print('The crop rect is null.');
      return;
    }
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.addOption(ColorOption.saturation(saturation));
    option.addOption(ColorOption.brightness(brightness));
    option.addOption(ColorOption.contrast(contrast));

    option.outputFormat = const OutputFormat.png(88);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result?.length}');

    if (result == null) return;

    showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState?.flip();
  }

  void rotate(bool right) {
    editorKey.currentState?.rotate(right: right);
  }

  void showPreviewDialog(Uint8List image) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox.fromSize(
              size: const Size.square(200),
              child: Container(
                child: Image.memory(image),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
