import 'package:flutter/material.dart';
import 'package:trading_view/screens/home_screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_view/services/binance_data_service.dart';
import 'package:trading_view/services/dio_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (c) => DioService()),
        RepositoryProvider(create: (c) => BinanceDataService()),
      ],
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}
