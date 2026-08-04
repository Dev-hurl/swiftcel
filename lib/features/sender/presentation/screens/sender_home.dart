import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum DeliveryStatus { transit, onProcess, completed, pending }

class DeliveryPreview {
  final String trackingId;
  final String itemLabel;
  final DeliveryStatus status;
  final String originCity;
  final String originDate;
  final String destCity;
  final String destDate;
  final int progressStep; // 0 = just created, 3 = delivered

  const DeliveryPreview({
    required this.trackingId,
    required this.itemLabel,
    required this.status,
    required this.originCity,
    required this.originDate,
    required this.destCity,
    required this.destDate,
    required this.progressStep,
  });
}

class SenderHome extends StatefulWidget {
  const SenderHome({super.key});

  @override
  State<SenderHome> createState() => _SenderHomeState();
}

class _SenderHomeState extends State<SenderHome> {
  DeliveryStatus? _selectedFilter; // null = All

  // TODO: replace with real stream from DeliveryProvider
  final List<DeliveryPreview> _deliveries = const [
    DeliveryPreview(
      trackingId: 'H314215485',
      itemLabel: 'Electronics Bundle',
      status: DeliveryStatus.transit,
      originCity: 'Jakarta',
      originDate: '09 Mar 26',
      destCity: 'Malang',
      destDate: '16 Mar 26',
      progressStep: 1,
    ),
    DeliveryPreview(
      trackingId: 'H654124578',
      itemLabel: 'iPhone 15 Pro Max',
      status: DeliveryStatus.onProcess,
      originCity: 'Bandung',
      originDate: '22 Mar 26',
      destCity: 'Pekalongan',
      destDate: '28 Mar 26',
      progressStep: 0,
    ),
  ];

  List<DeliveryPreview> get _filtered => _selectedFilter == null
      ? _deliveries
      : _deliveries.where((d) => d.status == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Track\nShipments',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFEEEEEE),
                ), // TODO: user avatar
                const SizedBox(width: 10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.black87,
                      ),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD32F2F),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Colors.black45),
                suffixIcon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.black45,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == null,
                    onTap: () => setState(() => _selectedFilter = null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    isSelected: _selectedFilter == DeliveryStatus.completed,
                    onTap: () => setState(
                      () => _selectedFilter = DeliveryStatus.completed,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'On Process',
                    isSelected: _selectedFilter == DeliveryStatus.onProcess,
                    onTap: () => setState(
                      () => _selectedFilter = DeliveryStatus.onProcess,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: _selectedFilter == DeliveryStatus.pending,
                    onTap: () => setState(
                      () => _selectedFilter = DeliveryStatus.pending,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // "What would you like to do?" — from image 2, icons only
            const Text(
              'What would you like to do?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionItem(
                  icon: Icons.inventory_2_outlined,
                  bg: const Color(0xFFFCE4E4),
                  iconColor: const Color(0xFFD32F2F),
                  label: 'Send parcel',
                  onTap: () {
                    // TODO: navigate to '/sender/create-delivery/address'
                  },
                ),
                _ActionItem(
                  icon: Icons.location_searching,
                  bg: const Color(0xFFEFF3C0),
                  iconColor: const Color(0xFF9E9D24),
                  label: 'Track item',
                  onTap: () {
                    // TODO: navigate to tracking screen
                  },
                ),
                _ActionItem(
                  icon: Icons.location_on_outlined,
                  bg: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1565C0),
                  label: 'Location',
                  onTap: () {
                    // TODO: navigate to '/sender/saved-addresses'
                  },
                ),
                _ActionItem(
                  icon: Icons.support_agent,
                  bg: const Color(0xFFEFEBE9),
                  iconColor: const Color(0xFF6D4C41),
                  label: 'Services',
                  onTap: () {
                    context.go('/support');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            ..._filtered.map((d) => _ShipmentCard(delivery: d)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final DeliveryPreview delivery;
  const _ShipmentCard({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4E4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFFD32F2F),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.trackingId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      delivery.itemLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: delivery.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(4, (i) {
              final active = i <= delivery.progressStep;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? const Color(0xFFD32F2F)
                            : Colors.grey.shade300,
                      ),
                    ),
                    if (i < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: active
                              ? const Color(0xFFD32F2F)
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    delivery.originCity,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    delivery.originDate,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    delivery.destCity,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    delivery.destDate,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DeliveryStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      DeliveryStatus.transit => ('Transit', const Color(0xFFD32F2F)),
      DeliveryStatus.onProcess => ('On Process', const Color(0xFF1565C0)),
      DeliveryStatus.completed => ('Completed', const Color(0xFF2E7D32)),
      DeliveryStatus.pending => ('Pending', const Color(0xFF9E9D24)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
