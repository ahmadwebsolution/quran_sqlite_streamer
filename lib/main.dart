import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/quran_viewmodel.dart';
import 'views/quran_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuranViewModel(),
      child: MaterialApp(
        title: 'Quran MVVM PoC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const QuranView(),
      ),
    );
  }
}