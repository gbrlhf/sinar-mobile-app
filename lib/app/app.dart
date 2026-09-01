import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pju_provider.dart';
import '../screens/landing/landing_screen.dart';
import 'theme/app_theme.dart';

class SolarPjuApp extends StatelessWidget {
  const SolarPjuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PJUProvider()),
      ],
      child: MaterialApp(
        title: 'SINAR',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LandingScreen(),
      ),
    );
  }
}
