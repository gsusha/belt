import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  Uint8List? result;

  int sliderIndex = 0;

  double saturation = 1;
  double brightness = 1;
  double contrast = 1;

  bool isEdit = true;

  Future<void> crop() async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();

    if (rect == null) {
      return;
    }

    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;

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

    final newResult = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    setState(() {
      result = newResult;
    });
  }

  Future<void> save() async {
    crop();
    if (result != null) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      Directory('${appDocDirectory.path}/saved')
          .create(recursive: true)
          .then((Directory directory) {
            print(directory);
        File('${directory.path}/my_image.png').writeAsBytes(result!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Редактировать',
          style: Styles.titleStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(isEdit ? Icons.brightness_6_outlined : Icons.crop),
            onPressed: () => setState(() {
              isEdit = !isEdit;
              result = null;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: save,
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            ExtendedImage(
              extendedImageEditorKey: editorKey,
              mode: ExtendedImageMode.editor,
              fit: BoxFit.contain,
              initEditorConfigHandler: (_) => EditorConfig(
                maxScale: 8.0,
                cropRectPadding: const EdgeInsets.all(20.0),
                hitTestSize: 20.0,
              ),
              image: ExtendedFileImageProvider(
                File(widget.file.path),
                cacheRawData: true,
              ),
            ),
            if (result != null && !isEdit)
              Positioned.fill(child: Image.memory(result!))
          ],
        ),
      ),
      bottomNavigationBar: isEdit
          ? _ImageSettings(editorKey: editorKey)
          : _ColorSettings(
              saturation: saturation,
              brightness: brightness,
              contrast: contrast,
              onSaturationChanged: (v) => setState(() {
                saturation = v;
                crop();
              }),
              onBrightnessChanged: (v) => setState(() => brightness = v),
              onContrastChanged: (v) => setState(() => contrast = v),
            ),
    );
  }
}

class _ColorSettings extends StatelessWidget {
  final double saturation;
  final ValueChanged<double> onSaturationChanged;
  final double brightness;
  final ValueChanged<double> onBrightnessChanged;
  final double contrast;
  final ValueChanged<double> onContrastChanged;

  const _ColorSettings({
    required this.saturation,
    required this.brightness,
    required this.contrast,
    required this.onSaturationChanged,
    required this.onBrightnessChanged,
    required this.onContrastChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.bgDark,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseSlider(
            label: 'Насыщенность',
            value: saturation,
            onChanged: onSaturationChanged,
          ),
          BaseSlider(
            label: 'Яркость',
            value: brightness,
            onChanged: onBrightnessChanged,
          ),
          BaseSlider(
            label: 'Контрасность',
            value: contrast,
            onChanged: onContrastChanged,
          ),
        ],
      ),
    );
  }
}

class _ImageSettings extends StatelessWidget {
  final GlobalKey<ExtendedImageEditorState> editorKey;

  const _ImageSettings({required this.editorKey});

  void flip() {
    editorKey.currentState?.flip();
  }

  void rotate(bool right) {
    editorKey.currentState?.rotate(right: right);
  }

  void reset() {
    editorKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.bgDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
              IconButton(
                onPressed: reset,
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
