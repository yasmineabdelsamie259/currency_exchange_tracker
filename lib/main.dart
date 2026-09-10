import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'features/settings/presentation/bloc/theme_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureServiceLocator();
  serviceLocator<ThemeCubit>().load();
  runApp(const CurrencyExchangeApp());
}
