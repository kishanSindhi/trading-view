part of 'crypto_detail_bloc.dart';

sealed class CryptoDetailEvent {}

class GetCryptoDetailEvent extends CryptoDetailEvent {
  final String symbol;
  GetCryptoDetailEvent({required this.symbol});
}
