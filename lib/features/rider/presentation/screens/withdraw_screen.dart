import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController(text: '0.00');

  // TODO: replace with real values from EarningsProvider / linked bank account doc
  static double availableBalance = 2450.00;
  static double processingFeeFlat =
      0.0; // TODO: confirm real fee structure — flat, percentage, or free
  static const String bankName = 'Chase Bank';
  static String accountType = 'Checking';
  static String accountLast4 = '8829';

  double get _enteredAmount => double.tryParse(_amountController.text) ?? 0.0;
  double get _netAmount =>
      (_enteredAmount - processingFeeFlat).clamp(0, double.infinity);

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _confirmWithdrawal() {
    if (_enteredAmount <= 0 || _enteredAmount > availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Enter a valid amount within your available balance'),
        ),
      );
      return;
    }
    // TODO: call EarningsProvider.requestWithdrawal(_enteredAmount), write to 'withdrawals' collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Withdraw Funds', style: AppFonts.titleLarge),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount to Withdraw', style: AppFonts.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: AppFonts.displaySmall,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: AppFonts.displaySmall,
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Available: \$${availableBalance.toStringAsFixed(2)}',
                    style: AppFonts.labelSmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Bank Account', style: AppFonts.labelMedium),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to bank account selection/management screen
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_outlined,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(bankName, style: AppFonts.titleSmall),
                              Text(
                                '$accountType •••• $accountLast4',
                                style: AppFonts.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Processing Fee', style: AppFonts.bodySmall),
                      Text(
                        '\$${processingFeeFlat.toStringAsFixed(2)}',
                        style: AppFonts.bodySmall,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Net Amount', style: AppFonts.titleSmall),
                      Text(
                        '\$${_netAmount.toStringAsFixed(2)}',
                        style: AppFonts.titleLarge.copyWith(
                          color: AppColors.orangeSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Confirm Withdrawal',
                  style: AppFonts.labelLarge.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Instant Transfers', style: AppFonts.titleSmall),
                        Text(
                          'Funds typically arrive within minutes to your linked account.',
                          style: AppFonts.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
