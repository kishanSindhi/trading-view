import 'package:flutter/material.dart';

class AppConstants {
  static const String binanceBaseUrl = 'https://api.binance.com/api/v3';

  static const String binanceWsUrl =
      'wss://stream.binance.com:9443/stream?streams='
      'btcusdt@miniTicker/'
      'ethusdt@miniTicker/'
      'bnbusdt@miniTicker/'
      'solusdt@miniTicker/'
      'xrpusdt@miniTicker/'
      'adausdt@miniTicker/'
      'dogeusdt@miniTicker/'
      'maticusdt@miniTicker/'
      'dotusdt@miniTicker/'
      'ltcusdt@miniTicker';

  static const List<String> defaultSymbols = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'SOLUSDT',
    'XRPUSDT',
    'ADAUSDT',
    'DOGEUSDT',
    'MATICUSDT',
    'DOTUSDT',
    'LTCUSDT',
  ];

  static const Map<String, String> cryptoNames = {
    'BTCUSDT': 'Bitcoin',
    'ETHUSDT': 'Ethereum',
    'BNBUSDT': 'BNB',
    'SOLUSDT': 'Solana',
    'XRPUSDT': 'XRP',
    'ADAUSDT': 'Cardano',
    'DOGEUSDT': 'Dogecoin',
    'MATICUSDT': 'Polygon',
    'DOTUSDT': 'Polkadot',
    'LTCUSDT': 'Litecoin',
  };
}

class AppColors {
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1F5);
  static const Color primary = Color(0xFF5B67CA);
  static const Color primaryLight = Color(0xFFEEF0FA);
  static const Color gain = Color(0xFF00C896);
  static const Color gainLight = Color(0xFFE6FAF5);
  static const Color loss = Color(0xFFFF4757);
  static const Color lossLight = Color(0xFFFFECEE);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color shimmer = Color(0xFFE8EAED);
}
