import 'package:flutter/material.dart';
import 'package:trading_view/app_constants.dart';
import 'package:trading_view/models/stock.dart';
import 'package:trading_view/screens/crypto_detail_screen/crypto_detail_screen.dart';

class CryptoTile extends StatelessWidget {
  const CryptoTile({super.key, required this.ticker, required this.livePrice});
  final Stock ticker;
  final String? livePrice;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryptoDetailScreen(currency: ticker.symbol),
          ),
        );
      },
      title: Text(
        AppConstants.cryptoNames[ticker.symbol] ?? ticker.symbol,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(ticker.symbol),
      leading: CircleAvatar(child: Text(ticker.symbol[0])),
      trailing: Text(
        '\$${livePrice ?? ticker.currentPrice}',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
