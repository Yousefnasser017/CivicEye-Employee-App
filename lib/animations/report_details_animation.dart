// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReportDetailsShimmer extends StatelessWidget {
  final bool isDarkMode;

  const ReportDetailsShimmer({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[500]! : Colors.grey[100]!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // عنوان البلاغ
          _buildInfoCardShimmer(baseColor, highlightColor,
              screenWidth: screenWidth),

          // الموقع
          _buildInfoCardShimmer(baseColor, highlightColor,
              hasTrailing: true, screenWidth: screenWidth),

          // الوقت
          _buildInfoCardShimmer(baseColor, highlightColor,
              screenWidth: screenWidth),

          // تاريخ البلاغ
          _buildInfoCardShimmer(baseColor, highlightColor,
              screenWidth: screenWidth),

          // وصف البلاغ (أطول قليلاً)
          _buildInfoCardShimmer(baseColor, highlightColor,
              isDescription: true, screenWidth: screenWidth),

          // معلومات الاتصال
          _buildInfoCardShimmer(baseColor, highlightColor,
              screenWidth: screenWidth),

          // كارد حالة البلاغ
          _buildStatusCardShimmer(baseColor, highlightColor,
              screenWidth: screenWidth),

          SizedBox(height: screenHeight * 0.03),

          // زر تحديث الحالة
          _buildButtonShimmer(baseColor, highlightColor,
              screenWidth: screenWidth, screenHeight: screenHeight),
        ],
      ),
    );
  }

  Widget _buildInfoCardShimmer(
    Color baseColor,
    Color highlightColor, {
    bool hasTrailing = false,
    bool isDescription = false,
    double screenWidth = 350,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الصف العلوي (الأيقونة + العنوان)
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.07,
                        height: screenWidth * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.012),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // العنوان
                      Container(
                        width: screenWidth * 0.22,
                        height: screenWidth * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.012),
                        ),
                      ),
                      Spacer(),
                      // trailing icon إذا وجد
                      if (hasTrailing)
                        Container(
                          width: screenWidth * 0.07,
                          height: screenWidth * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.012),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  // القيمة
                  Container(
                    width: double.infinity,
                    height: isDescription
                        ? screenWidth * 0.12
                        : screenWidth * 0.055, // وصف أطول
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(screenWidth * 0.012),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCardShimmer(Color baseColor, Color highlightColor,
      {double screenWidth = 350}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        return Container(
          margin: EdgeInsets.only(bottom: screenWidth * 0.04),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الصف العلوي (الأيقونة + العنوان)
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.07,
                        height: screenWidth * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.012),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Container(
                        width: screenWidth * 0.16,
                        height: screenWidth * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.012),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  // كونتينر الحالة
                  Container(
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.045,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(screenWidth * 0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonShimmer(Color baseColor, Color highlightColor,
      {double screenWidth = 350, double screenHeight = 700}) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: screenWidth * 0.42,
          height: screenHeight * 0.065,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.028),
          ),
        ),
      ),
    );
  }
}
