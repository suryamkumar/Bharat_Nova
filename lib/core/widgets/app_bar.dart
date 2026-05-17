import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';
import '../../features/location/presentation/bloc/location_state.dart';

class BharatNovaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BharatNovaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: AppColors.whiteCLR,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: AppColors.primaryCLR, size: 24),
          ),
          title: Image.asset(
            'assets/images/bharat_nova_text.png',
            height: 100,
          ),
          actions: [
            BlocBuilder<LocationBloc, LocationState>(
              builder: (_, state) {
                if (state is! LocationLoaded) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primaryCLR,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        state.location.city,
                        style: const TextStyle(
                          color: AppColors.primaryCLR,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
