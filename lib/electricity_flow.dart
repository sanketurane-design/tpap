import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boltpe_theme.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
// Navigate to this from the home screen electricity tile.
class ElectricityFlow extends StatelessWidget {
  const ElectricityFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderSelectionScreen();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — Provider Selection
// ═══════════════════════════════════════════════════════════════════════════════
class ProviderSelectionScreen extends StatefulWidget {
  const ProviderSelectionScreen({super.key});

  @override
  State<ProviderSelectionScreen> createState() =>
      _ProviderSelectionScreenState();
}

class _ProviderSelectionScreenState extends State<ProviderSelectionScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<_Provider> _providers = const [
    _Provider('BESCOM', 'Bangalore Electricity Supply', '🏙️'),
    _Provider('MSEDCL', 'Maharashtra State Electricity', '🌆'),
    _Provider('TATA Power', 'Tata Power (Mumbai)', '⚡'),
    _Provider('BSES Rajdhani', 'BSES Rajdhani (Delhi)', '🏛️'),
    _Provider('BSES Yamuna', 'BSES Yamuna (Delhi)', '🌊'),
    _Provider('TNEB', 'Tamil Nadu Electricity Board', '🌴'),
    _Provider('CESC', 'CESC Limited (Kolkata)', '🐯'),
    _Provider('DGVCL', 'Dakshin Gujarat Vij Company', '☀️'),
    _Provider('UHBVN', 'Uttar Haryana Bijli Vitran', '🌾'),
    _Provider('PSPCL', 'Punjab State Power Corp', '🌻'),
    _Provider('UPPCL', 'UP Power Corporation', '🕌'),
    _Provider('WBSEDCL', 'West Bengal State Electricity', '🐟'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _providers
        .where((p) =>
            p.name.toLowerCase().contains(_query.toLowerCase()) ||
            p.fullName.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Pay Electricity Bill'),
      body: Column(
        children: [
          // BBPS Banner
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.fromLTRB(
              BoltPeSpacing.pageX,
              0,
              BoltPeSpacing.pageX,
              BoltPeSpacing.md,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(BoltPeSpacing.md),
                  decoration: BoxDecoration(
                    color: BoltPeColors.cardBgInformation,
                    borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                    border: Border.all(
                      color: BoltPeColors.surfaceTextInformation
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: BoltPeColors.surfaceTextInformation
                              .withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(BoltPeRadii.sm),
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: BoltPeColors.surfaceTextInformation,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: BoltPeSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BBPS Powered',
                              style: BoltPeTypography.labelLg.copyWith(
                                color: BoltPeColors.surfaceTextInformation,
                              ),
                            ),
                            Text(
                              'Secure & instant bill payments via RBI regulated network',
                              style: BoltPeTypography.bodySm.copyWith(
                                color: BoltPeColors.surfaceTextInformation
                                    .withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BoltPeSpacing.md),
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search your electricity provider...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    prefixIconColor: BoltPeColors.inputFgPlaceholder,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(BoltPeRadii.md),
                      borderSide: const BorderSide(
                          color: BoltPeColors.inputBorderDefault),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(BoltPeRadii.md),
                      borderSide: const BorderSide(
                          color: BoltPeColors.inputBorderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(BoltPeRadii.md),
                      borderSide: const BorderSide(
                          color: BoltPeColors.inputBorderFocus),
                    ),
                    filled: true,
                    fillColor: BoltPeColors.inputBgDefault,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: BoltPeSpacing.md,
                      vertical: BoltPeSpacing.sm,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Provider list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: BoltPeSpacing.xs),
              itemBuilder: (context, i) {
                final p = filtered[i];
                return _ProviderTile(
                  provider: p,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ConsumerNumberScreen(provider: p),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final _Provider provider;
  final VoidCallback onTap;

  const _ProviderTile({required this.provider, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(BoltPeSpacing.md),
        decoration: BoxDecoration(
          color: BoltPeColors.cardBgDefault,
          borderRadius: BorderRadius.circular(BoltPeRadii.lg),
          border: Border.all(color: BoltPeColors.cardBorderDefault),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: BoltPeColors.cardBgNotice,
                borderRadius: BorderRadius.circular(BoltPeRadii.md),
              ),
              child: Center(
                child: Text(provider.emoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: BoltPeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: BoltPeTypography.labelLg.copyWith(
                      color: BoltPeColors.surfaceTextPrimary,
                    ),
                  ),
                  Text(
                    provider.fullName,
                    style: BoltPeTypography.bodySm.copyWith(
                      color: BoltPeColors.surfaceTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: BoltPeColors.surfaceIconSubtle,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — Consumer Number Entry
// ═══════════════════════════════════════════════════════════════════════════════
class ConsumerNumberScreen extends StatefulWidget {
  final _Provider provider;

  const ConsumerNumberScreen({super.key, required this.provider});

  @override
  State<ConsumerNumberScreen> createState() => _ConsumerNumberScreenState();
}

class _ConsumerNumberScreenState extends State<ConsumerNumberScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: widget.provider.name),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider card
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.md),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                      border:
                          Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: BoltPeColors.cardBgNotice,
                            borderRadius:
                                BorderRadius.circular(BoltPeRadii.md),
                          ),
                          child: Center(
                            child: Text(widget.provider.emoji,
                                style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: BoltPeSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.provider.name,
                              style: BoltPeTypography.headingSm.copyWith(
                                color: BoltPeColors.surfaceTextPrimary,
                              ),
                            ),
                            Text(
                              widget.provider.fullName,
                              style: BoltPeTypography.bodySm.copyWith(
                                color: BoltPeColors.surfaceTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  Text(
                    'Enter Consumer Number',
                    style: BoltPeTypography.headingSm.copyWith(
                      color: BoltPeColors.surfaceTextPrimary,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xs),
                  Text(
                    'Find it on your electricity bill or meter',
                    style: BoltPeTypography.bodyMd.copyWith(
                      color: BoltPeColors.surfaceTextSecondary,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.lg),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    onChanged: (v) =>
                        setState(() => _isValid = v.length >= 8),
                    style: BoltPeTypography.bodyLg.copyWith(
                      color: BoltPeColors.surfaceTextPrimary,
                      letterSpacing: 2,
                    ),
                    decoration: InputDecoration(
                      hintText: '  XXXX XXXX XXXX',
                      hintStyle: BoltPeTypography.bodyLg.copyWith(
                        color: BoltPeColors.inputFgPlaceholder,
                        letterSpacing: 2,
                      ),
                      suffixIcon: _isValid
                          ? const Icon(Icons.check_circle_rounded,
                              color: BoltPeColors.inputBorderPositive)
                          : null,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  // Helper tip
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.md),
                    decoration: BoxDecoration(
                      color: BoltPeColors.surfaceBgSecondary,
                      borderRadius: BorderRadius.circular(BoltPeRadii.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: BoltPeColors.surfaceIconSubtle,
                        ),
                        const SizedBox(width: BoltPeSpacing.xs),
                        Expanded(
                          child: Text(
                            'Consumer number is printed on top of your monthly electricity bill.',
                            style: BoltPeTypography.bodySm.copyWith(
                              color: BoltPeColors.surfaceTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // CTA
          _BottomCTA(
            label: 'Fetch Bill',
            enabled: _isValid,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FetchBillScreen(
                  provider: widget.provider,
                  consumerNumber: _controller.text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 3 — Fetching Bill (Loading → Details)
// ═══════════════════════════════════════════════════════════════════════════════
class FetchBillScreen extends StatefulWidget {
  final _Provider provider;
  final String consumerNumber;

  const FetchBillScreen({
    super.key,
    required this.provider,
    required this.consumerNumber,
  });

  @override
  State<FetchBillScreen> createState() => _FetchBillScreenState();
}

class _FetchBillScreenState extends State<FetchBillScreen>
    with SingleTickerProviderStateMixin {
  bool _loaded = false;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    // Simulate API fetch
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Bill Details'),
      body: _loaded ? _buildBillDetails(context) : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _spinController,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: BoltPeColors.primary500,
                  width: 3,
                ),
              ),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.bolt_rounded,
                      color: BoltPeColors.primary500, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: BoltPeSpacing.lg),
          Text(
            'Fetching your bill...',
            style: BoltPeTypography.bodyMd.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xs),
          Text(
            'Consumer No: ${widget.consumerNumber}',
            style: BoltPeTypography.labelMd.copyWith(
              color: BoltPeColors.surfaceTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(BoltPeSpacing.pageX),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Consumer info card
                Container(
                  padding: const EdgeInsets.all(BoltPeSpacing.lg),
                  decoration: BoxDecoration(
                    color: BoltPeColors.cardBgDefault,
                    borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                    border:
                        Border.all(color: BoltPeColors.cardBorderDefault),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SANKET URANE',
                                style: BoltPeTypography.headingSm.copyWith(
                                  color: BoltPeColors.surfaceTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Consumer No: ${widget.consumerNumber}',
                                style: BoltPeTypography.bodySm.copyWith(
                                  color: BoltPeColors.surfaceTextSecondary,
                                ),
                              ),
                              Text(
                                widget.provider.name,
                                style: BoltPeTypography.bodySm.copyWith(
                                  color: BoltPeColors.surfaceTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: BoltPeSpacing.xs,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: BoltPeColors.cardBgPositive,
                              borderRadius:
                                  BorderRadius.circular(BoltPeRadii.xs),
                            ),
                            child: Text(
                              'Active',
                              style: BoltPeTypography.labelSm.copyWith(
                                color: BoltPeColors.surfaceTextPositive,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: BoltPeSpacing.md),
                      const Divider(
                          color: BoltPeColors.surfaceBorderDefault,
                          thickness: 1,
                          height: 1),
                      const SizedBox(height: BoltPeSpacing.md),
                      _InfoRow('Billing Period', 'May 1 – May 31, 2025'),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _InfoRow('Due Date', 'Jun 15, 2025',
                          valueColor: BoltPeColors.surfaceTextNegative),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _InfoRow('Units Consumed', '312 kWh'),
                    ],
                  ),
                ),
                const SizedBox(height: BoltPeSpacing.md),
                // Amount card
                Container(
                  padding: const EdgeInsets.all(BoltPeSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF181818), BoltPeColors.primary800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount Due',
                        style: BoltPeTypography.bodySm.copyWith(
                          color: BoltPeColors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹1,842.00',
                        style: BoltPeTypography.headingXl.copyWith(
                          color: BoltPeColors.white,
                        ),
                      ),
                      const SizedBox(height: BoltPeSpacing.md),
                      const Divider(
                          color: Colors.white24, thickness: 1, height: 1),
                      const SizedBox(height: BoltPeSpacing.md),
                      _BillBreakdownRow(
                          'Energy Charges', '₹1,248.00'),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _BillBreakdownRow('Fixed Charges', '₹320.00'),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _BillBreakdownRow(
                          'Electricity Duty', '₹186.00'),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _BillBreakdownRow('Other Charges', '₹88.00'),
                    ],
                  ),
                ),
                const SizedBox(height: BoltPeSpacing.md),
                // Late fee warning
                Container(
                  padding: const EdgeInsets.all(BoltPeSpacing.md),
                  decoration: BoxDecoration(
                    color: BoltPeColors.cardBgNegative,
                    borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                    border: Border.all(
                      color: BoltPeColors.surfaceTextNegative
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: BoltPeColors.surfaceIconNegative, size: 18),
                      const SizedBox(width: BoltPeSpacing.xs),
                      Expanded(
                        child: Text(
                          'Pay before Jun 15 to avoid ₹50 late payment charges.',
                          style: BoltPeTypography.bodySm.copyWith(
                            color: BoltPeColors.surfaceTextNegative,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _BottomCTA(
          label: 'Pay ₹1,842.00',
          enabled: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentConfirmScreen(
                provider: widget.provider,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 4 — Payment Confirmation
// ═══════════════════════════════════════════════════════════════════════════════
class PaymentConfirmScreen extends StatefulWidget {
  final _Provider provider;

  const PaymentConfirmScreen({super.key, required this.provider});

  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  int _selectedUpi = 0;
  final _upis = ['sanket@boltpe', 'sanket@okicici', 'sanket@ybl'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Confirm Payment'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount summary
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                      border:
                          Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: BoltPeColors.cardBgNotice,
                                borderRadius:
                                    BorderRadius.circular(BoltPeRadii.md),
                              ),
                              child: Center(
                                child: Text(widget.provider.emoji,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: BoltPeSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.provider.name,
                                  style: BoltPeTypography.labelLg.copyWith(
                                    color: BoltPeColors.surfaceTextPrimary,
                                  ),
                                ),
                                Text(
                                  'Electricity Bill • May 2025',
                                  style: BoltPeTypography.bodySm.copyWith(
                                    color: BoltPeColors.surfaceTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: BoltPeSpacing.lg),
                        const Divider(
                            color: BoltPeColors.surfaceBorderDefault,
                            thickness: 1,
                            height: 1),
                        const SizedBox(height: BoltPeSpacing.lg),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Total Payable',
                                style: BoltPeTypography.bodyMd.copyWith(
                                  color: BoltPeColors.surfaceTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹1,842.00',
                                style: BoltPeTypography.display2xl.copyWith(
                                  color: BoltPeColors.surfaceTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  Text(
                    'Pay Using',
                    style: BoltPeTypography.headingSm.copyWith(
                      color: BoltPeColors.surfaceTextPrimary,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  ...List.generate(_upis.length, (i) {
                    final selected = _selectedUpi == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedUpi = i),
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: BoltPeSpacing.xs),
                        padding: const EdgeInsets.all(BoltPeSpacing.md),
                        decoration: BoxDecoration(
                          color: selected
                              ? BoltPeColors.surfaceBgSelected
                              : BoltPeColors.cardBgDefault,
                          borderRadius:
                              BorderRadius.circular(BoltPeRadii.lg),
                          border: Border.all(
                            color: selected
                                ? BoltPeColors.cardBorderSelected
                                : BoltPeColors.cardBorderDefault,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: BoltPeColors.primary50,
                                borderRadius:
                                    BorderRadius.circular(BoltPeRadii.sm),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: BoltPeColors.primary500,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: BoltPeSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _upis[i],
                                    style: BoltPeTypography.labelLg.copyWith(
                                      color:
                                          BoltPeColors.surfaceTextPrimary,
                                    ),
                                  ),
                                  Text(
                                    'UPI',
                                    style: BoltPeTypography.bodySm.copyWith(
                                      color:
                                          BoltPeColors.surfaceTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<int>(
                              value: i,
                              groupValue: _selectedUpi,
                              onChanged: (v) =>
                                  setState(() => _selectedUpi = v!),
                              activeColor: BoltPeColors.primary500,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: 'Confirm & Pay ₹1,842.00',
            enabled: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PaymentProcessingScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 5 — Payment Processing
// ═══════════════════════════════════════════════════════════════════════════════
class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const PaymentSuccessScreen()),
          (route) => route.isFirst,
        );
      }
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, child) {
                return Container(
                  width: 80 + _pulse.value * 20,
                  height: 80 + _pulse.value * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BoltPeColors.primary500
                        .withValues(alpha: 0.1 + _pulse.value * 0.1),
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: BoltPeColors.primary500,
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          color: BoltPeColors.white, size: 36),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: BoltPeSpacing.xl),
            Text(
              'Processing Payment',
              style: BoltPeTypography.headingMd.copyWith(
                color: BoltPeColors.surfaceTextPrimary,
              ),
            ),
            const SizedBox(height: BoltPeSpacing.xs),
            Text(
              'Please do not press back or close the app',
              style: BoltPeTypography.bodyMd.copyWith(
                color: BoltPeColors.surfaceTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BoltPeSpacing.xxl),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                backgroundColor: BoltPeColors.surfaceBgTertiary,
                color: BoltPeColors.primary500,
                minHeight: 4,
                borderRadius: BorderRadius.circular(BoltPeRadii.full),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 6 — Payment Success
// ═══════════════════════════════════════════════════════════════════════════════
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scale;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scale = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _scale, curve: Curves.elasticOut);
    _scale.forward();
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txnId =
        'BP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BoltPeSpacing.pageX),
          child: Column(
            children: [
              const Spacer(),
              // Success animation
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BoltPeColors.cardBgPositive,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: BoltPeColors.surfaceIconPositive,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: BoltPeSpacing.xl),
              Text(
                'Payment Successful!',
                style: BoltPeTypography.headingLg.copyWith(
                  color: BoltPeColors.surfaceTextPrimary,
                ),
              ),
              const SizedBox(height: BoltPeSpacing.xs),
              Text(
                '₹1,842.00 paid to BESCOM',
                style: BoltPeTypography.bodyMd.copyWith(
                  color: BoltPeColors.surfaceTextSecondary,
                ),
              ),
              const SizedBox(height: BoltPeSpacing.xxl),
              // Transaction details
              Container(
                padding: const EdgeInsets.all(BoltPeSpacing.lg),
                decoration: BoxDecoration(
                  color: BoltPeColors.surfaceBgSecondary,
                  borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                  border: Border.all(color: BoltPeColors.surfaceBorderDefault),
                ),
                child: Column(
                  children: [
                    _InfoRow('Transaction ID', txnId),
                    const SizedBox(height: BoltPeSpacing.sm),
                    const Divider(
                        color: BoltPeColors.surfaceBorderDefault,
                        thickness: 1,
                        height: 1),
                    const SizedBox(height: BoltPeSpacing.sm),
                    _InfoRow('Amount', '₹1,842.00'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('Paid via', 'sanket@boltpe'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('Date & Time',
                        '${DateTime.now().day} Jun 2025, ${TimeOfDay.now().format(context)}'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('Status', 'Success',
                        valueColor: BoltPeColors.surfaceTextPositive),
                  ],
                ),
              ),
              const Spacer(),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Receipt'),
                      style: Theme.of(context).outlinedButtonTheme.style,
                    ),
                  ),
                  const SizedBox(width: BoltPeSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.popUntil(context, (r) => r.isFirst),
                      child: const Text('Go Home'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────────────────────────────

PreferredSizeWidget _BoltPeAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    backgroundColor: BoltPeColors.surfaceBgPrimary,
    foregroundColor: BoltPeColors.surfaceTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: BoltPeTypography.headingSm.copyWith(
      color: BoltPeColors.surfaceTextPrimary,
    ),
    leading: Builder(
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(BoltPeSpacing.xs),
          decoration: BoxDecoration(
            color: BoltPeColors.surfaceBgSecondary,
            borderRadius: BorderRadius.circular(BoltPeRadii.sm),
            border: Border.all(color: BoltPeColors.surfaceBorderDefault),
          ),
          child: const Icon(Icons.arrow_back_rounded, size: 18),
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(color: BoltPeColors.surfaceBorderDefault, height: 1),
    ),
  );
}

class _BottomCTA extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _BottomCTA({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BoltPeSpacing.pageX,
        BoltPeSpacing.md,
        BoltPeSpacing.pageX,
        BoltPeSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: BoltPeColors.surfaceBgPrimary,
        border: Border(
          top: BorderSide(color: BoltPeColors.surfaceBorderDefault),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          child: Text(label),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: BoltPeTypography.bodyMd.copyWith(
            color: BoltPeColors.surfaceTextSecondary,
          ),
        ),
        Text(
          value,
          style: BoltPeTypography.labelLg.copyWith(
            color: valueColor ?? BoltPeColors.surfaceTextPrimary,
          ),
        ),
      ],
    );
  }
}

class _BillBreakdownRow extends StatelessWidget {
  final String label;
  final String value;

  const _BillBreakdownRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: BoltPeTypography.bodyMd.copyWith(
            color: BoltPeColors.white.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: BoltPeTypography.labelLg.copyWith(
            color: BoltPeColors.white,
          ),
        ),
      ],
    );
  }
}

// ─── Data Models ───────────────────────────────────────────────────────────────

class _Provider {
  final String name;
  final String fullName;
  final String emoji;

  const _Provider(this.name, this.fullName, this.emoji);
}
