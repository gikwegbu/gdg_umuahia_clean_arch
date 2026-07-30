import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator registrations (GetIt) and local storage (Hive)
  await setupLocator();

  runApp(const App());
}
