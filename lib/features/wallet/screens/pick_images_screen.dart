import 'dart:io';
import 'dart:math';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';
import '../widgets/pick_image_button.dart';

class PickImagesScreen extends StatefulWidget {
  const PickImagesScreen({
    super.key,
    required this.title,
    required this.onSubmit,
  });

  final String title;
  final void Function(List<File> images) onSubmit;

  @override
  State<PickImagesScreen> createState() => _PickImagesScreenState();
}

class _PickImagesScreenState extends State<PickImagesScreen> {
  List<File> images = [];
  final scrollController = ScrollController();
  static const maxImages = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pick Images'),
          actions: [
            IconButton(
              onPressed: () {
                context.pop();
                widget.onSubmit(images);
              },
              color: Colors.green,
              icon: const Icon(Icons.check),
            ),
            AppSizes.smallX,
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          padding: AppPaddings.normalXY,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: context.textTheme.displayLarge,
              ),
              AppSizes.normalY,
              Text(
                'You can select upto $maxImages images (${images.length} of $maxImages)',
              ),
              AppSizes.smallY,
              AppSizes.normalY,
              if (images.length < maxImages)
                PickImageButton(
                  onPicked: (newfiles) {
                    final remaining = maxImages - images.length;
                    final n = min(newfiles.length, remaining);
                    newfiles = newfiles.sublist(0, n);
                    images.addAll(newfiles);
                    setState(() {});
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent + 300,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                    );
                  },
                ),
              AppSizes.normalY,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: images.length,
                separatorBuilder: (_, i) => AppSizes.normalY,
                itemBuilder: (_, i) {
                  final bytes = images[i].readAsBytesSync();

                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final imgProvider = MemoryImage(bytes);
                            showImageViewer(context, imgProvider, immersive: false, doubleTapZoomable: true);
                          },
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Image.memory(bytes, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: InkWell(
                            onTap: () => setState(() => images.removeAt(i)),
                            child: const Icon(Icons.cancel, color: ErrorColor.normal),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
