import 'package:equatable/equatable.dart';
import '../app_constants.dart';

class StockQuote extends Equatable {
  final String symbol;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double high;
  final double low;
  final double open;
  final double previousClose;

  const StockQuote({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.open,
    required this.previousClose,
  });

  factory StockQuote.fromJson(String symbol, Map<String, dynamic> json) {
    return StockQuote(
      symbol: symbol,
      currentPrice: double.tryParse(json['lastPrice'] as String? ?? '') ?? 0,
      change: double.tryParse(json['priceChange'] as String? ?? '') ?? 0,
      changePercent:
          double.tryParse(json['priceChangePercent'] as String? ?? '') ?? 0,
      high: double.tryParse(json['highPrice'] as String? ?? '') ?? 0,
      low: double.tryParse(json['lowPrice'] as String? ?? '') ?? 0,
      open: double.tryParse(json['openPrice'] as String? ?? '') ?? 0,
      previousClose:
          double.tryParse(json['prevClosePrice'] as String? ?? '') ?? 0,
    );
  }

  bool get isPositive => change >= 0;

  @override
  List<Object?> get props => [symbol, currentPrice, change, changePercent];
}

class StockProfile extends Equatable {
  final String symbol;
  final String name;
  final String? logo;
  final String? industry;
  final String? currency;
  final String? country;
  final String? exchange;

  const StockProfile({
    required this.symbol,
    required this.name,
    this.logo,
    this.industry,
    this.currency,
    this.country,
    this.exchange,
  });

  factory StockProfile.forCrypto(String symbol) {
    return StockProfile(
      symbol: symbol,
      name: AppConstants.cryptoNames[symbol] ?? symbol,
      industry: 'Cryptocurrency',
      currency: 'USDT',
      exchange: 'Binance',
      country: 'Global',
    );
  }

  factory StockProfile.placeholder(String symbol) {
    return StockProfile(symbol: symbol, name: symbol);
  }

  @override
  List<Object?> get props => [symbol, name, logo, industry];
}

class Stock extends Equatable {
  final StockProfile profile;
  final StockQuote? quote;
  final double? livePrice;

  const Stock({required this.profile, this.quote, this.livePrice});

  String get symbol => profile.symbol;
  String get name => profile.name;
  String? get logo => profile.logo;
  String? get industry => profile.industry;
  String get currency => profile.currency ?? 'USDT';

  double get currentPrice => livePrice ?? quote?.currentPrice ?? 0;
  double get change => quote?.change ?? 0;
  double get changePercent => quote?.changePercent ?? 0;
  bool get isPositive => change >= 0;
  bool get hasData => quote != null || livePrice != null;

  Stock copyWith({StockQuote? quote, double? livePrice}) {
    return Stock(
      profile: profile,
      quote: quote ?? this.quote,
      livePrice: livePrice ?? this.livePrice,
    );
  }

  @override
  List<Object?> get props => [symbol, quote, livePrice];
}

class CandlePoint {
  final int timestamp;
  final double close;

  const CandlePoint({required this.timestamp, required this.close});
}
