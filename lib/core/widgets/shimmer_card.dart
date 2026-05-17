import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "You Reposted" row
            Row(
              children: [
                _box(16, 16, radius: 3),
                const SizedBox(width: 4),
                _box(80, 13, radius: 4),
              ],
            ),
            const SizedBox(height: 8),

            // Header: avatar + 3-line info + time + more-vert
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _circle(50),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + verified badge
                      Row(
                        children: [
                          _box(120, 16, radius: 4),
                          const SizedBox(width: 6),
                          _circle(18),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // @username
                      _box(90, 12, radius: 3),
                      const SizedBox(height: 5),
                      // location
                      _box(100, 12, radius: 3),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // time
                _box(28, 13, radius: 4),
                const SizedBox(width: 4),
                // more_vert icon
                _box(24, 24, radius: 4),
              ],
            ),
            const SizedBox(height: 10),

            // Title — 3 lines
            _box(double.infinity, 15, radius: 4),
            const SizedBox(height: 6),
            _box(double.infinity, 15, radius: 4),
            const SizedBox(height: 6),
            _box(180, 15, radius: 4),
            const SizedBox(height: 6),

            // Read More
            _box(70, 13, radius: 4),
            const SizedBox(height: 10),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: _box(double.infinity, 200, radius: 0),
            ),
            const SizedBox(height: 10),

            // Action bar — 6 evenly spaced items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (_) => _actionItem()),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _actionItem() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _box(18, 18, radius: 3),
        const SizedBox(width: 3),
        _box(28, 12, radius: 3),
      ],
    );
  }

  Widget _box(double width, double height, {double radius = 0}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.shimmerBase,
        shape: BoxShape.circle,
      ),
    );
  }
}
