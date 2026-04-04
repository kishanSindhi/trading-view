import 'dart:convert';
import 'package:dio/dio.dart';
import '../app_constants.dart';
import '../models/stock.dart';

class DioService {
  late final Dio _dio;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.binanceBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// this will fetch the initial data when we land on the home screen
  /// and then we wilk start the web socket stream and update the data
  Future<Map<String, StockQuote>> getTickers(List<String> symbols) async {
    final symbolsParam = jsonEncode(
      symbols.map((s) => s.toUpperCase()).toList(),
    );
    final response = await _dio.get<List<dynamic>>(
      '/ticker/24hr',
      queryParameters: {'symbols': symbolsParam},
    );

    final result = <String, StockQuote>{};
    for (final item in response.data ?? []) {
      final ticker = item as Map<String, dynamic>;
      final symbol = ticker['symbol'] as String;
      result[symbol] = StockQuote.fromJson(symbol, ticker);
    }
    return result;
  }

  /// this will fetch the data for the single CRYPTO (when we click on particular CRYPTO)
  Future<StockQuote?> getTicker(String symbol) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/ticker/24hr',
      queryParameters: {'symbol': symbol.toUpperCase()},
    );
    if (response.data != null) {
      return StockQuote.fromJson(symbol, response.data!);
    }
    return null;
  }

  /// this will fetch the graph data for last 24 hrs and
  /// the interval used over here is 15 minss.
  Future<List<CandlePoint>> getKlines(String symbol) async {
    final response = await _dio.get<List<dynamic>>(
      '/klines',
      queryParameters: {
        'symbol': symbol.toUpperCase(),
        'interval': '15m',
        'limit': 96,
      },
    );

    return (response.data ?? []).map((kline) {
      final k = kline as List<dynamic>;
      return CandlePoint(
        timestamp: k[0] as int,
        close: double.tryParse(k[4] as String) ?? 0,
      );
    }).toList();
  }
}
