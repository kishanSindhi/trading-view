part of 'crypto_detail_bloc.dart';

sealed class CryptoDetailState {}

class CryptoDetailInitial extends CryptoDetailState {}

class CryptoDetailLoading extends CryptoDetailState {}

class CryptoDetailLoaded extends CryptoDetailState {
  final Stock stock;

  final List<FlSpot> chartSpots;
  final double chartMin;
  final double chartMax;
  final bool hasChart;

  CryptoDetailLoaded({
    required this.stock,
    required this.chartSpots,
    required this.chartMin,
    required this.chartMax,
    required this.hasChart,
  });
}

class CryptoDetailError extends CryptoDetailState {
  final String error;
  CryptoDetailError({required this.error});
}
