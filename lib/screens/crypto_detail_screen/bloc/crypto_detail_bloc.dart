import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/services/dio_service.dart';

part 'crypto_detail_event.dart';
part 'crypto_detail_state.dart';

class CryptoDetailBloc extends Bloc<CryptoDetailEvent, CryptoDetailState> {
  final DioService dioService;

  CryptoDetailBloc({required this.dioService}) : super(CryptoDetailInitial()) {
    on<GetCryptoDetailEvent>(_onGetCryptoDetailEvent);
  }

  Future<void> _onGetCryptoDetailEvent(
    GetCryptoDetailEvent event,
    Emitter<CryptoDetailState> emit,
  ) async {
    emit(CryptoDetailLoading());
    try {
      final results = await Future.wait([
        dioService.getTicker(event.symbol),
        dioService.getKlines(event.symbol),
      ]);

      final quote = results[0] as StockQuote?;
      final candles = results[1] as List<CandlePoint>;

      final stock = Stock(
        profile: StockProfile.forCrypto(event.symbol),
        quote: quote,
      );

      // Build fl_chart spots from 15-min close prices
      final spots = <FlSpot>[];
      double chartMin = double.infinity;
      double chartMax = double.negativeInfinity;

      for (int i = 0; i < candles.length; i++) {
        final price = candles[i].close;
        spots.add(FlSpot(i.toDouble(), price));
        if (price < chartMin) chartMin = price;
        if (price > chartMax) chartMax = price;
      }

      final hasChart = spots.length >= 10;

      emit(
        CryptoDetailLoaded(
          stock: stock,
          chartSpots: spots,
          chartMin: hasChart ? chartMin * 0.999 : 0,
          chartMax: hasChart ? chartMax * 1.001 : 100,
          hasChart: hasChart,
        ),
      );
    } catch (e) {
      emit(
        CryptoDetailError(error: 'Failed to load details.\n${e.toString()}'),
      );
    }
  }
}
