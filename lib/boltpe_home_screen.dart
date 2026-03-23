import 'package:flutter/material.dart';
import 'boltpe_theme.dart';
import 'electricity_flow.dart';
import 'bank_transfer_flow.dart';

// ─── Entry Point ───────────────────────────────────────────────────────────────
void main() {
  runApp(const BoltPeApp());
}

class BoltPeApp extends StatelessWidget {
  const BoltPeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoltPe',
      theme: BoltPeTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const BoltPeHomeScreen(),
    );
  }
}

// ─── Home Screen ───────────────────────────────────────────────────────────────
class BoltPeHomeScreen extends StatefulWidget {
  const BoltPeHomeScreen({super.key});

  @override
  State<BoltPeHomeScreen> createState() => _BoltPeHomeScreenState();
}

class _BoltPeHomeScreenState extends State<BoltPeHomeScreen> {
  int _selectedIndex = 0;
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildHeroBanner(),
              const SizedBox(height: BoltPeSpacing.xl),
              _buildMoneyTransferSection(),
              const SizedBox(height: BoltPeSpacing.xl),
              _buildPayBillsSection(),
              const SizedBox(height: BoltPeSpacing.xl),
              _buildTravelBentoSection(),
              const SizedBox(height: BoltPeSpacing.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Top Bar ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: BoltPeColors.surfaceBgPrimary,
      padding: const EdgeInsets.fromLTRB(
        BoltPeSpacing.pageX,
        BoltPeSpacing.sm,
        BoltPeSpacing.pageX,
        BoltPeSpacing.md,
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BoltPeColors.primary400, BoltPeColors.accent500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(BoltPeRadii.full),
            ),
            child: Center(
              child: Text(
                'S',
                style: BoltPeTypography.headingSm.copyWith(
                  color: BoltPeColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: BoltPeSpacing.sm),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning 👋',
                  style: BoltPeTypography.bodySm.copyWith(
                    color: BoltPeColors.surfaceTextSecondary,
                  ),
                ),
                Text(
                  'Sanket',
                  style: BoltPeTypography.headingSm.copyWith(
                    color: BoltPeColors.surfaceTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Help Badge
          _IconBadge(
            icon: Icons.help_outline_rounded,
            onTap: () {},
          ),
          const SizedBox(width: BoltPeSpacing.xs),
          // Notification Badge
          _IconBadge(
            icon: Icons.notifications_outlined,
            showDot: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Hero Banner ─────────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BoltPeSpacing.pageX,
        BoltPeSpacing.md,
        BoltPeSpacing.pageX,
        0,
      ),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BoltPeRadii.xxl),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF181818),
              Color(0xFF2E1500),
              BoltPeColors.primary800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Glow orb — right
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      BoltPeColors.primary500.withValues(alpha: 0.55),
                      BoltPeColors.primary500.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Glow orb — left bottom
            Positioned(
              left: -30,
              bottom: -50,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      BoltPeColors.accent500.withValues(alpha: 0.35),
                      BoltPeColors.accent500.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(BoltPeSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BoltPe Balance',
                        style: BoltPeTypography.bodySm.copyWith(
                          color: BoltPeColors.white.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _balanceVisible ? '₹12,450.00' : '₹ ••••••',
                            style: BoltPeTypography.headingLg.copyWith(
                              color: BoltPeColors.white,
                            ),
                          ),
                          const SizedBox(width: BoltPeSpacing.xs),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _balanceVisible = !_balanceVisible),
                            child: Icon(
                              _balanceVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: BoltPeColors.white.withValues(alpha: 0.5),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // UPI ID + Scan CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UPI ID',
                            style: BoltPeTypography.caption.copyWith(
                              color: BoltPeColors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          Text(
                            'sanket@boltpe',
                            style: BoltPeTypography.labelLg.copyWith(
                              color: BoltPeColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: BoltPeSpacing.md,
                          vertical: BoltPeSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: BoltPeColors.primary500,
                          borderRadius: BorderRadius.circular(BoltPeRadii.full),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  BoltPeColors.primary500.withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: BoltPeColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Scan & Pay',
                              style: BoltPeTypography.labelMd.copyWith(
                                color: BoltPeColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Money Transfer ──────────────────────────────────────────────────────────
  Widget _buildMoneyTransferSection() {
    final quickActions = [
      _QuickAction(
        icon: Icons.smartphone_rounded,
        label: 'Mobile',
        color: BoltPeColors.primary500,
        bg: BoltPeColors.primary50,
      ),
      _QuickAction(
        icon: Icons.account_balance_rounded,
        label: 'Bank',
        color: BoltPeColors.accent500,
        bg: BoltPeColors.accent50,
      ),
      _QuickAction(
        icon: Icons.account_balance_wallet_rounded,
        label: 'Balance',
        color: BoltPeColors.surfaceIconPositive,
        bg: BoltPeColors.cardBgPositive,
      ),
      _QuickAction(
        icon: Icons.history_rounded,
        label: 'Recent',
        color: BoltPeColors.surfaceIconNotice,
        bg: BoltPeColors.cardBgNotice,
      ),
    ];

    final recentContacts = ['RK', 'PS', 'AM', 'VB', 'NK'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: BoltPeSpacing.pageX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Money Transfer', actionLabel: 'See All'),
          const SizedBox(height: BoltPeSpacing.md),
          // Quick action buttons
          Container(
            decoration: BoxDecoration(
              color: BoltPeColors.cardBgDefault,
              borderRadius: BorderRadius.circular(BoltPeRadii.xl),
              border: Border.all(color: BoltPeColors.cardBorderDefault),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: BoltPeSpacing.lg,
              horizontal: BoltPeSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: quickActions
                  .map((a) => _buildQuickActionTile(a))
                  .toList(),
            ),
          ),
          const SizedBox(height: BoltPeSpacing.md),
          // Recent contacts
          Text(
            'Recent',
            style: BoltPeTypography.labelLg.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: recentContacts.map((initials) {
                return Padding(
                  padding: const EdgeInsets.only(right: BoltPeSpacing.md),
                  child: _RecentContactBubble(initials: initials),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile(_QuickAction action) {
    return GestureDetector(
      onTap: () {
        if (action.label == 'Bank') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BankTransferFlow()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: action.bg,
              borderRadius: BorderRadius.circular(BoltPeRadii.lg),
            ),
            child: Icon(action.icon, color: action.color, size: 24),
          ),
          const SizedBox(height: BoltPeSpacing.xs),
          Text(
            action.label,
            style: BoltPeTypography.labelMd.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pay Bills ───────────────────────────────────────────────────────────────
  Widget _buildPayBillsSection() {
    final bills = [
      _BillItem(
        icon: Icons.bolt_rounded,
        label: 'Electricity',
        color: BoltPeColors.surfaceIconNotice,
        bg: BoltPeColors.cardBgNotice,
      ),
      _BillItem(
        icon: Icons.local_gas_station_rounded,
        label: 'Gas',
        color: BoltPeColors.surfaceIconPositive,
        bg: BoltPeColors.cardBgPositive,
      ),
      _BillItem(
        icon: Icons.water_drop_rounded,
        label: 'Water',
        color: BoltPeColors.surfaceIconInformation,
        bg: BoltPeColors.cardBgInformation,
      ),
      _BillItem(
        icon: Icons.tv_rounded,
        label: 'DTH',
        color: BoltPeColors.accent500,
        bg: BoltPeColors.accent50,
      ),
      _BillItem(
        icon: Icons.wifi_rounded,
        label: 'Internet',
        color: BoltPeColors.primary500,
        bg: BoltPeColors.primary50,
      ),
      _BillItem(
        icon: Icons.add_rounded,
        label: 'More',
        color: BoltPeColors.surfaceTextTertiary,
        bg: BoltPeColors.surfaceBgTertiary,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: BoltPeSpacing.pageX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Pay Bills', actionLabel: 'All Bills'),
          const SizedBox(height: BoltPeSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: BoltPeColors.cardBgDefault,
              borderRadius: BorderRadius.circular(BoltPeRadii.xl),
              border: Border.all(color: BoltPeColors.cardBorderDefault),
            ),
            padding: const EdgeInsets.all(BoltPeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BBPS badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BoltPeSpacing.xs,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: BoltPeColors.cardBgInformation,
                    borderRadius: BorderRadius.circular(BoltPeRadii.xs),
                    border: Border.all(
                      color: BoltPeColors.surfaceTextInformation
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 12,
                        color: BoltPeColors.surfaceTextInformation,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'BBPS Powered',
                        style: BoltPeTypography.labelSm.copyWith(
                          color: BoltPeColors.surfaceTextInformation,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BoltPeSpacing.md),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: BoltPeSpacing.md,
                  crossAxisSpacing: BoltPeSpacing.sm,
                  childAspectRatio: 0.95,
                  children: bills.map((b) => _buildBillTile(b)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillTile(_BillItem item) {
    return GestureDetector(
      onTap: () {
        if (item.label == 'Electricity') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ElectricityFlow()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(BoltPeRadii.md),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: BoltPeSpacing.xxs),
          Text(
            item.label,
            style: BoltPeTypography.labelSm.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Travel & Transit Bento ──────────────────────────────────────────────────
  Widget _buildTravelBentoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: BoltPeSpacing.pageX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Travel & Transit', actionLabel: 'Explore'),
          const SizedBox(height: BoltPeSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus — tall left card
              Expanded(
                flex: 5,
                child: _BentoCard(
                  title: 'Bus',
                  subtitle: 'Book tickets',
                  icon: Icons.directions_bus_rounded,
                  gradientColors: const [Color(0xFF0A3D62), Color(0xFF1E6EA6)],
                  height: 200,
                ),
              ),
              const SizedBox(width: BoltPeSpacing.sm),
              // Flight + Hotel — stacked right
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _BentoCard(
                      title: 'Flight',
                      subtitle: 'Best fares',
                      icon: Icons.flight_rounded,
                      gradientColors: const [
                        BoltPeColors.primary700,
                        BoltPeColors.primary500,
                      ],
                      height: 94,
                    ),
                    const SizedBox(height: BoltPeSpacing.sm),
                    _BentoCard(
                      title: 'Hotel',
                      subtitle: 'Great stays',
                      icon: Icons.hotel_rounded,
                      gradientColors: const [
                        Color(0xFF3B0070),
                        BoltPeColors.accent600,
                      ],
                      height: 94,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation ───────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: BoltPeColors.navigationBgDefault,
        border: const Border(
          top: BorderSide(color: BoltPeColors.navigationBorderTop),
        ),
        boxShadow: [
          BoxShadow(
            color: BoltPeColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavTab(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavTab(
                icon: Icons.search_rounded,
                label: 'Search',
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              // QR — center FAB
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: BoltPeColors.primary500,
                    borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                    boxShadow: [
                      BoxShadow(
                        color: BoltPeColors.primary500.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: BoltPeColors.white,
                    size: 26,
                  ),
                ),
              ),
              _NavTab(
                icon: Icons.notifications_outlined,
                label: 'Alerts',
                isSelected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
              _NavTab(
                icon: Icons.history_rounded,
                label: 'History',
                isSelected: _selectedIndex == 4,
                onTap: () => setState(() => _selectedIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;

  const _SectionHeader({required this.title, required this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: BoltPeTypography.headingSm.copyWith(
            color: BoltPeColors.surfaceTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            actionLabel,
            style: BoltPeTypography.labelLg.copyWith(
              color: BoltPeColors.surfaceTextLink,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final bool showDot;
  final VoidCallback onTap;

  const _IconBadge({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: BoltPeColors.surfaceBgSecondary,
          borderRadius: BorderRadius.circular(BoltPeRadii.full),
          border: Border.all(color: BoltPeColors.surfaceBorderDefault),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: BoltPeColors.surfaceIconDefault, size: 20),
            if (showDot)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: BoltPeColors.primary500,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: BoltPeColors.surfaceBgPrimary, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentContactBubble extends StatelessWidget {
  final String initials;

  const _RecentContactBubble({required this.initials});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BoltPeColors.primary200, BoltPeColors.primary400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(BoltPeRadii.full),
            ),
            child: Center(
              child: Text(
                initials,
                style: BoltPeTypography.labelMd.copyWith(
                  color: BoltPeColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            initials,
            style: BoltPeTypography.caption.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final double height;

  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(BoltPeRadii.xl),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative background icon
            Positioned(
              right: -12,
              bottom: -12,
              child: Icon(
                icon,
                size: 72,
                color: BoltPeColors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(BoltPeSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: BoltPeColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(BoltPeRadii.sm),
                    ),
                    child: Icon(icon, color: BoltPeColors.white, size: 16),
                  ),
                  const SizedBox(height: BoltPeSpacing.xs),
                  Text(
                    title,
                    style: BoltPeTypography.labelLg.copyWith(
                      color: BoltPeColors.white,
                      fontWeight: BoltPeTypography.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: BoltPeTypography.caption.copyWith(
                      color: BoltPeColors.white.withValues(alpha: 0.65),
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

class _NavTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? BoltPeColors.navigationFgActive
                : BoltPeColors.navigationFgInactive,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: BoltPeTypography.labelSm.copyWith(
              color: isSelected
                  ? BoltPeColors.navigationFgActive
                  : BoltPeColors.navigationFgInactive,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Models ───────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
  });
}

class _BillItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;

  const _BillItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
  });
}
