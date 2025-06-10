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
              _buildTitleShimmer(width: 150, baseColor: baseColor, highlightColor: highlightColor),
              const SizedBox(height: 12),
              _buildDividerShimmer(baseColor: baseColor, highlightColor: highlightColor),
              const SizedBox(height: 12),
              _buildCardShimmer(height: 80, baseColor: baseColor, highlightColor: highlightColor),
            ],
          ),
        ),
      ),

        // Shimmer لإحصائيات البلاغات
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان "إحصائيات البلاغات"
                _buildTitleShimmer(width: 120,
                  baseColor: baseColor,
                  highlightColor: highlightColor),
                const SizedBox(height: 12),
                // الخط الفاصل
                _buildDividerShimmer(
                  baseColor: baseColor, highlightColor: highlightColor),
                const SizedBox(height: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان "أحدث البلاغات"
                _buildTitleShimmer(width: 100,
                  baseColor: baseColor,
                  highlightColor: highlightColor),
                const SizedBox(height: 12),
                // الخط الفاصل
                _buildDividerShimmer(
                  baseColor: baseColor, highlightColor: highlightColor),
                const SizedBox(height: 12),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // عنوان البلاغ
          _buildInfoCardShimmer(baseColor, highlightColor),

          // الموقع
          _buildInfoCardShimmer(baseColor, highlightColor, hasTrailing: true),

          // الوقت
          _buildInfoCardShimmer(baseColor, highlightColor),

          // تاريخ البلاغ
          _buildInfoCardShimmer(baseColor, highlightColor),

          // وصف البلاغ (أطول قليلاً)
          _buildInfoCardShimmer(baseColor, highlightColor, isDescription: true),

          // معلومات الاتصال
          _buildInfoCardShimmer(baseColor, highlightColor),

          // كارد حالة البلاغ
          _buildStatusCardShimmer(baseColor, highlightColor),

          const SizedBox(height: 20),

          // زر تحديث الحالة
          _buildButtonShimmer(baseColor, highlightColor),
        ],
      ),
    );
  }

  Widget _buildInfoCardShimmer(
    Color baseColor,
    Color highlightColor, {
    bool hasTrailing = false,
    bool isDescription = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي (الأيقونة + العنوان + trailing إذا وجد)
              Row(
                children: [
                  // الأيقونة
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // العنوان
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  // trailing icon إذا وجد
                  if (hasTrailing)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // القيمة
              Container(
                width: double.infinity,
                height: isDescription ? 40 : 20, // وصف أطول
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCardShimmer(Color baseColor, Color highlightColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي (الأيقونة + العنوان)
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // كونتينر الحالة
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonShimmer(Color baseColor, Color highlightColor) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: 160,
          height: 60,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}


