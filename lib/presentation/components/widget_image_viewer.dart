import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/util/util.dart';
import 'package:go_router/go_router.dart';

/// A widget that provides an interactive image viewer with support for different image sources.
class InstaImageViewer extends StatelessWidget {
  /// Private constructor to be used by the factory constructors.
  const InstaImageViewer._({
    required this.tag,
    required this.imageSourceType,
    this.imageUrl,
    this.assetPath,
    this.file,
    this.headers,
    this.backgroundColor = Colors.black,
    this.backgroundIsTransparent = true,
    this.disposeLevel,
    this.disableSwipeToDismiss = false,
    required this.child,
  });

  /// Hero tag to identify the Hero widget.
  final String tag;

  /// The source type of the image: URL, Asset, or File.
  final ImageSourceType imageSourceType;

  /// URL of the image, required if [imageSourceType] is [ImageSourceType.url].
  final String? imageUrl;

  /// Path to the asset image, required if [imageSourceType] is [ImageSourceType.asset].
  final String? assetPath;

  /// File object representing the image, required if [imageSourceType] is [ImageSourceType.file].
  final File? file;

  /// HTTP headers for network images.
  final Map<String, String>? headers;

  /// Background color for full-screen mode.
  final Color backgroundColor;

  /// Whether to make the background transparent in full-screen mode.
  final bool backgroundIsTransparent;

  /// Level of drag required to dismiss the image.
  final DisposeLevel? disposeLevel;

  /// Disables swipe-to-dismiss functionality if true.
  final bool disableSwipeToDismiss;

  /// Child widget displayed in the small preview.
  final Widget child;

  /// Factory constructor for network images.
  factory InstaImageViewer.network({
    required String tag,
    required String imageUrl,
    Map<String, String>? headers,
    Color backgroundColor = Colors.black,
    bool backgroundIsTransparent = true,
    DisposeLevel? disposeLevel,
    bool disableSwipeToDismiss = false,
    required Widget child,
  }) {
    return InstaImageViewer._(
      tag: tag,
      imageSourceType: ImageSourceType.url,
      imageUrl: imageUrl,
      headers: headers,
      backgroundColor: backgroundColor,
      backgroundIsTransparent: backgroundIsTransparent,
      disposeLevel: disposeLevel,
      disableSwipeToDismiss: disableSwipeToDismiss,
      child: child,
    );
  }

  /// Factory constructor for asset images.
  factory InstaImageViewer.asset({
    required String tag,
    required String assetPath,
    Color backgroundColor = Colors.black,
    bool backgroundIsTransparent = true,
    DisposeLevel? disposeLevel,
    bool disableSwipeToDismiss = false,
    required Widget child,
  }) {
    return InstaImageViewer._(
      tag: tag,
      imageSourceType: ImageSourceType.asset,
      assetPath: assetPath,
      backgroundColor: backgroundColor,
      backgroundIsTransparent: backgroundIsTransparent,
      disposeLevel: disposeLevel,
      disableSwipeToDismiss: disableSwipeToDismiss,
      child: child,
    );
  }

  /// Factory constructor for file images.
  factory InstaImageViewer.file({
    required String tag,
    required File file,
    Color backgroundColor = Colors.black,
    bool backgroundIsTransparent = true,
    DisposeLevel? disposeLevel,
    bool disableSwipeToDismiss = false,
    required Widget child,
  }) {
    return InstaImageViewer._(
      tag: tag,
      imageSourceType: ImageSourceType.file,
      file: file,
      backgroundColor: backgroundColor,
      backgroundIsTransparent: backgroundIsTransparent,
      disposeLevel: disposeLevel,
      disableSwipeToDismiss: disableSwipeToDismiss,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () => _openFullScreenViewer(context),
        child: child,
      ),
    );
  }

  /// Opens the full-screen image viewer with appropriate data.
  void _openFullScreenViewer(BuildContext context) {
    final viewerData = {
      'tag': tag,
      'backgroundColor': backgroundColor,
      'backgroundIsTransparent': backgroundIsTransparent,
      'disposeLevel': disposeLevel,
      'disableSwipeToDismiss': disableSwipeToDismiss,
      'data_url': imageUrl,
      'data_asset': assetPath,
      'data_file': file?.path,
      'source_type': imageSourceType,
      'headers': headers
    };

    context.pushNamed('fullScreenViewer', extra: viewerData);
  }
}
