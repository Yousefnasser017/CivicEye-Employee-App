import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerReportCard extends StatelessWidget {
  const ShimmerReportCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: Colors.white,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
