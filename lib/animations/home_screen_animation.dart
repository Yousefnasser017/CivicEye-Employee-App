import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[500]! : Colors.grey[100]!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildTitleShimmer(
                    width: 150,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildCardShimmer(
                    height: 80,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleShimmer(
                    width: 120,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildStatsGridShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleShimmer(
                    width: 100,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                const SizedBox(height: 12),
                _buildReportsListShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleShimmer({
    required double width,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 24,
        width: width,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildDividerShimmer({
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 1,
        width: double.infinity,
        color: baseColor,
      ),
    );
  }

  Widget _buildCardShimmer({
    required double height,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatsGridShimmer({
    required Color baseColor,
    required Color highlightColor,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsListShimmer({
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _buildCardShimmer(
              height: 70, baseColor: baseColor, highlightColor: highlightColor),
        ),
      ),
    );
  }
}
