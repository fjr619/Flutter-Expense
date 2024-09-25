import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen({
    super.key,
    required this.imageProvider,
    required this.tag,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final String tag;
  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  bool isHeroAnimating = true;

  @override
  Widget build(BuildContext context) {
    log('isHeroAnimating $isHeroAnimating');
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoView(
            imageProvider: widget.imageProvider,
            backgroundDecoration: widget.backgroundDecoration,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.tag,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                animation.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    log("finish anim");
                    setState(() {
                      isHeroAnimating = false;
                    });
                  }
                });

                if (flightDirection == HeroFlightDirection.push) {
                  return toHeroContext.widget;
                } else {
                  return fromHeroContext.widget;
                }
              },
            ),
          ),
        ),
        if (!isHeroAnimating) ...{
          Positioned(
            top: 32,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.teal,
                size: 32,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        }
      ],
    );
  }
}
