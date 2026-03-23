import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boltpe_theme.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
class BankTransferFlow extends StatelessWidget {
  const BankTransferFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecipientEntryScreen();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — Recipient Entry (UPI ID | Mobile | Account+IFSC)
// ═══════════════════════════════════════════════════════════════════════════════
class RecipientEntryScreen extends StatefulWidget {
  const RecipientEntryScreen({super.key});

  @override
  State<RecipientEntryScreen> createState() => _RecipientEntryScreenState();
}

class _RecipientEntryScreenState extends State<RecipientEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _upiCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();

  final List<Map<String, String>> _recentContacts = [
    {'name': 'Rahul Kapoor', 'upi': 'rahul@okicici', 'initials': 'RK'},
    {'name': 'Priya Shah', 'upi': 'priya@ybl', 'initials': 'PS'},
    {'name': 'Amit Mehta', 'upi': 'amit@paytm', 'initials': 'AM'},
    {'name': 'Vijay Bhat', 'upi': 'vijay@upi', 'initials': 'VB'},
    {'name': 'Neha Kulkarni', 'upi': 'neha@okhdfc', 'initials': 'NK'},
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _upiCtrl.dispose();
    _mobileCtrl.dispose();
    _accountCtrl.dispose();
    _ifscCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_tabs.index) {
      case 0:
        return _upiCtrl.text.contains('@') && _upiCtrl.text.length > 3;
      case 1:
        return _mobileCtrl.text.length == 10;
      case 2:
        return _accountCtrl.text.length >= 9 && _ifscCtrl.text.length == 11;
      default:
        return false;
    }
  }

  String get _recipientId {
    switch (_tabs.index) {
      case 0:
        return _upiCtrl.text;
      case 1:
        return _mobileCtrl.text;
      case 2:
        return _accountCtrl.text;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Send Money'),
      body: Column(
        children: [
          // Tab bar
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
                  decoration: BoxDecoration(
                    color: BoltPeColors.surfaceBgSecondary,
                    borderRadius: BorderRadius.circular(BoltPeRadii.md),
                  ),
                  child: TabBar(
                    controller: _tabs,
                    onTap: (_) => setState(() {}),
                    indicator: BoxDecoration(
                      color: BoltPeColors.primary500,
                      borderRadius: BorderRadius.circular(BoltPeRadii.sm),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: BoltPeTypography.labelMd.copyWith(
                      color: BoltPeColors.white,
                    ),
                    unselectedLabelStyle: BoltPeTypography.labelMd.copyWith(
                      color: BoltPeColors.surfaceTextSecondary,
                    ),
                    labelColor: BoltPeColors.white,
                    unselectedLabelColor: BoltPeColors.surfaceTextSecondary,
                    tabs: const [
                      Tab(text: 'UPI ID'),
                      Tab(text: 'Mobile'),
                      Tab(text: 'Account'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.fromLTRB(
              BoltPeSpacing.pageX,
              BoltPeSpacing.md,
              BoltPeSpacing.pageX,
              BoltPeSpacing.lg,
            ),
            child: AnimatedBuilder(
              animation: _tabs,
              builder: (_, __) {
                if (_tabs.index == 0) return _buildUpiTab();
                if (_tabs.index == 1) return _buildMobileTab();
                return _buildAccountTab();
              },
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xl),
          // Recent contacts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent',
                    style: BoltPeTypography.headingSm.copyWith(
                      color: BoltPeColors.surfaceTextPrimary,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _recentContacts.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: BoltPeSpacing.xs),
                      itemBuilder: (context, i) {
                        final c = _recentContacts[i];
                        return _ContactTile(
                          name: c['name']!,
                          upi: c['upi']!,
                          initials: c['initials']!,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerifyRecipientScreen(
                                recipientId: c['upi']!,
                                name: c['name']!,
                                method: 'UPI ID',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: 'Proceed',
            enabled: _canProceed,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyRecipientScreen(
                  recipientId: _recipientId,
                  method: _tabs.index == 0
                      ? 'UPI ID'
                      : _tabs.index == 1
                          ? 'Mobile'
                          : 'Account',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpiTab() {
    return TextField(
      controller: _upiCtrl,
      onChanged: (_) => setState(() {}),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Enter UPI ID (eg. name@upi)',
        prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
      ),
    );
  }

  Widget _buildMobileTab() {
    return TextField(
      controller: _mobileCtrl,
      onChanged: (_) => setState(() {}),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: const InputDecoration(
        hintText: 'Enter 10-digit mobile number',
        prefixIcon: Icon(Icons.smartphone_rounded, size: 20),
        prefixText: '+91  ',
      ),
    );
  }

  Widget _buildAccountTab() {
    return Column(
      children: [
        TextField(
          controller: _accountCtrl,
          onChanged: (_) => setState(() {}),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: 'Account Number',
            prefixIcon: Icon(Icons.account_balance_rounded, size: 20),
          ),
        ),
        const SizedBox(height: BoltPeSpacing.sm),
        TextField(
          controller: _ifscCtrl,
          onChanged: (_) => setState(() {}),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            UpperCaseTextFormatter(),
          ],
          decoration: const InputDecoration(
            hintText: 'IFSC Code (eg. HDFC0001234)',
            prefixIcon: Icon(Icons.code_rounded, size: 20),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — Verify Recipient
// ═══════════════════════════════════════════════════════════════════════════════
class VerifyRecipientScreen extends StatefulWidget {
  final String recipientId;
  final String? name;
  final String method;

  const VerifyRecipientScreen({
    super.key,
    required this.recipientId,
    this.name,
    required this.method,
  });

  @override
  State<VerifyRecipientScreen> createState() => _VerifyRecipientScreenState();
}

class _VerifyRecipientScreenState extends State<VerifyRecipientScreen> {
  bool _verifying = true;
  late String _resolvedName;

  @override
  void initState() {
    super.initState();
    _resolvedName = widget.name ?? 'Rahul Kapoor';
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _verifying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Verify Recipient'),
      body: Column(
        children: [
          Expanded(
            child: _verifying
                ? _buildVerifying()
                : _buildVerified(context),
          ),
          if (!_verifying)
            _BottomCTA(
              label: 'Confirm & Enter Amount',
              enabled: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EnterAmountScreen(
                    recipientName: _resolvedName,
                    recipientId: widget.recipientId,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerifying() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: BoltPeColors.primary500,
              backgroundColor: BoltPeColors.primary100,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.lg),
          Text(
            'Verifying recipient...',
            style: BoltPeTypography.bodyMd.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xs),
          Text(
            widget.recipientId,
            style: BoltPeTypography.labelLg.copyWith(
              color: BoltPeColors.surfaceTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerified(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BoltPeSpacing.pageX),
      child: Column(
        children: [
          const SizedBox(height: BoltPeSpacing.xl),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BoltPeColors.primary300, BoltPeColors.accent400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _resolvedName
                    .split(' ')
                    .map((e) => e[0])
                    .take(2)
                    .join(),
                style: BoltPeTypography.headingMd.copyWith(
                  color: BoltPeColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: BoltPeSpacing.md),
          // Verified badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BoltPeSpacing.xs,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: BoltPeColors.cardBgPositive,
              borderRadius: BorderRadius.circular(BoltPeRadii.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded,
                    size: 13,
                    color: BoltPeColors.surfaceIconPositive),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: BoltPeTypography.labelSm.copyWith(
                    color: BoltPeColors.surfaceTextPositive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: BoltPeSpacing.md),
          Text(
            _resolvedName,
            style: BoltPeTypography.headingLg.copyWith(
              color: BoltPeColors.surfaceTextPrimary,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xxs),
          Text(
            widget.recipientId,
            style: BoltPeTypography.bodyMd.copyWith(
              color: BoltPeColors.surfaceTextSecondary,
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xxl),
          // Details card
          Container(
            padding: const EdgeInsets.all(BoltPeSpacing.lg),
            decoration: BoxDecoration(
              color: BoltPeColors.cardBgDefault,
              borderRadius: BorderRadius.circular(BoltPeRadii.xl),
              border: Border.all(color: BoltPeColors.cardBorderDefault),
            ),
            child: Column(
              children: [
                _InfoRow('Method', widget.method),
                const SizedBox(height: BoltPeSpacing.sm),
                const Divider(
                  color: BoltPeColors.surfaceBorderDefault,
                  height: 1,
                ),
                const SizedBox(height: BoltPeSpacing.sm),
                _InfoRow('Bank', 'ICICI Bank'),
                const SizedBox(height: BoltPeSpacing.xs),
                _InfoRow('UPI ID', widget.recipientId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 3 — Enter Amount
// ═══════════════════════════════════════════════════════════════════════════════
class EnterAmountScreen extends StatefulWidget {
  final String recipientName;
  final String recipientId;

  const EnterAmountScreen({
    super.key,
    required this.recipientName,
    required this.recipientId,
  });

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  String _amount = '';
  final _noteCtrl = TextEditingController();
  final _quickAmounts = ['500', '1,000', '2,000', '5,000', '10,000'];

  bool get _isValid {
    final val = int.tryParse(_amount.replaceAll(',', '')) ?? 0;
    return val >= 1 && val <= 100000;
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _appendDigit(String d) {
    setState(() {
      if (d == '⌫') {
        if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
      } else if (d == '.' && _amount.contains('.')) {
        // ignore
      } else {
        _amount += d;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      appBar: _BoltPeAppBar(title: 'Enter Amount'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: BoltPeSpacing.xl),
                  // Recipient row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.pageX),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                BoltPeColors.primary300,
                                BoltPeColors.accent400
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.recipientName
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join(),
                              style: BoltPeTypography.labelSm
                                  .copyWith(color: BoltPeColors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: BoltPeSpacing.xs),
                        Text(
                          'Sending to ${widget.recipientName}',
                          style: BoltPeTypography.bodyMd.copyWith(
                            color: BoltPeColors.surfaceTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xxl),
                  // Amount display
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.pageX),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹',
                          style: BoltPeTypography.headingMd.copyWith(
                            color: _amount.isEmpty
                                ? BoltPeColors.surfaceTextTertiary
                                : BoltPeColors.surfaceTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _amount.isEmpty ? '0' : _amount,
                          style: BoltPeTypography.display2xl.copyWith(
                            color: _amount.isEmpty
                                ? BoltPeColors.surfaceTextTertiary
                                : BoltPeColors.surfaceTextPrimary,
                            fontSize: 52,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.sm),
                  // Balance hint
                  Text(
                    'Available Balance: ₹12,450.00',
                    style: BoltPeTypography.bodySm.copyWith(
                      color: BoltPeColors.surfaceTextTertiary,
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.lg),
                  // Quick amounts
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.pageX),
                    child: Row(
                      children: _quickAmounts.map((amt) {
                        return GestureDetector(
                          onTap: () => setState(
                              () => _amount = amt.replaceAll(',', '')),
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: BoltPeSpacing.xs),
                            padding: const EdgeInsets.symmetric(
                              horizontal: BoltPeSpacing.md,
                              vertical: BoltPeSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: _amount ==
                                      amt.replaceAll(',', '')
                                  ? BoltPeColors.primary50
                                  : BoltPeColors.surfaceBgSecondary,
                              borderRadius: BorderRadius.circular(
                                  BoltPeRadii.full),
                              border: Border.all(
                                color: _amount ==
                                        amt.replaceAll(',', '')
                                    ? BoltPeColors.primary500
                                    : BoltPeColors.surfaceBorderDefault,
                              ),
                            ),
                            child: Text(
                              '₹$amt',
                              style: BoltPeTypography.labelMd.copyWith(
                                color: _amount ==
                                        amt.replaceAll(',', '')
                                    ? BoltPeColors.primary500
                                    : BoltPeColors.surfaceTextSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  // Note field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.pageX),
                    child: TextField(
                      controller: _noteCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Add a note (optional)',
                        prefixIcon:
                            Icon(Icons.edit_note_rounded, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  // Numpad
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.pageX),
                    child: _Numpad(onKey: _appendDigit),
                  ),
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: _amount.isEmpty
                ? 'Enter Amount'
                : 'Pay ₹${_amount.isEmpty ? '0' : _amount}',
            enabled: _isValid,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransferConfirmScreen(
                  recipientName: widget.recipientName,
                  recipientId: widget.recipientId,
                  amount: _amount,
                  note: _noteCtrl.text,
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
// SCREEN 4 — Transfer Confirmation
// ═══════════════════════════════════════════════════════════════════════════════
class TransferConfirmScreen extends StatefulWidget {
  final String recipientName;
  final String recipientId;
  final String amount;
  final String note;

  const TransferConfirmScreen({
    super.key,
    required this.recipientName,
    required this.recipientId,
    required this.amount,
    required this.note,
  });

  @override
  State<TransferConfirmScreen> createState() =>
      _TransferConfirmScreenState();
}

class _TransferConfirmScreenState extends State<TransferConfirmScreen> {
  int _selectedUpi = 0;
  final _upis = ['sanket@boltpe', 'sanket@okicici', 'sanket@ybl'];

  String get _formattedAmount {
    final val = int.tryParse(widget.amount) ?? 0;
    return '₹${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Confirm Transfer'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                children: [
                  // Transfer summary card
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF181818), BoltPeColors.primary800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(BoltPeRadii.xxl),
                    ),
                    child: Column(
                      children: [
                        // Sender → Recipient
                        Row(
                          children: [
                            _TransferAvatar(
                                label: 'You',
                                initials: 'SU',
                                subtitle: 'sanket@boltpe'),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      _dashedLine(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: BoltPeSpacing.sm,
                                          vertical: BoltPeSpacing.xxs,
                                        ),
                                        decoration: BoxDecoration(
                                          color: BoltPeColors.primary500,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  BoltPeRadii.full),
                                        ),
                                        child: Text(
                                          _formattedAmount,
                                          style:
                                              BoltPeTypography.labelMd.copyWith(
                                            color: BoltPeColors.white,
                                          ),
                                        ),
                                      ),
                                      _dashedLine(),
                                    ],
                                  ),
                                  const SizedBox(height: BoltPeSpacing.xxs),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: BoltPeColors.white
                                        .withValues(alpha: 0.4),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            _TransferAvatar(
                              label: widget.recipientName
                                  .split(' ')
                                  .first,
                              initials: widget.recipientName
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join(),
                              subtitle: widget.recipientId,
                            ),
                          ],
                        ),
                        if (widget.note.isNotEmpty) ...[
                          const SizedBox(height: BoltPeSpacing.md),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: BoltPeSpacing.md,
                              vertical: BoltPeSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: BoltPeColors.white.withValues(alpha: 0.08),
                              borderRadius:
                                  BorderRadius.circular(BoltPeRadii.sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  color:
                                      BoltPeColors.white.withValues(alpha: 0.5),
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.note,
                                  style: BoltPeTypography.bodySm.copyWith(
                                    color: BoltPeColors.white
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  // Details
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
                        _InfoRow('To', widget.recipientName),
                        const SizedBox(height: BoltPeSpacing.xs),
                        _InfoRow('UPI ID', widget.recipientId),
                        const SizedBox(height: BoltPeSpacing.xs),
                        _InfoRow('Amount', _formattedAmount),
                        const SizedBox(height: BoltPeSpacing.xs),
                        _InfoRow('Transfer Fee', 'Free'),
                        if (widget.note.isNotEmpty) ...[
                          const SizedBox(height: BoltPeSpacing.xs),
                          _InfoRow('Note', widget.note),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  // UPI selector
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pay From',
                      style: BoltPeTypography.headingSm.copyWith(
                        color: BoltPeColors.surfaceTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  ...List.generate(_upis.length, (i) {
                    final selected = _selectedUpi == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedUpi = i),
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: BoltPeSpacing.xs),
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
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _upis[i],
                                    style: BoltPeTypography.labelLg
                                        .copyWith(
                                      color:
                                          BoltPeColors.surfaceTextPrimary,
                                    ),
                                  ),
                                  Text(
                                    'UPI',
                                    style: BoltPeTypography.bodySm
                                        .copyWith(
                                      color: BoltPeColors
                                          .surfaceTextSecondary,
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
            label: 'Pay $_formattedAmount',
            enabled: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TransferProcessingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashedLine() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BoltPeColors.white.withValues(alpha: 0.2),
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 5 — Processing
// ═══════════════════════════════════════════════════════════════════════════════
class TransferProcessingScreen extends StatefulWidget {
  const TransferProcessingScreen({super.key});

  @override
  State<TransferProcessingScreen> createState() =>
      _TransferProcessingScreenState();
}

class _TransferProcessingScreenState extends State<TransferProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  int _step = 0;

  final _steps = [
    'Initiating transfer...',
    'Contacting bank...',
    'Authorising payment...',
    'Completing transfer...',
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Cycle through steps
    for (int i = 1; i < _steps.length; i++) {
      Future.delayed(Duration(milliseconds: 600 * i), () {
        if (mounted) setState(() => _step = i);
      });
    }

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const TransferSuccessScreen()),
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
              builder: (_, __) => Container(
                width: 80 + _pulse.value * 24,
                height: 80 + _pulse.value * 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BoltPeColors.primary500
                      .withValues(alpha: 0.08 + _pulse.value * 0.1),
                ),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: BoltPeColors.primary500,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: BoltPeColors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: BoltPeSpacing.xl),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _steps[_step],
                key: ValueKey(_step),
                style: BoltPeTypography.headingMd.copyWith(
                  color: BoltPeColors.surfaceTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: BoltPeSpacing.xs),
            Text(
              'Do not press back or close the app',
              style: BoltPeTypography.bodyMd.copyWith(
                color: BoltPeColors.surfaceTextSecondary,
              ),
            ),
            const SizedBox(height: BoltPeSpacing.xxl),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: BoltPeColors.surfaceBgTertiary,
                color: BoltPeColors.primary500,
                minHeight: 4,
                borderRadius: BorderRadius.circular(BoltPeRadii.full),
              ),
            ),
            // Step dots
            const SizedBox(height: BoltPeSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _step ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= _step
                        ? BoltPeColors.primary500
                        : BoltPeColors.surfaceBgTertiary,
                    borderRadius: BorderRadius.circular(BoltPeRadii.full),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 6 — Success
// ═══════════════════════════════════════════════════════════════════════════════
class TransferSuccessScreen extends StatefulWidget {
  const TransferSuccessScreen({super.key});

  @override
  State<TransferSuccessScreen> createState() =>
      _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scale;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scale = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
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
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
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
                'Money Sent!',
                style: BoltPeTypography.headingLg.copyWith(
                  color: BoltPeColors.surfaceTextPrimary,
                ),
              ),
              const SizedBox(height: BoltPeSpacing.xs),
              Text(
                '₹500 sent to Rahul Kapoor',
                style: BoltPeTypography.bodyMd.copyWith(
                  color: BoltPeColors.surfaceTextSecondary,
                ),
              ),
              const SizedBox(height: BoltPeSpacing.xxl),
              // Transaction card
              Container(
                padding: const EdgeInsets.all(BoltPeSpacing.lg),
                decoration: BoxDecoration(
                  color: BoltPeColors.surfaceBgSecondary,
                  borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                  border: Border.all(
                      color: BoltPeColors.surfaceBorderDefault),
                ),
                child: Column(
                  children: [
                    _InfoRow('Transaction ID', txnId),
                    const SizedBox(height: BoltPeSpacing.sm),
                    const Divider(
                        color: BoltPeColors.surfaceBorderDefault,
                        height: 1),
                    const SizedBox(height: BoltPeSpacing.sm),
                    _InfoRow('Amount', '₹500'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('To', 'rahul@okicici'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('Paid via', 'sanket@boltpe'),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow(
                      'Date & Time',
                      '${DateTime.now().day} Jun 2025, ${TimeOfDay.now().format(context)}',
                    ),
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InfoRow('Status', 'Success',
                        valueColor: BoltPeColors.surfaceTextPositive),
                  ],
                ),
              ),
              const Spacer(),
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
    titleTextStyle: BoltPeTypography.headingSm
        .copyWith(color: BoltPeColors.surfaceTextPrimary),
    leading: Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
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
      child: Container(
          color: BoltPeColors.surfaceBorderDefault, height: 1),
    ),
  );
}

class _BottomCTA extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _BottomCTA(
      {required this.label, required this.enabled, required this.onTap});

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
        border:
            Border(top: BorderSide(color: BoltPeColors.surfaceBorderDefault)),
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

class _ContactTile extends StatelessWidget {
  final String name;
  final String upi;
  final String initials;
  final VoidCallback onTap;

  const _ContactTile({
    required this.name,
    required this.upi,
    required this.initials,
    required this.onTap,
  });

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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [BoltPeColors.primary200, BoltPeColors.primary400],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(initials,
                    style: BoltPeTypography.labelMd
                        .copyWith(color: BoltPeColors.white)),
              ),
            ),
            const SizedBox(width: BoltPeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: BoltPeTypography.labelLg.copyWith(
                          color: BoltPeColors.surfaceTextPrimary)),
                  Text(upi,
                      style: BoltPeTypography.bodySm.copyWith(
                          color: BoltPeColors.surfaceTextSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: BoltPeColors.surfaceIconSubtle, size: 20),
          ],
        ),
      ),
    );
  }
}

class _TransferAvatar extends StatelessWidget {
  final String label;
  final String initials;
  final String subtitle;

  const _TransferAvatar(
      {required this.label,
      required this.initials,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [BoltPeColors.primary300, BoltPeColors.accent400],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(initials,
                style: BoltPeTypography.labelMd
                    .copyWith(color: BoltPeColors.white)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: BoltPeTypography.labelMd
                .copyWith(color: BoltPeColors.white)),
        Text(subtitle,
            style: BoltPeTypography.caption.copyWith(
                color: BoltPeColors.white.withValues(alpha: 0.5))),
      ],
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
        Text(label,
            style: BoltPeTypography.bodyMd
                .copyWith(color: BoltPeColors.surfaceTextSecondary)),
        Text(value,
            style: BoltPeTypography.labelLg.copyWith(
                color: valueColor ?? BoltPeColors.surfaceTextPrimary)),
      ],
    );
  }
}

class _Numpad extends StatelessWidget {
  final void Function(String) onKey;

  const _Numpad({required this.onKey});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];
    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((k) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onKey(k),
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: k == '⌫'
                        ? BoltPeColors.surfaceBgTertiary
                        : BoltPeColors.surfaceBgSecondary,
                    borderRadius: BorderRadius.circular(BoltPeRadii.md),
                  ),
                  child: Center(
                    child: k == '⌫'
                        ? const Icon(Icons.backspace_outlined,
                            size: 20,
                            color: BoltPeColors.surfaceTextSecondary)
                        : Text(
                            k,
                            style: BoltPeTypography.headingMd.copyWith(
                              color: BoltPeColors.surfaceTextPrimary,
                            ),
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    return newVal.copyWith(text: newVal.text.toUpperCase());
  }
}
