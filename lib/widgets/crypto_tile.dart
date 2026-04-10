import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trading_view/app_constants.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/screens/crypto_detail_screen/crypto_detail_screen.dart';
import 'package:trading_view/widgets/info_chip.dart';

class CryptoTile extends StatelessWidget {
  CryptoTile({super.key, required this.ticker, required this.livePrice});
  final Stock ticker;
  final String? livePrice;

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryptoDetailScreen(currency: ticker.symbol),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, AppColors.gain.withOpacity(0.2)],
            end: Alignment.centerRight,
            stops: [0.6, 1],
            begin: Alignment.centerLeft,
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            _TickerAvatar(tickerSymbol: ticker.symbol[0]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Text(
                      ticker.symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    InfoChip(info: ticker.profile.currency ?? "USD"),
                  ],
                ),
                Text(
                  AppConstants.cryptoNames[ticker.symbol] ?? ticker.symbol,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Spacer(),
            Text(
              formatCurrency.format(
                double.tryParse(livePrice ?? '${ticker.currentPrice}'),
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TickerAvatar extends StatelessWidget {
  const _TickerAvatar({super.key, required this.tickerSymbol});
  final String tickerSymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Text(
          tickerSymbol,
          style: const TextStyle(
            fontSize: 26,
            color: AppColors.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
