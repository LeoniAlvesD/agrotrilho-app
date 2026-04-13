import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/animal_service.dart';
import 'screens/lista_animais.dart';
import 'utils/constants.dart';

void main() {
  runApp(const AgrotrilhoApp());
}

/// Aplicação principal do Agrotrilho
class AgrotrilhoApp extends StatelessWidget {
  const AgrotrilhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnimalService(),
      child: MaterialApp(
        title: AppMessages.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primaryGreen,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
          ),
          scaffoldBackgroundColor: AppColors.white,
          cardTheme: CardThemeData(
            elevation: AppDimensions.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
        ),
        home: const ListaAnimais(),
      ),
    );
  }
}