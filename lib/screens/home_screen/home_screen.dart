import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_view/screens/home_screen/bloc/home_market_bloc.dart';
import 'package:trading_view/services/binance_data_service.dart';
import 'package:trading_view/services/dio_service.dart';
import 'package:trading_view/widgets/crypto_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeMarketBloc(
        dioService: context.read<DioService>(),
        binanceDataService: context.read<BinanceDataService>(),
      )..add(GetInitialData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trading View (Crypto)'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeMarketBloc, HomeMarketState>(
          builder: (context, state) {
            if (state is HomeMarketLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeMarketError) {
              return Center(child: Text(state.error));
            }
            if (state is HomeMarketLoaded) {
              return ListView.builder(
                itemCount: state.stocks.length,
                itemBuilder: (context, index) {
                  final ticker = state.stocks[index];
                  final livePrice = state.livePrices[ticker.symbol];

                  return CryptoTile(
                    ticker: ticker,
                    livePrice: livePrice?.toString(),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
