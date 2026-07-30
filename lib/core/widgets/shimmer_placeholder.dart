import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ShimmerPlaceholder offers generic skeletal layouts to build loading states.
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  /// Factory helper for drawing circle load skeletons (e.g. avatars, icons).
  factory ShimmerPlaceholder.circle({
    Key? key,
    required double size,
  }) {
    return ShimmerPlaceholder(
      key: key,
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[700]!;
    final highlightColor = theme.brightness == Brightness.light
        ? Colors.grey[100]!
        : Colors.grey[600]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}
