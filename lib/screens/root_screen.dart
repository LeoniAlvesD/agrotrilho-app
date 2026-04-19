import 'package:flutter/material.dart';
import 'home/home_screen.dart';

/// Root entry point — simply renders the Home screen which contains all
/// navigation buttons.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
