import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_view/app_constants.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/screens/crypto_detail_screen/bloc/crypto_detail_bloc.dart';
import 'package:trading_view/services/dio_service.dart';
import 'package:trading_view/widgets/crypto_line_chart.dart';

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
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (state.hasChart) ...[
                      _ChartSection(state: state),
                      const SizedBox(height: 28),
                    ],
                    if (state.stock.quote != null) ...[
                      _StockDetailsSection(quote: state.stock.quote!),
                    ],
                    _CompanyInfoSection(profile: state.stock.profile),
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
            const Text(
              '24H Price',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: CryptoLineChart(
            spots: state.chartSpots,
            minY: state.chartMin,
            maxY: state.chartMax,
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
        const Text(
          'Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
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

  const _StatRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Coin Info',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Column(children: rows),
      ],
    );
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
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
