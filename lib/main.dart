import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/constants/app_colors.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'features/feed/presentation/bloc/feed_bloc.dart';
import 'features/location/presentation/bloc/location_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await initDependencies();

  await [Permission.location, Permission.notification].request();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FeedBloc>()),
        BlocProvider(create: (_) => sl<LocationBloc>()),
      ],
      child: const BharatNovaApp(),
    ),
  );
}

class BharatNovaApp extends StatelessWidget {
  const BharatNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BharatNova',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryCLR,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryCLR,
          foregroundColor: AppColors.whiteCLR,
          elevation: 0,
        ),
      ),
    );
  }
}
