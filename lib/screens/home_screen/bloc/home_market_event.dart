part of 'home_market_bloc.dart';

sealed class HomeMarketEvent {}

class GetInitialData extends HomeMarketEvent {}

class CryptoLivePriceReceived extends HomeMarketEvent {
  final Map<String, double> prices;
  CryptoLivePriceReceived(this.prices);
}

class MarketLivePriceReceived extends HomeMarketEvent {
  final Map<String, double> prices;
  MarketLivePriceReceived(this.prices);
}
