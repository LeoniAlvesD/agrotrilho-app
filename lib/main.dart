import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/root_screen.dart';
import 'services/animal_service.dart';
import 'services/sanitary_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AgrotrilhoApp());
}

class AgrotrilhoApp extends StatelessWidget {
  const AgrotrilhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnimalService()),
        ChangeNotifierProvider(create: (_) => SanitaryService()),
      ],
      child: MaterialApp(
        title: 'Agrotrilho',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const RootScreen(),
      ),
    );
  }
}