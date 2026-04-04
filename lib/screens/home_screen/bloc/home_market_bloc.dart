import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:trading_view/app_constants.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/services/binance_data_service.dart';
import 'package:trading_view/services/dio_service.dart';

part 'home_market_event.dart';
part 'home_market_state.dart';

class HomeMarketBloc extends Bloc<HomeMarketEvent, HomeMarketState> {
  final DioService dioService;
  final BinanceDataService binanceDataService;

  HomeMarketBloc({required this.dioService, required this.binanceDataService})
    : super(HomeMarketInitial()) {
    on<GetInitialData>(_onGetInitialData);
    on<MarketLivePriceReceived>(_onLivePriceReceived);
  }

  StreamSubscription<Map<String, double>>? _cryptoDataStream;

  Future<void> _onGetInitialData(
    HomeMarketEvent event,
    Emitter<HomeMarketState> emit,
  ) async {
    emit(HomeMarketLoading());
    try {
      final tickers = await dioService.getTickers(AppConstants.defaultSymbols);
      log("Got Ticks and starting the websocket", name: "_onGetInitialData");
      final stocks = AppConstants.defaultSymbols.map((symbol) {
        return Stock(
          profile: StockProfile.forCrypto(symbol),
          quote: tickers[symbol],
        );
      }).toList();
      binanceDataService.connect();
      emit(HomeMarketLoaded(stocks: stocks, livePrices: {}));
      _cryptoDataStream = binanceDataService.priceStream.listen((prices) {
        add(MarketLivePriceReceived(prices));
      });
    } catch (e) {
      emit(HomeMarketError(e.toString()));
    }
  }

  void _onLivePriceReceived(
    MarketLivePriceReceived event,
    Emitter<HomeMarketState> emit,
  ) {
    final current = state;
    if (current is! HomeMarketLoaded) return;

    final updated = {...current.livePrices, ...event.prices};
    emit(current.copyWith(livePrices: updated));
  }
}
