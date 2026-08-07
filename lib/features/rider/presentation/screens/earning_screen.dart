import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

enum EarningsPeriod { daily, weekly, monthly }

enum TransactionType { delivery, bonus, withdrawal }

class EarningsTransaction {
  final TransactionType type;
  final String title;
  final String subtitle;
  final double amount;
  final String status;

  const EarningsTransaction({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
  });
}

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  EarningsPeriod _selectedPeriod = EarningsPeriod.weekly;

  // TODO: replace with real data from an EarningsProvider / Firestore query
  static double totalBalance = 450.80;
  static double percentChange = 12;
  final List<double> weeklyChartValues = [
    20,
    45,
    30,
    60,
    40,
    55,
    35,
  ]; // Mon–Sun

  final List<EarningsTransaction> _transactions = const [
    EarningsTransaction(
      type: TransactionType.delivery,
      title: 'Route #8291 Delivery',
      subtitle: 'Today, 2:45 PM',
      amount: 24.50,
      status: 'COMPLETED',
    ),
    EarningsTransaction(
      type: TransactionType.bonus,
      title: 'Peak Hour Bonus',
      subtitle: 'Today, 11:30 AM',
      amount: 12.00,
      status: 'COMPLETED',
    ),
    EarningsTransaction(
      type: TransactionType.withdrawal,
      title: 'Weekly Withdrawal',
      subtitle: 'Yesterday, 9:00 AM',
      amount: -150.00,
      status: 'PROCESSED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Your Earnings', style: AppFonts.headlineLarge),
            const SizedBox(height: 4),
            Text('Real-time performance summary', style: AppFonts.bodySmall),
            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.orangePrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: AppFonts.labelMedium.copyWith(color: Colors.white70),
                  ),
                  SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${totalBalance.toStringAsFixed(2)}',
                        style: AppFonts.displaySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+$percentChange% vs last week',
                          style: AppFonts.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/rider/withdraw'),
                      icon: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: AppColors.surface,
                      ),
                      label: Text(
                        'Withdraw Funds',
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.success,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _PeriodTab(
                    label: 'Daily',
                    isSelected: _selectedPeriod == EarningsPeriod.daily,
                    onTap: () =>
                        setState(() => _selectedPeriod = EarningsPeriod.daily),
                  ),
                  _PeriodTab(
                    label: 'Weekly',
                    isSelected: _selectedPeriod == EarningsPeriod.weekly,
                    onTap: () =>
                        setState(() => _selectedPeriod = EarningsPeriod.weekly),
                  ),
                  _PeriodTab(
                    label: 'Monthly',
                    isSelected: _selectedPeriod == EarningsPeriod.monthly,
                    onTap: () => setState(
                      () => _selectedPeriod = EarningsPeriod.monthly,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 160,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[index],
                              style: AppFonts.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(weeklyChartValues.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyChartValues[index],
                          color: AppColors.orangeSecondary,
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: AppFonts.titleLarge),
                GestureDetector(
                  onTap: () => context.push('/rider/history'),
                  child: Text(
                    'View All',
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.orangeSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ..._transactions.map((t) => _TransactionTile(transaction: t)),
          ],
        ),
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangePrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppFonts.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final EarningsTransaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final (icon, iconBg, iconColor) = switch (transaction.type) {
      TransactionType.delivery => (
        Icons.local_shipping_outlined,
        AppColors.orangeContainer,
        AppColors.orangeSecondary,
      ),
      TransactionType.bonus => (
        Icons.bolt,
        AppColors.orangeContainer,
        AppColors.orangeSecondary,
      ),
      TransactionType.withdrawal => (
        Icons.account_balance_outlined,
        AppColors.greyBg,
        AppColors.onSurfaceVariant,
      ),
    };
    final isPositive = transaction.amount >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppFonts.titleSmall),
                Text(transaction.subtitle, style: AppFonts.labelSmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: AppFonts.titleSmall.copyWith(
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
              Text(transaction.status, style: AppFonts.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
