import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_view/app_constants.dart';
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
          title: const Text(
            'Watchlist',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [_CreateChecklistButton(), SizedBox(width: 16)],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              child: Row(
                spacing: 4,
                children: [_SearchTextfield(), _FilterButton()],
              ),
            ),
          ),
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
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: AppColors.border),
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

class _CreateChecklistButton extends StatelessWidget {
  const _CreateChecklistButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Icon(Icons.create_new_folder, color: AppColors.surface),
        ),
      ),
    );
  }
}

class _SearchTextfield extends StatelessWidget {
  const _SearchTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.border,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.filter_list));
  }
}
