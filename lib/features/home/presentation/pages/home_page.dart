import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/bottom_nav.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _selectedIndex = ValueNotifier<int>(0);
  final _navVisible = ValueNotifier<bool>(true);

  late final _pages = <Widget>[
    FeedPage(navVisible: _navVisible),                     // 0 — Home
    const _ComingSoonPage(label: 'Search'),                // 1 — Search
    const _ComingSoonPage(label: AppStrings.nova),         // 2 — BN Logo
    const _ComingSoonPage(label: AppStrings.shorts),       // 3 — History / Shorts
    const _ComingSoonPage(label: 'Notifications'),         // 4 — Bell
    const _ComingSoonPage(label: AppStrings.settings),     // 5 — Profile / Settings
  ];

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(const LocationFetchRequested());
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    _navVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BharatNovaAppBar(),
      body: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (_, index, __) => IndexedStack(
              index: index,
              children: _pages,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<bool>(
              valueListenable: _navVisible,
              builder: (_, visible, child) => AnimatedSlide(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                offset: visible ? Offset.zero : const Offset(0, 1),
                child: child!,
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (_, index, __) => BharatNovaBottomNav(
                  selectedIndex: index,
                  onTap: (i) {
                    _selectedIndex.value = i;
                    _navVisible.value = true;
                  },
                  onFabTap: () {
                    _navVisible.value = true;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  final String label;
  const _ComingSoonPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '$label — ${AppStrings.comingSoon}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
