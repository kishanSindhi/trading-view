import 'package:flutter/material.dart';
import 'package:trading_view/app_constants.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.info});
  final String info;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(info, style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
