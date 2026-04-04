part of 'home_market_bloc.dart';

sealed class HomeMarketState {}

final class HomeMarketInitial extends HomeMarketState {}

final class HomeMarketLoading extends HomeMarketState {}

class HomeMarketLoaded extends HomeMarketState {
  final List<Stock> stocks;

  /// Latest trade prices from WebSocket keyed by symbol.
  final Map<String, double> livePrices;

  HomeMarketLoaded({required this.stocks, required this.livePrices});

  HomeMarketLoaded copyWith({
    List<Stock>? stocks,
    Map<String, double>? livePrices,
  }) {
    return HomeMarketLoaded(
      stocks: stocks ?? this.stocks,
      livePrices: livePrices ?? this.livePrices,
    );
  }

  /// Resolves the effective display price for [symbol]:
  /// WebSocket live price takes precedence over the REST quote price.
  double displayPrice(String symbol) {
    if (livePrices.containsKey(symbol)) return livePrices[symbol]!;
    try {
      return stocks.firstWhere((s) => s.symbol == symbol).currentPrice;
    } catch (_) {
      return 0;
    }
  }
}

final class HomeMarketError extends HomeMarketState {
  final String error;
  HomeMarketError(this.error);
}
