import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trading_view/app_constants.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/screens/crypto_detail_screen/bloc/crypto_detail_bloc.dart';
import 'package:trading_view/services/dio_service.dart';
import 'package:trading_view/widgets/crypto_line_chart.dart';
import 'package:trading_view/widgets/info_chip.dart';

class CryptoDetailScreen extends StatelessWidget {
  const CryptoDetailScreen({super.key, required this.currency});
  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CryptoDetailBloc(dioService: context.read<DioService>())
            ..add(GetCryptoDetailEvent(symbol: currency)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.cryptoNames[currency] ?? currency),
        ),
        body: BlocBuilder<CryptoDetailBloc, CryptoDetailState>(
          builder: (context, state) {
            if (state is CryptoDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CryptoDetailError) {
              return Center(child: Text(state.error));
            }
            if (state is CryptoDetailLoaded) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    if (state.hasChart) ...[
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ChartSection(state: state),
                      ),
                      const SizedBox(height: 28),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const TabBar(
                        tabs: [
                          Tab(text: "Overview"),
                          Tab(text: "Coin Info"),
                        ],
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        indicatorColor: AppColors.primary,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(color: Colors.transparent),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          if (state.stock.quote != null)
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _StockDetailsSection(
                                quote: state.stock.quote!,
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _CompanyInfoSection(
                              profile: state.stock.profile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final CryptoDetailLoaded state;
  const _ChartSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _PriceText(amount: state.stock.currentPrice),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '15 min',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        InfoChip(info: state.stock.profile.currency ?? "USD"),
        const SizedBox(height: 6),
        Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: CryptoLineChart(
            spots: state.chartSpots,
            minY: state.chartMin ?? 0,
            maxY: state.chartMax ?? 1,
            isPositive: state.stock.isPositive,
          ),
        ),
      ],
    );
  }
}

class _StockDetailsSection extends StatelessWidget {
  final StockQuote quote;
  const _StockDetailsSection({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 6),
            _StatRow(label: 'Open', value: quote.open),
            _StatRow(
              label: 'High',
              value: quote.high,
              highlight: true,
              positive: true,
            ),
            _StatRow(
              label: 'Low',
              value: quote.low,
              highlight: true,
              positive: false,
            ),
            _StatRow(label: 'Prev. Close', value: quote.previousClose),
          ],
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;
  final bool positive;

  _StatRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.positive = true,
  });

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formatCurrency.format(value),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyInfoSection extends StatelessWidget {
  final StockProfile profile;
  const _CompanyInfoSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final rows = <_InfoRow>[];
    if (profile.exchange != null) {
      rows.add(_InfoRow(label: 'Exchange', value: profile.exchange!));
    }
    if (profile.industry != null) {
      rows.add(_InfoRow(label: 'Industry', value: profile.industry!));
    }
    if (profile.country != null) {
      rows.add(_InfoRow(label: 'Country', value: profile.country!));
    }
    rows.add(_InfoRow(label: 'Currency', value: profile.currency ?? 'USD'));

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(children: [SizedBox(height: 6), ...rows]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceText extends StatelessWidget {
  final double amount;

  _PriceText({super.key, required this.amount});
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final parts = formatCurrency.format(amount).split('.');
    final intAmount = parts[0].replaceAll('\$', '');
    final decimal = parts[1];
    final textColor = AppColors.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '\$ ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ),

        Text(
          intAmount,
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            '.$decimal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
