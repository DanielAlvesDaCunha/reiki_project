import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/disclaimer/disclaimer_viewmodel.dart';
import 'viewmodels/symbol/symbol_viewmodel.dart';
import 'views/pages/disclaimer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  setupDependencies();
  runApp(const ReikiApp());
}

class ReikiApp extends StatelessWidget {
  const ReikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DisclaimerViewModel>(
          create: (_) => sl<DisclaimerViewModel>(),
        ),
        BlocProvider<SymbolViewModel>(
          create: (_) => sl<SymbolViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Conecn\'t Reiki',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const DisclaimerPage(),
      ),
    );
  }
}
