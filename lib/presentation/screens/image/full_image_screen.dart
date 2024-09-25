import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:go_router/go_router.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen(
      {super.key,
      // required this.child,
      required this.tag,
      required this.disableSwipeToDismiss,
      this.backgroundColor = Colors.black,
      this.backgroundIsTransparent = true,
      this.disposeLevel = DisposeLevel.medium,
      required this.imageSourceType,
      this.url,
      this.assetPath,
      this.filePath,
      this.headers});

  // final Widget child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;
  final DisposeLevel? disposeLevel;
  final String tag;
  final bool disableSwipeToDismiss;

  final ImageSourceType imageSourceType;
  final String? url;
  final String? assetPath;
  final String? filePath;
  final Map<String, String>? headers;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  double? _initialPositionY = 0;

  double? _currentPositionY = 0;

  double _positionYDelta = 0;

  double _opacity = 1;

  double _disposeLimit = 150;

  Duration _animationDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    setDisposeLevel();
  }

  setDisposeLevel() {
    if (widget.disposeLevel == DisposeLevel.high) {
      _disposeLimit = 300;
    } else if (widget.disposeLevel == DisposeLevel.medium) {
      _disposeLimit = 200;
    } else {
      _disposeLimit = 100;
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPositionY = details.globalPosition.dy;
      _positionYDelta = _currentPositionY! - _initialPositionY!;
      setOpacity();
    });
  }

  void _dragStart(DragStartDetails details) {
    setState(() {
      _initialPositionY = details.globalPosition.dy;
    });
  }

  _dragEnd(DragEndDetails details) {
    if (_positionYDelta > _disposeLimit || _positionYDelta < -_disposeLimit) {
      context.pop();
    } else {
      setState(() {
        _animationDuration = kRouteDuration;
        _opacity = 1;
        _positionYDelta = 0;
      });

      Future.delayed(_animationDuration).then((_) {
        setState(() {
          _animationDuration = Duration.zero;
        });
      });
    }
  }

  setOpacity() {
    final double tmp = _positionYDelta < 0
        ? 1 - ((_positionYDelta / 1000) * -1)
        : 1 - (_positionYDelta / 1000);
    if (kDebugMode) {
      print(tmp);
    }

    if (tmp > 1) {
      _opacity = 1;
    } else if (tmp < 0) {
      _opacity = 0;
    } else {
      _opacity = tmp;
    }

    if (_positionYDelta > _disposeLimit || _positionYDelta < -_disposeLimit) {
      _opacity = 1;
    }
  }

  Widget _buildFullScreenImageWidget() {
    switch (widget.imageSourceType) {
      case ImageSourceType.url:
        return _buildNetworkImage();
      case ImageSourceType.asset:
        return _buildAssetImage();
      case ImageSourceType.file:
        return _buildFileImage();
    }
  }

  /// Returns a widget for displaying a network image.
  Widget _buildNetworkImage() {
    return Image.network(
      widget.url!,
      headers: widget.headers,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  /// Returns a widget for displaying an asset image.
  Widget _buildAssetImage() {
    return Image.asset(
      widget.assetPath!,
    );
  }

  /// Returns a widget for displaying a file image.
  Widget _buildFileImage() {
    return Image.file(
      File(widget.filePath!),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('tag FullScreenViewer ${widget.tag.hashCode}');
    final horizontalPosition = 0 + max(_positionYDelta, -_positionYDelta) / 15;
    return Hero(
      tag: widget.tag,
      child: Scaffold(
        backgroundColor: widget.backgroundIsTransparent
            ? Colors.transparent
            : widget.backgroundColor,
        body: Container(
          color: widget.backgroundColor.withOpacity(_opacity),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: _animationDuration,
                curve: Curves.fastOutSlowIn,
                top: 0 + _positionYDelta,
                bottom: 0 - _positionYDelta,
                left: horizontalPosition,
                right: horizontalPosition,
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  panEnabled: false,
                  child: widget.disableSwipeToDismiss
                      ? ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(0),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: _buildFullScreenImageWidget(),
                        )
                      : KeymotionGestureDetector(
                          onStart: (details) => _dragStart(details),
                          onUpdate: (details) => _dragUpdate(details),
                          onEnd: (details) => _dragEnd(details),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: _buildFullScreenImageWidget(),
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 30, 0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        color: Color(0xff222222),
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.clear,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeymotionGestureDetector extends StatelessWidget {
  /// @macro
  const KeymotionGestureDetector({
    super.key,
    required this.child,
    this.onUpdate,
    this.onEnd,
    this.onStart,
  });

  final Widget child;
  final GestureDragUpdateCallback? onUpdate;
  final GestureDragEndCallback? onEnd;
  final GestureDragStartCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: <Type, GestureRecognizerFactory>{
      VerticalDragGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer()
          ..onStart = onStart
          ..onUpdate = onUpdate
          ..onEnd = onEnd,
        (instance) {},
      ),
      // DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
      //   () => DoubleTapGestureRecognizer()..onDoubleTap = onDoubleTap,
      //   (instance) {},
      // )
    }, child: child);
  }
}
