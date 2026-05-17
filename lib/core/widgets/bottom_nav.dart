import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BharatNovaBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onFabTap;

  const BharatNovaBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 62,
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.home_rounded,
                      isActive: selectedIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.search_rounded,
                      isActive: selectedIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  Expanded(
                    child: _NavLogoItem(
                      isActive: selectedIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  // Space reserved for the centre FAB
                  const SizedBox(width: 68),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.slow_motion_video_outlined,
                      isActive: selectedIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.notifications_outlined,
                      isActive: selectedIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ),
                  Expanded(
                    child: _NavAvatar(
                      isActive: selectedIndex == 5,
                      onTap: () => onTap(5),
                    ),
                  ),
                ],
              ),
            ),

            // Centre FAB — floats 18 px above the bar's top edge
            Positioned(
              top: -18,
              left: 0,
              right: 0,
              child: Center(child: _CenterFab(onTap: onFabTap)),
            ),
          ],
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Icon(
          icon,
          size: 25,
          color: isActive ? AppColors.primaryCLR : AppColors.blueGrey,
        ),
      ),
    );
  }
}


class _NavLogoItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _NavLogoItem({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Image.asset(
          'assets/images/BN.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}


class _NavAvatar extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _NavAvatar({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.blueGrey, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCLR.withValues(alpha: isActive ? 0.28 : 0.0),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://i.pravatar.cc/150?img=12',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmerBase,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: AppColors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _CenterFab extends StatelessWidget {
  final VoidCallback? onTap;
  const _CenterFab({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        height: 76,
        child: Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryCLR,
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.primaryCLR.withValues(alpha: 0.55),
              //     blurRadius: 20,
              //     spreadRadius: 1,
              //     offset: const Offset(0, 7),
              //   ),
              //   BoxShadow(
              //     color: AppColors.primaryCLR.withValues(alpha: 0.2),
              //     blurRadius: 6,
              //     spreadRadius: 4,
              //   ),
              // ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.whiteCLR,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

