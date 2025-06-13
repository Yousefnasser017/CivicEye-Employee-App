// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[500]! : Colors.grey[100]!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                _buildTitleShimmer(
                    width: screenWidth * 0.38,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                _buildCardShimmer(
                    height: screenHeight * 0.09,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
              ],
            ),
          ),
        ),

        // Shimmer لإحصائيات البلاغات
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان "إحصائيات البلاغات"
                _buildTitleShimmer(
                    width: screenWidth * 0.3,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                // الخط الفاصل
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                // شبكة الإحصائيات
                _buildStatsGridShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
              ],
            ),
          ),
        ),

        // Shimmer لأحدث البلاغات
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان "أحدث البلاغات"
                _buildTitleShimmer(
                    width: screenWidth * 0.22,
                    baseColor: baseColor,
                    highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                // الخط الفاصل
                _buildDividerShimmer(
                    baseColor: baseColor, highlightColor: highlightColor),
                SizedBox(height: screenHeight * 0.015),
                // قائمة البلاغات
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
    final screenHeight = WidgetsBinding.instance.window.physicalSize.height /
        WidgetsBinding.instance.window.devicePixelRatio;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: screenHeight * 0.028,
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
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: screenWidth * 0.92,
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

