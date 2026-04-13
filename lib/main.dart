import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/root_screen.dart';
import 'services/animal_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AgrotrilhoApp());
}

class AgrotrilhoApp extends StatelessWidget {
  const AgrotrilhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnimalService(),
      child: MaterialApp(
        title: 'Agrotrilho',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const RootScreen(),
      ),
    );
  }
}