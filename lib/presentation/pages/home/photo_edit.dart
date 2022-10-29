import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../styles.dart';

class PhotoEdit extends StatefulWidget {
  final XFile file;

  const PhotoEdit({super.key, required this.file});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

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
      // body: Image.file(File(widget.file.path)),
      bottomNavigationBar: Container(
        color: Styles.bgDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _buildCon,
                  icon: const Icon(Icons.brightness_6_outlined),
                ),
                IconButton(
                  onPressed: _buildBrightness,
                  icon: const Icon(Icons.sunny),
                ),
                IconButton(
                  onPressed: _buildSat,
                  icon: const Icon(Icons.brightness_4),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SliderTheme(
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: switchSlider(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget switchSlider(int type) {
    switch (type) {
      case 1:
        return _buildSat();
      case 2:
        return _buildBrightness();
      case 3:
        return _buildCon();
      default:
        return const SizedBox();
    }
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
    final Uint8List? img = state.rawImageData;

    if (img == null) {
      print('The img is null.');
      return;
    }

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.addOption(ColorOption.saturation(sat));
    option.addOption(ColorOption.brightness(bright));
    option.addOption(ColorOption.contrast(con));

    option.outputFormat = const OutputFormat.png(88);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result?.length}');

    final Duration diff = DateTime.now().difference(start);

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

  double sat = 1;
  double bright = 1;
  double con = 1;

  Widget _buildSat() {
    return Slider(
      label: 'Насыщенность : ${sat.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          sat = value;
        });
      },
      value: sat,
      min: 0,
      max: 2,
    );
  }

  Widget _buildBrightness() {
    return Slider(
      label: 'Яркость : ${bright.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          bright = value;
        });
      },
      value: bright,
      min: 0,
      max: 2,
    );
  }

  Widget _buildCon() {
    return Slider(
      label: 'Контрастность : ${con.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          con = value;
        });
      },
      value: con,
      min: 0,
      max: 4,
    );
  }
}
