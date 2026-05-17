import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class FeedTabBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteCLR,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            labelColor: AppColors.primaryCLR,
            unselectedLabelColor: AppColors.blueGrey,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.only(bottom: 10),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryCLR,
                  width: 2,
                ),
              ),
            ),
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
            tabs: [
              Tab(text: AppStrings.post),
              Tab(text: AppStrings.nova),
              Tab(text: AppStrings.news),
              Tab(text: AppStrings.article),
            ],
          ),
          Divider(height: 1, thickness: 1, color: AppColors.blueGrey),
        ],
      ),
    );
  }
}
