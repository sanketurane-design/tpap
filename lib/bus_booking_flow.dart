import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boltpe_theme.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
class BusBookingFlow extends StatelessWidget {
  const BusBookingFlow({super.key});
  @override
  Widget build(BuildContext context) => const BusSearchScreen();
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — Search
// ═══════════════════════════════════════════════════════════════════════════════
class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});
  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  String _from = '';
  String _to = '';
  DateTime _date = DateTime.now();
  int _passengers = 1;
  bool _sameRouteError = false;

  final _recentSearches = [
    {'from': 'Mumbai', 'to': 'Pune'},
    {'from': 'Bangalore', 'to': 'Chennai'},
    {'from': 'Hyderabad', 'to': 'Vijayawada'},
  ];

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
      _sameRouteError = false;
    });
  }

  void _pickCity(bool isFrom) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CityPickerSheet(),
    );
    if (result != null) {
      setState(() {
        if (isFrom) _from = result; else _to = result;
        _sameRouteError = _from.isNotEmpty && _from == _to;
      });
    }
  }

  bool get _canSearch =>
      _from.isNotEmpty && _to.isNotEmpty && !_sameRouteError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Bus Tickets'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From / To card
                  Container(
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                      border: Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Column(
                      children: [
                        // From
                        _CityField(
                          label: 'From',
                          value: _from,
                          hint: 'Select departure city',
                          icon: Icons.trip_origin_rounded,
                          onTap: () => _pickCity(true),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const Divider(height: 1, color: BoltPeColors.surfaceBorderDefault),
                            GestureDetector(
                              onTap: _swap,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: BoltPeColors.surfaceBgPrimary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: BoltPeColors.surfaceBorderDefault),
                                ),
                                child: const Icon(Icons.swap_vert_rounded,
                                    size: 18, color: BoltPeColors.primary500),
                              ),
                            ),
                          ],
                        ),
                        // To
                        _CityField(
                          label: 'To',
                          value: _to,
                          hint: 'Select destination city',
                          icon: Icons.location_on_rounded,
                          onTap: () => _pickCity(false),
                        ),
                      ],
                    ),
                  ),
                  // Same route error
                  if (_sameRouteError) ...[
                    const SizedBox(height: BoltPeSpacing.xs),
                    _InlineError('Departure and destination cannot be the same'),
                  ],
                  const SizedBox(height: BoltPeSpacing.md),
                  // Date + Passengers row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _InfoCard(
                          label: 'Date',
                          value: _formatDate(_date),
                          icon: Icons.calendar_today_rounded,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                              builder: (ctx, child) => Theme(
                                data: Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: BoltPeColors.primary500,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) setState(() => _date = picked);
                          },
                        ),
                      ),
                      const SizedBox(width: BoltPeSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: _InfoCard(
                          label: 'Passengers',
                          value: '$_passengers Adult${_passengers > 1 ? 's' : ''}',
                          icon: Icons.person_rounded,
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _PassengerSheet(
                              count: _passengers,
                              onChanged: (v) => setState(() => _passengers = v),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  // Recent searches
                  if (_recentSearches.isNotEmpty) ...[
                    Text('Recent Searches',
                        style: BoltPeTypography.headingSm.copyWith(
                            color: BoltPeColors.surfaceTextPrimary)),
                    const SizedBox(height: BoltPeSpacing.md),
                    ..._recentSearches.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: BoltPeSpacing.xs),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _from = r['from']!;
                              _to = r['to']!;
                              _sameRouteError = false;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(BoltPeSpacing.md),
                              decoration: BoxDecoration(
                                color: BoltPeColors.cardBgDefault,
                                borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                                border: Border.all(color: BoltPeColors.cardBorderDefault),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.history_rounded,
                                      size: 18, color: BoltPeColors.surfaceIconSubtle),
                                  const SizedBox(width: BoltPeSpacing.sm),
                                  Text('${r['from']}', style: BoltPeTypography.labelLg.copyWith(
                                      color: BoltPeColors.surfaceTextPrimary)),
                                  const SizedBox(width: BoltPeSpacing.xs),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: BoltPeColors.surfaceIconSubtle),
                                  const SizedBox(width: BoltPeSpacing.xs),
                                  Text('${r['to']}', style: BoltPeTypography.labelLg.copyWith(
                                      color: BoltPeColors.surfaceTextPrimary)),
                                  const Spacer(),
                                  const Icon(Icons.north_west_rounded,
                                      size: 16, color: BoltPeColors.surfaceIconSubtle),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: 'Search Buses',
            enabled: _canSearch,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BusResultsScreen(
                from: _from, to: _to, date: _date, passengers: _passengers,
              ),
            )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — Results
// ═══════════════════════════════════════════════════════════════════════════════
class BusResultsScreen extends StatefulWidget {
  final String from, to;
  final DateTime date;
  final int passengers;
  const BusResultsScreen({
    super.key, required this.from, required this.to,
    required this.date, required this.passengers,
  });
  @override
  State<BusResultsScreen> createState() => _BusResultsScreenState();
}

class _BusResultsScreenState extends State<BusResultsScreen> {
  bool _loading = true;
  bool _networkError = false;
  String _activeFilter = 'All';
  final _filters = ['All', 'AC', 'Non-AC', 'Sleeper', 'Seater'];

  final List<_BusRoute> _allBuses = [
    _BusRoute(id: '1', operator: 'VRL Travels', type: 'AC Sleeper',
        departure: '21:30', arrival: '06:00', duration: '8h 30m',
        rating: 4.3, price: 850, seats: 12, amenities: ['WiFi', 'Charging', 'Water', 'Blanket']),
    _BusRoute(id: '2', operator: 'Orange Travels', type: 'AC Seater',
        departure: '22:00', arrival: '06:30', duration: '8h 30m',
        rating: 4.1, price: 650, seats: 3, amenities: ['Charging', 'Water']),
    _BusRoute(id: '3', operator: 'SRS Travels', type: 'Non-AC Sleeper',
        departure: '20:00', arrival: '05:30', duration: '9h 30m',
        rating: 3.8, price: 450, seats: 0, amenities: ['Water']),
    _BusRoute(id: '4', operator: 'KSRTC Express', type: 'AC Seater',
        departure: '07:00', arrival: '13:30', duration: '6h 30m',
        rating: 4.5, price: 550, seats: 28, amenities: ['Charging', 'Water', 'WiFi']),
    _BusRoute(id: '5', operator: 'Neeta Travels', type: 'Non-AC Seater',
        departure: '06:00', arrival: '12:30', duration: '6h 30m',
        rating: 3.6, price: 320, seats: 15, amenities: ['Water']),
  ];

  List<_BusRoute> get _filtered => _activeFilter == 'All'
      ? _allBuses
      : _allBuses.where((b) => b.type.contains(_activeFilter)).toList();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: '${widget.from} → ${widget.to}'),
      body: Column(
        children: [
          // Route summary strip
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.fromLTRB(
                BoltPeSpacing.pageX, 0, BoltPeSpacing.pageX, BoltPeSpacing.md),
            child: Row(
              children: [
                Text(_formatDate(widget.date),
                    style: BoltPeTypography.labelLg.copyWith(
                        color: BoltPeColors.surfaceTextSecondary)),
                const SizedBox(width: BoltPeSpacing.xs),
                Container(width: 4, height: 4,
                    decoration: const BoxDecoration(
                        color: BoltPeColors.surfaceTextTertiary,
                        shape: BoxShape.circle)),
                const SizedBox(width: BoltPeSpacing.xs),
                Text('${widget.passengers} Passenger${widget.passengers > 1 ? 's' : ''}',
                    style: BoltPeTypography.labelLg.copyWith(
                        color: BoltPeColors.surfaceTextSecondary)),
              ],
            ),
          ),
          // Filter chips
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.only(bottom: BoltPeSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: BoltPeSpacing.pageX),
              child: Row(
                children: _filters.map((f) {
                  final active = _activeFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: BoltPeSpacing.xs),
                      padding: const EdgeInsets.symmetric(
                          horizontal: BoltPeSpacing.md, vertical: BoltPeSpacing.xxs),
                      decoration: BoxDecoration(
                        color: active ? BoltPeColors.primary500 : BoltPeColors.surfaceBgSecondary,
                        borderRadius: BorderRadius.circular(BoltPeRadii.full),
                        border: Border.all(
                          color: active ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderDefault,
                        ),
                      ),
                      child: Text(f,
                          style: BoltPeTypography.labelMd.copyWith(
                              color: active ? BoltPeColors.white : BoltPeColors.surfaceTextSecondary)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? _buildSkeletons()
                : _networkError
                    ? _NetworkErrorState(onRetry: () => setState(() {
                          _networkError = false;
                          _loading = true;
                          Future.delayed(const Duration(milliseconds: 1500),
                              () { if (mounted) setState(() => _loading = false); });
                        }))
                    : _filtered.isEmpty
                        ? _NoBusesState(from: widget.from, to: widget.to, date: widget.date)
                        : ListView.separated(
                            padding: const EdgeInsets.all(BoltPeSpacing.pageX),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: BoltPeSpacing.sm),
                            itemBuilder: (ctx, i) => _BusResultCard(
                              bus: _filtered[i],
                              onTap: _filtered[i].seats == 0 ? null : () =>
                                  Navigator.push(ctx, MaterialPageRoute(
                                    builder: (_) => BusDetailScreen(bus: _filtered[i]),
                                  )),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletons() {
    return ListView.separated(
      padding: const EdgeInsets.all(BoltPeSpacing.pageX),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: BoltPeSpacing.sm),
      itemBuilder: (_, __) => _SkeletonCard(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 3 — Bus Detail
// ═══════════════════════════════════════════════════════════════════════════════
class BusDetailScreen extends StatelessWidget {
  final _BusRoute bus;
  const BusDetailScreen({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: bus.operator),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time card
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF181818), BoltPeColors.primary800],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TimeBlock(time: bus.departure, label: 'Departs'),
                        Column(children: [
                          Text(bus.duration,
                              style: BoltPeTypography.labelMd.copyWith(
                                  color: BoltPeColors.white.withValues(alpha: 0.6))),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 80,
                            child: Stack(alignment: Alignment.center, children: [
                              Container(height: 1,
                                  color: BoltPeColors.white.withValues(alpha: 0.3)),
                              const Icon(Icons.directions_bus_rounded,
                                  color: BoltPeColors.primary500, size: 20),
                            ]),
                          ),
                        ]),
                        _TimeBlock(time: bus.arrival, label: 'Arrives', alignRight: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  // Info row
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.md),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                      border: Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _DetailStat(label: 'Type', value: bus.type),
                        _vDivider(),
                        _DetailStat(label: 'Rating', value: '⭐ ${bus.rating}'),
                        _vDivider(),
                        _DetailStat(label: 'Seats Left', value: '${bus.seats}',
                            valueColor: bus.seats <= 5 ? BoltPeColors.surfaceTextNegative : null),
                        _vDivider(),
                        _DetailStat(label: 'Price', value: '₹${bus.price}',
                            valueColor: BoltPeColors.primary500),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.lg),
                  Text('Amenities', style: BoltPeTypography.headingSm.copyWith(
                      color: BoltPeColors.surfaceTextPrimary)),
                  const SizedBox(height: BoltPeSpacing.sm),
                  Wrap(
                    spacing: BoltPeSpacing.xs,
                    runSpacing: BoltPeSpacing.xs,
                    children: bus.amenities.map((a) => _AmenityChip(label: a)).toList(),
                  ),
                  const SizedBox(height: BoltPeSpacing.lg),
                  // Cancellation policy
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.md),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgInformation,
                      borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                      border: Border.all(
                          color: BoltPeColors.surfaceTextInformation.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 16, color: BoltPeColors.surfaceTextInformation),
                          const SizedBox(width: BoltPeSpacing.xs),
                          Text('Cancellation Policy',
                              style: BoltPeTypography.labelLg.copyWith(
                                  color: BoltPeColors.surfaceTextInformation)),
                        ]),
                        const SizedBox(height: BoltPeSpacing.xs),
                        Text('Free cancellation up to 2 hours before departure. 50% refund between 2–6 hours. No refund within 2 hours.',
                            style: BoltPeTypography.bodySm.copyWith(
                                color: BoltPeColors.surfaceTextInformation
                                    .withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: 'Select Boarding & Dropping Points',
            enabled: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BoardingDroppingScreen(bus: bus),
            )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 4 — Boarding & Dropping Points (separate as requested)
// ═══════════════════════════════════════════════════════════════════════════════
class BoardingDroppingScreen extends StatefulWidget {
  final _BusRoute bus;
  const BoardingDroppingScreen({super.key, required this.bus});
  @override
  State<BoardingDroppingScreen> createState() => _BoardingDroppingScreenState();
}

class _BoardingDroppingScreenState extends State<BoardingDroppingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _selectedBoarding = 0;
  int _selectedDropping = 0;

  final _boardingPoints = [
    _StopPoint('Majestic Bus Stand', 'Near City Railway Station', '21:30'),
    _StopPoint('Silk Board', 'Silk Board Junction', '21:50'),
    _StopPoint('Electronic City', 'Infosys Gate 1', '22:10'),
    _StopPoint('Bommasandra', 'Bommasandra Industrial Area', '22:25'),
  ];

  final _droppingPoints = [
    _StopPoint('Shivajinagar', 'Near FC Road', '05:45'),
    _StopPoint('Swargate', 'Swargate Bus Stand', '06:00'),
    _StopPoint('Katraj', 'Katraj Chowk', '06:20'),
    _StopPoint('Satara Road', 'Satara Road Terminus', '06:40'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Boarding & Dropping'),
      body: Column(
        children: [
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.fromLTRB(
                BoltPeSpacing.pageX, BoltPeSpacing.sm, BoltPeSpacing.pageX, BoltPeSpacing.md),
            child: Container(
              decoration: BoxDecoration(
                color: BoltPeColors.surfaceBgSecondary,
                borderRadius: BorderRadius.circular(BoltPeRadii.md),
              ),
              child: TabBar(
                controller: _tabs,
                indicator: BoxDecoration(
                  color: BoltPeColors.primary500,
                  borderRadius: BorderRadius.circular(BoltPeRadii.sm),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: BoltPeColors.white,
                unselectedLabelColor: BoltPeColors.surfaceTextSecondary,
                labelStyle: BoltPeTypography.labelMd,
                unselectedLabelStyle: BoltPeTypography.labelMd,
                tabs: const [Tab(text: 'Boarding Point'), Tab(text: 'Dropping Point')],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _StopList(
                  points: _boardingPoints,
                  selectedIndex: _selectedBoarding,
                  accentLabel: 'Boarding',
                  onSelect: (i) => setState(() => _selectedBoarding = i),
                ),
                _StopList(
                  points: _droppingPoints,
                  selectedIndex: _selectedDropping,
                  accentLabel: 'Dropping',
                  onSelect: (i) => setState(() => _selectedDropping = i),
                ),
              ],
            ),
          ),
          // Summary strip
          Container(
            padding: const EdgeInsets.fromLTRB(
                BoltPeSpacing.pageX, BoltPeSpacing.md, BoltPeSpacing.pageX, 0),
            color: BoltPeColors.surfaceBgPrimary,
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStop(
                    icon: Icons.trip_origin_rounded,
                    color: BoltPeColors.surfaceIconPositive,
                    label: 'Boarding',
                    name: _boardingPoints[_selectedBoarding].name,
                    time: _boardingPoints[_selectedBoarding].time,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: BoltPeColors.surfaceBorderDefault,
                  margin: const EdgeInsets.symmetric(horizontal: BoltPeSpacing.sm),
                ),
                Expanded(
                  child: _SummaryStop(
                    icon: Icons.location_on_rounded,
                    color: BoltPeColors.primary500,
                    label: 'Dropping',
                    name: _droppingPoints[_selectedDropping].name,
                    time: _droppingPoints[_selectedDropping].time,
                  ),
                ),
              ],
            ),
          ),
          _BottomCTA(
            label: 'Select Seats',
            enabled: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => SeatSelectionScreen(
                bus: widget.bus,
                boarding: _boardingPoints[_selectedBoarding],
                dropping: _droppingPoints[_selectedDropping],
              ),
            )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 5 — Seat Selection
// ═══════════════════════════════════════════════════════════════════════════════
class SeatSelectionScreen extends StatefulWidget {
  final _BusRoute bus;
  final _StopPoint boarding, dropping;
  const SeatSelectionScreen({
    super.key, required this.bus, required this.boarding, required this.dropping,
  });
  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  bool _showLower = true;
  final Set<String> _selected = {};

  // Seat layout: rows 1–10, columns A B | C D (2+2)
  // Pre-populated booked seats
  final Set<String> _bookedLower = {'L1A', 'L1B', 'L3C', 'L4D', 'L5A', 'L7B', 'L8C', 'L9D'};
  final Set<String> _bookedUpper = {'U2A', 'U3B', 'U5C', 'U6D', 'U8A', 'U9C'};
  final Set<String> _ladiesLower = {'L2A', 'L2B'};
  final Set<String> _ladiesUpper = {'U1A', 'U1B'};

  bool get _hasConflict =>
      _selected.any((s) => _bookedLower.contains(s) || _bookedUpper.contains(s));

  Set<String> get _bookedCurrent => _showLower ? _bookedLower : _bookedUpper;
  Set<String> get _ladiesCurrent => _showLower ? _ladiesLower : _ladiesUpper;
  String get _prefix => _showLower ? 'L' : 'U';

  _SeatStatus _statusOf(String id) {
    if (_selected.contains(id)) return _SeatStatus.selected;
    if (_bookedCurrent.contains(id)) return _SeatStatus.booked;
    if (_ladiesCurrent.contains(id)) return _SeatStatus.ladies;
    return _SeatStatus.available;
  }

  void _toggleSeat(String id) {
    final status = _statusOf(id);
    if (status == _SeatStatus.booked) return;
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        if (_selected.length >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Max 6 seats per booking')),
          );
          return;
        }
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Select Seats'),
      body: Column(
        children: [
          // Deck toggle
          Container(
            color: BoltPeColors.surfaceBgPrimary,
            padding: const EdgeInsets.all(BoltPeSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DeckToggle(label: 'Lower Deck', active: _showLower,
                    onTap: () => setState(() => _showLower = true)),
                const SizedBox(width: BoltPeSpacing.sm),
                _DeckToggle(label: 'Upper Deck', active: !_showLower,
                    onTap: () => setState(() => _showLower = false)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                children: [
                  // Legend
                  _SeatLegend(),
                  const SizedBox(height: BoltPeSpacing.lg),
                  // Driver cabin indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: BoltPeSpacing.sm),
                    decoration: BoxDecoration(
                      color: BoltPeColors.surfaceBgTertiary,
                      borderRadius: BorderRadius.circular(BoltPeRadii.sm),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.steering_wheel_outlined,
                          size: 16, color: BoltPeColors.surfaceTextSecondary),
                      const SizedBox(width: BoltPeSpacing.xs),
                      Text('Driver', style: BoltPeTypography.bodySm.copyWith(
                          color: BoltPeColors.surfaceTextSecondary)),
                    ]),
                  ),
                  const SizedBox(height: BoltPeSpacing.lg),
                  // Seat grid — rows 1–10
                  ...List.generate(10, (row) {
                    final r = row + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: BoltPeSpacing.sm),
                      child: Row(
                        children: [
                          // Row number
                          SizedBox(
                            width: 24,
                            child: Text('$r',
                                style: BoltPeTypography.bodySm.copyWith(
                                    color: BoltPeColors.surfaceTextTertiary),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(width: BoltPeSpacing.xs),
                          // Left pair: A, B
                          _SeatWidget(id: '${_prefix}${r}A', status: _statusOf('${_prefix}${r}A'),
                              onTap: () => _toggleSeat('${_prefix}${r}A')),
                          const SizedBox(width: BoltPeSpacing.xs),
                          _SeatWidget(id: '${_prefix}${r}B', status: _statusOf('${_prefix}${r}B'),
                              onTap: () => _toggleSeat('${_prefix}${r}B')),
                          // Aisle
                          const Spacer(),
                          // Right pair: C, D
                          _SeatWidget(id: '${_prefix}${r}C', status: _statusOf('${_prefix}${r}C'),
                              onTap: () => _toggleSeat('${_prefix}${r}C')),
                          const SizedBox(width: BoltPeSpacing.xs),
                          _SeatWidget(id: '${_prefix}${r}D', status: _statusOf('${_prefix}${r}D'),
                              onTap: () => _toggleSeat('${_prefix}${r}D')),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Selected summary
          if (_selected.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(
                  BoltPeSpacing.pageX, BoltPeSpacing.md, BoltPeSpacing.pageX, 0),
              color: BoltPeColors.surfaceBgPrimary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${_selected.length} seat${_selected.length > 1 ? 's' : ''} selected',
                        style: BoltPeTypography.labelLg.copyWith(
                            color: BoltPeColors.surfaceTextPrimary)),
                    Text(_selected.join(', '),
                        style: BoltPeTypography.bodySm.copyWith(
                            color: BoltPeColors.surfaceTextSecondary)),
                  ]),
                  Text('₹${widget.bus.price * _selected.length}',
                      style: BoltPeTypography.headingMd.copyWith(
                          color: BoltPeColors.primary500)),
                ],
              ),
            ),
          _BottomCTA(
            label: _selected.isEmpty
                ? 'Select at least 1 seat'
                : 'Proceed — ₹${widget.bus.price * _selected.length}',
            enabled: _selected.isNotEmpty,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => TravellerDetailsScreen(
                bus: widget.bus,
                seats: _selected.toList(),
                boarding: widget.boarding,
                dropping: widget.dropping,
              ),
            )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 6 — Traveller Details
// ═══════════════════════════════════════════════════════════════════════════════
class TravellerDetailsScreen extends StatefulWidget {
  final _BusRoute bus;
  final List<String> seats;
  final _StopPoint boarding, dropping;
  const TravellerDetailsScreen({
    super.key, required this.bus, required this.seats,
    required this.boarding, required this.dropping,
  });
  @override
  State<TravellerDetailsScreen> createState() => _TravellerDetailsScreenState();
}

class _TravellerDetailsScreenState extends State<TravellerDetailsScreen> {
  late List<Map<String, dynamic>> _travellers;
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _travellers = List.generate(widget.seats.length, (_) => {
      'name': TextEditingController(),
      'age': TextEditingController(),
      'gender': 'Male',
    });
  }

  @override
  void dispose() {
    for (final t in _travellers) {
      (t['name'] as TextEditingController).dispose();
      (t['age'] as TextEditingController).dispose();
    }
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Traveller Details'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(BoltPeSpacing.pageX),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Per traveller forms
                    ...List.generate(widget.seats.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: BoltPeSpacing.md),
                        child: Container(
                          padding: const EdgeInsets.all(BoltPeSpacing.lg),
                          decoration: BoxDecoration(
                            color: BoltPeColors.cardBgDefault,
                            borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                            border: Border.all(color: BoltPeColors.cardBorderDefault),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: BoltPeSpacing.xs, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: BoltPeColors.primary50,
                                    borderRadius: BorderRadius.circular(BoltPeRadii.xs),
                                  ),
                                  child: Text('Seat ${widget.seats[i]}',
                                      style: BoltPeTypography.labelSm.copyWith(
                                          color: BoltPeColors.primary500)),
                                ),
                                const SizedBox(width: BoltPeSpacing.xs),
                                Text('Passenger ${i + 1}',
                                    style: BoltPeTypography.labelLg.copyWith(
                                        color: BoltPeColors.surfaceTextSecondary)),
                              ]),
                              const SizedBox(height: BoltPeSpacing.md),
                              TextFormField(
                                controller: _travellers[i]['name'],
                                decoration: const InputDecoration(labelText: 'Full Name'),
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                              ),
                              const SizedBox(height: BoltPeSpacing.sm),
                              Row(children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _travellers[i]['age'],
                                    decoration: const InputDecoration(labelText: 'Age'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    validator: (v) {
                                      final age = int.tryParse(v ?? '');
                                      if (age == null) return 'Required';
                                      if (age < 1 || age > 120) return 'Invalid age';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: BoltPeSpacing.sm),
                                Expanded(
                                  flex: 3,
                                  child: DropdownButtonFormField<String>(
                                    value: _travellers[i]['gender'],
                                    decoration: const InputDecoration(labelText: 'Gender'),
                                    items: ['Male', 'Female', 'Other']
                                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                        .toList(),
                                    onChanged: (v) => setState(() => _travellers[i]['gender'] = v),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      );
                    }),
                    // Contact details
                    Container(
                      padding: const EdgeInsets.all(BoltPeSpacing.lg),
                      decoration: BoxDecoration(
                        color: BoltPeColors.cardBgDefault,
                        borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                        border: Border.all(color: BoltPeColors.cardBorderDefault),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact Details',
                              style: BoltPeTypography.headingSm.copyWith(
                                  color: BoltPeColors.surfaceTextPrimary)),
                          const SizedBox(height: BoltPeSpacing.md),
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              helperText: 'Ticket will be sent to this email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                          ),
                          const SizedBox(height: BoltPeSpacing.sm),
                          TextFormField(
                            controller: _phoneCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              prefixText: '+91  ',
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) =>
                                (v == null || v.length != 10) ? 'Enter 10-digit number' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomCTA(
              label: 'Review Booking',
              enabled: true,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ReviewBookingScreen(
                      bus: widget.bus,
                      seats: widget.seats,
                      boarding: widget.boarding,
                      dropping: widget.dropping,
                      travellers: _travellers,
                      email: _emailCtrl.text,
                      phone: _phoneCtrl.text,
                    ),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 7 — Review Booking
// ═══════════════════════════════════════════════════════════════════════════════
class ReviewBookingScreen extends StatefulWidget {
  final _BusRoute bus;
  final List<String> seats;
  final _StopPoint boarding, dropping;
  final List<Map<String, dynamic>> travellers;
  final String email, phone;
  const ReviewBookingScreen({
    super.key, required this.bus, required this.seats,
    required this.boarding, required this.dropping,
    required this.travellers, required this.email, required this.phone,
  });
  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  int _selectedUpi = 0;
  final _upis = ['sanket@boltpe', 'sanket@okicici', 'sanket@ybl'];

  int get _totalFare => widget.bus.price * widget.seats.length;
  int get _convenience => (_totalFare * 0.02).round().clamp(20, 50);
  int get _grandTotal => _totalFare + _convenience;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgSecondary,
      appBar: _BoltPeAppBar(title: 'Review Booking'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(BoltPeSpacing.pageX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Journey card
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF0A3D62), Color(0xFF1E6EA6)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                    ),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        _TimeBlock(time: widget.bus.departure, label: widget.boarding.name),
                        Column(children: [
                          Text(widget.bus.duration,
                              style: BoltPeTypography.bodySm.copyWith(
                                  color: BoltPeColors.white.withValues(alpha: 0.6))),
                          const Icon(Icons.directions_bus_rounded,
                              color: BoltPeColors.white, size: 20),
                        ]),
                        _TimeBlock(time: widget.bus.arrival, label: widget.dropping.name,
                            alignRight: true),
                      ]),
                      const SizedBox(height: BoltPeSpacing.md),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: BoltPeSpacing.md),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(widget.bus.operator,
                            style: BoltPeTypography.labelLg.copyWith(
                                color: BoltPeColors.white)),
                        Text('Seats: ${widget.seats.join(', ')}',
                            style: BoltPeTypography.labelMd.copyWith(
                                color: BoltPeColors.white.withValues(alpha: 0.7))),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  // Travellers
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                      border: Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Travellers',
                            style: BoltPeTypography.headingSm.copyWith(
                                color: BoltPeColors.surfaceTextPrimary)),
                        const SizedBox(height: BoltPeSpacing.md),
                        ...List.generate(widget.travellers.length, (i) => Padding(
                          padding: const EdgeInsets.only(bottom: BoltPeSpacing.xs),
                          child: Row(children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: BoltPeColors.primary50,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Text('${i + 1}',
                                  style: BoltPeTypography.labelMd.copyWith(
                                      color: BoltPeColors.primary500))),
                            ),
                            const SizedBox(width: BoltPeSpacing.sm),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text((widget.travellers[i]['name'] as TextEditingController).text,
                                  style: BoltPeTypography.labelLg.copyWith(
                                      color: BoltPeColors.surfaceTextPrimary)),
                              Text('Age ${(widget.travellers[i]['age'] as TextEditingController).text} • ${widget.travellers[i]['gender']} • Seat ${widget.seats[i]}',
                                  style: BoltPeTypography.bodySm.copyWith(
                                      color: BoltPeColors.surfaceTextSecondary)),
                            ])),
                          ]),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: BoltPeSpacing.md),
                  // Fare breakdown
                  Container(
                    padding: const EdgeInsets.all(BoltPeSpacing.lg),
                    decoration: BoxDecoration(
                      color: BoltPeColors.cardBgDefault,
                      borderRadius: BorderRadius.circular(BoltPeRadii.xl),
                      border: Border.all(color: BoltPeColors.cardBorderDefault),
                    ),
                    child: Column(children: [
                      _InfoRow('Base Fare (${widget.seats.length} × ₹${widget.bus.price})',
                          '₹$_totalFare'),
                      const SizedBox(height: BoltPeSpacing.xs),
                      _InfoRow('Convenience Fee', '₹$_convenience'),
                      const SizedBox(height: BoltPeSpacing.sm),
                      const Divider(color: BoltPeColors.surfaceBorderDefault, height: 1),
                      const SizedBox(height: BoltPeSpacing.sm),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total Payable',
                            style: BoltPeTypography.headingSm.copyWith(
                                color: BoltPeColors.surfaceTextPrimary)),
                        Text('₹$_grandTotal',
                            style: BoltPeTypography.headingSm.copyWith(
                                color: BoltPeColors.primary500)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: BoltPeSpacing.xl),
                  Text('Pay From',
                      style: BoltPeTypography.headingSm.copyWith(
                          color: BoltPeColors.surfaceTextPrimary)),
                  const SizedBox(height: BoltPeSpacing.md),
                  ...List.generate(_upis.length, (i) {
                    final sel = _selectedUpi == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedUpi = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: BoltPeSpacing.xs),
                        padding: const EdgeInsets.all(BoltPeSpacing.md),
                        decoration: BoxDecoration(
                          color: sel ? BoltPeColors.surfaceBgSelected : BoltPeColors.cardBgDefault,
                          borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                          border: Border.all(
                            color: sel ? BoltPeColors.cardBorderSelected : BoltPeColors.cardBorderDefault,
                            width: sel ? 1.5 : 1,
                          ),
                        ),
                        child: Row(children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                                color: BoltPeColors.primary50,
                                borderRadius: BorderRadius.circular(BoltPeRadii.sm)),
                            child: const Icon(Icons.account_balance_wallet_rounded,
                                color: BoltPeColors.primary500, size: 18),
                          ),
                          const SizedBox(width: BoltPeSpacing.md),
                          Expanded(child: Text(_upis[i],
                              style: BoltPeTypography.labelLg.copyWith(
                                  color: BoltPeColors.surfaceTextPrimary))),
                          Radio<int>(
                            value: i, groupValue: _selectedUpi,
                            onChanged: (v) => setState(() => _selectedUpi = v!),
                            activeColor: BoltPeColors.primary500,
                          ),
                        ]),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          _BottomCTA(
            label: 'Pay ₹$_grandTotal',
            enabled: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BusPaymentProcessingScreen(totalFare: _grandTotal),
            )),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 8a — Payment Processing
// ═══════════════════════════════════════════════════════════════════════════════
class BusPaymentProcessingScreen extends StatefulWidget {
  final int totalFare;
  const BusPaymentProcessingScreen({super.key, required this.totalFare});
  @override
  State<BusPaymentProcessingScreen> createState() => _BusPaymentProcessingState();
}

class _BusPaymentProcessingState extends State<BusPaymentProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  // Simulate 10% payment failure for demo — set true to test failure screen
  final bool _simulateFailure = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      if (_simulateFailure) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(totalFare: widget.totalFare),
        ));
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BookingConfirmedScreen(totalFare: widget.totalFare)),
          (r) => r.isFirst,
        );
      }
    });
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              width: 80 + _pulse.value * 20,
              height: 80 + _pulse.value * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BoltPeColors.primary500.withValues(alpha: 0.1 + _pulse.value * 0.1),
              ),
              child: Center(child: Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: BoltPeColors.primary500),
                child: const Icon(Icons.directions_bus_rounded,
                    color: BoltPeColors.white, size: 34),
              )),
            ),
          ),
          const SizedBox(height: BoltPeSpacing.xl),
          Text('Confirming your booking...',
              style: BoltPeTypography.headingMd.copyWith(
                  color: BoltPeColors.surfaceTextPrimary)),
          const SizedBox(height: BoltPeSpacing.xs),
          Text('Do not press back', style: BoltPeTypography.bodyMd.copyWith(
              color: BoltPeColors.surfaceTextSecondary)),
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
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 8b — Payment Failed (Error case)
// ═══════════════════════════════════════════════════════════════════════════════
class PaymentFailedScreen extends StatelessWidget {
  final int totalFare;
  const PaymentFailedScreen({super.key, required this.totalFare});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BoltPeSpacing.pageX),
          child: Column(children: [
            const Spacer(),
            Container(
              width: 96, height: 96,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: BoltPeColors.cardBgNegative),
              child: const Icon(Icons.close_rounded,
                  color: BoltPeColors.surfaceIconNegative, size: 52),
            ),
            const SizedBox(height: BoltPeSpacing.xl),
            Text('Payment Failed',
                style: BoltPeTypography.headingLg.copyWith(
                    color: BoltPeColors.surfaceTextPrimary)),
            const SizedBox(height: BoltPeSpacing.xs),
            Text('Your payment of ₹$totalFare could not be processed.\nNo amount was deducted.',
                style: BoltPeTypography.bodyMd.copyWith(
                    color: BoltPeColors.surfaceTextSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: BoltPeSpacing.xxl),
            Container(
              padding: const EdgeInsets.all(BoltPeSpacing.md),
              decoration: BoxDecoration(
                color: BoltPeColors.cardBgNegative,
                borderRadius: BorderRadius.circular(BoltPeRadii.lg),
                border: Border.all(
                    color: BoltPeColors.surfaceTextNegative.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded,
                    color: BoltPeColors.surfaceIconNegative, size: 18),
                const SizedBox(width: BoltPeSpacing.xs),
                Expanded(child: Text('If amount was debited, it will be refunded within 3–5 business days.',
                    style: BoltPeTypography.bodySm.copyWith(
                        color: BoltPeColors.surfaceTextNegative))),
              ]),
            ),
            const Spacer(),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Go Home'),
                ),
              ),
              const SizedBox(width: BoltPeSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Retry Payment'),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN 9 — Booking Confirmed
// ═══════════════════════════════════════════════════════════════════════════════
class BookingConfirmedScreen extends StatefulWidget {
  final int totalFare;
  const BookingConfirmedScreen({super.key, required this.totalFare});
  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen>
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
  void dispose() { _scale.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pnr = 'BP${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    return Scaffold(
      backgroundColor: BoltPeColors.surfaceBgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BoltPeSpacing.pageX),
          child: Column(children: [
            const SizedBox(height: BoltPeSpacing.xxl),
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 96, height: 96,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: BoltPeColors.cardBgPositive),
                child: const Icon(Icons.check_rounded,
                    color: BoltPeColors.surfaceIconPositive, size: 52),
              ),
            ),
            const SizedBox(height: BoltPeSpacing.xl),
            Text('Booking Confirmed!',
                style: BoltPeTypography.headingLg.copyWith(
                    color: BoltPeColors.surfaceTextPrimary)),
            const SizedBox(height: BoltPeSpacing.xs),
            Text('Your ticket has been sent to your email',
                style: BoltPeTypography.bodyMd.copyWith(
                    color: BoltPeColors.surfaceTextSecondary)),
            const SizedBox(height: BoltPeSpacing.xxl),
            // PNR card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(BoltPeSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF0A3D62), Color(0xFF1E6EA6)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(BoltPeRadii.xxl),
              ),
              child: Column(children: [
                Text('PNR Number',
                    style: BoltPeTypography.bodySm.copyWith(
                        color: BoltPeColors.white.withValues(alpha: 0.6))),
                const SizedBox(height: BoltPeSpacing.xs),
                Text(pnr,
                    style: BoltPeTypography.display2xl.copyWith(
                        color: BoltPeColors.white, letterSpacing: 4)),
                const SizedBox(height: BoltPeSpacing.lg),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: BoltPeSpacing.lg),
                // QR code placeholder
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: BoltPeColors.white,
                    borderRadius: BorderRadius.circular(BoltPeRadii.md),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded,
                          size: 72, color: BoltPeColors.black),
                      Text('Scan at boarding',
                          style: BoltPeTypography.caption.copyWith(
                              color: BoltPeColors.surfaceTextSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: BoltPeSpacing.md),
                Text('₹${widget.totalFare} paid',
                    style: BoltPeTypography.labelLg.copyWith(
                        color: BoltPeColors.white.withValues(alpha: 0.8))),
              ]),
            ),
            const SizedBox(height: BoltPeSpacing.xxl),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download'),
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
              const SizedBox(width: BoltPeSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share'),
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
            ]),
            const SizedBox(height: BoltPeSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('Go Home'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EDGE CASE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _NoBusesState extends StatelessWidget {
  final String from, to;
  final DateTime date;
  const _NoBusesState({required this.from, required this.to, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BoltPeSpacing.pageX),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: BoltPeColors.surfaceBgTertiary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_outlined,
                size: 40, color: BoltPeColors.surfaceTextTertiary),
          ),
          const SizedBox(height: BoltPeSpacing.xl),
          Text('No buses found',
              style: BoltPeTypography.headingMd.copyWith(
                  color: BoltPeColors.surfaceTextPrimary)),
          const SizedBox(height: BoltPeSpacing.xs),
          Text('No buses available for $from → $to\non ${_formatDate(date)}',
              style: BoltPeTypography.bodyMd.copyWith(
                  color: BoltPeColors.surfaceTextSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: BoltPeSpacing.xl),
          Text('Try nearby dates',
              style: BoltPeTypography.labelLg.copyWith(
                  color: BoltPeColors.surfaceTextSecondary)),
          const SizedBox(height: BoltPeSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (i) {
                final d = date.add(Duration(days: i + 1));
                return GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => BusResultsScreen(from: from, to: to, date: d, passengers: 1),
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(right: BoltPeSpacing.xs),
                    padding: const EdgeInsets.symmetric(
                        horizontal: BoltPeSpacing.md, vertical: BoltPeSpacing.xs),
                    decoration: BoxDecoration(
                      color: BoltPeColors.primary50,
                      borderRadius: BorderRadius.circular(BoltPeRadii.full),
                      border: Border.all(color: BoltPeColors.primary500),
                    ),
                    child: Text(_formatDate(d),
                        style: BoltPeTypography.labelMd.copyWith(
                            color: BoltPeColors.primary500)),
                  ),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}

class _NetworkErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _NetworkErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BoltPeSpacing.pageX),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(
                color: BoltPeColors.cardBgNegative, shape: BoxShape.circle),
            child: const Icon(Icons.wifi_off_rounded,
                size: 40, color: BoltPeColors.surfaceIconNegative),
          ),
          const SizedBox(height: BoltPeSpacing.xl),
          Text('No Internet Connection',
              style: BoltPeTypography.headingMd.copyWith(
                  color: BoltPeColors.surfaceTextPrimary)),
          const SizedBox(height: BoltPeSpacing.xs),
          Text('Check your connection and try again',
              style: BoltPeTypography.bodyMd.copyWith(
                  color: BoltPeColors.surfaceTextSecondary)),
          const SizedBox(height: BoltPeSpacing.xxl),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED SMALL WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _BusResultCard extends StatelessWidget {
  final _BusRoute bus;
  final VoidCallback? onTap;
  const _BusResultCard({required this.bus, this.onTap});

  @override
  Widget build(BuildContext context) {
    final soldOut = bus.seats == 0;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: soldOut ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(BoltPeSpacing.md),
          decoration: BoxDecoration(
            color: BoltPeColors.cardBgDefault,
            borderRadius: BorderRadius.circular(BoltPeRadii.xl),
            border: Border.all(color: BoltPeColors.cardBorderDefault),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(bus.operator,
                  style: BoltPeTypography.labelLg.copyWith(
                      color: BoltPeColors.surfaceTextPrimary))),
              if (soldOut)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: BoltPeSpacing.xs, vertical: 2),
                  decoration: BoxDecoration(
                    color: BoltPeColors.cardBgNegative,
                    borderRadius: BorderRadius.circular(BoltPeRadii.xs),
                  ),
                  child: Text('Sold Out',
                      style: BoltPeTypography.labelSm.copyWith(
                          color: BoltPeColors.surfaceTextNegative)),
                )
              else ...[
                Text('⭐ ${bus.rating}',
                    style: BoltPeTypography.labelMd.copyWith(
                        color: BoltPeColors.surfaceTextSecondary)),
              ],
            ]),
            const SizedBox(height: BoltPeSpacing.sm),
            Row(children: [
              Text(bus.departure,
                  style: BoltPeTypography.headingMd.copyWith(
                      color: BoltPeColors.surfaceTextPrimary)),
              const SizedBox(width: BoltPeSpacing.sm),
              Expanded(child: Column(children: [
                Text(bus.duration,
                    style: BoltPeTypography.bodySm.copyWith(
                        color: BoltPeColors.surfaceTextTertiary)),
                Container(height: 1, color: BoltPeColors.surfaceBorderDefault),
              ])),
              const SizedBox(width: BoltPeSpacing.sm),
              Text(bus.arrival,
                  style: BoltPeTypography.headingMd.copyWith(
                      color: BoltPeColors.surfaceTextPrimary)),
            ]),
            const SizedBox(height: BoltPeSpacing.sm),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: BoltPeSpacing.xs, vertical: 2),
                decoration: BoxDecoration(
                  color: BoltPeColors.surfaceBgSecondary,
                  borderRadius: BorderRadius.circular(BoltPeRadii.xs),
                  border: Border.all(color: BoltPeColors.surfaceBorderDefault),
                ),
                child: Text(bus.type,
                    style: BoltPeTypography.labelSm.copyWith(
                        color: BoltPeColors.surfaceTextSecondary)),
              ),
              const Spacer(),
              if (!soldOut) ...[
                Text(
                  bus.seats <= 5 ? '${bus.seats} seats left!' : '${bus.seats} seats',
                  style: BoltPeTypography.labelMd.copyWith(
                    color: bus.seats <= 5
                        ? BoltPeColors.surfaceTextNegative
                        : BoltPeColors.surfaceTextSecondary,
                  ),
                ),
                const SizedBox(width: BoltPeSpacing.md),
              ],
              Text('₹${bus.price}',
                  style: BoltPeTypography.headingSm.copyWith(
                      color: BoltPeColors.primary500)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _CityPickerSheet extends StatefulWidget {
  const _CityPickerSheet();
  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  final _ctrl = TextEditingController();
  final _cities = ['Mumbai', 'Pune', 'Bangalore', 'Chennai', 'Hyderabad',
    'Delhi', 'Kolkata', 'Ahmedabad', 'Surat', 'Jaipur', 'Nagpur', 'Nashik'];
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _cities.where((c) =>
        c.toLowerCase().contains(_q.toLowerCase())).toList();
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: BoltPeColors.surfaceBgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(BoltPeRadii.xxl)),
      ),
      child: Column(children: [
        Container(
          width: 40, height: 4, margin: const EdgeInsets.only(top: BoltPeSpacing.sm),
          decoration: BoxDecoration(
            color: BoltPeColors.surfaceBorderDefault,
            borderRadius: BorderRadius.circular(BoltPeRadii.full),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(BoltPeSpacing.pageX),
          child: TextField(
            controller: _ctrl,
            autofocus: true,
            onChanged: (v) => setState(() => _q = v),
            decoration: const InputDecoration(
              hintText: 'Search city...',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.location_city_rounded,
                  color: BoltPeColors.surfaceIconDefault),
              title: Text(filtered[i],
                  style: BoltPeTypography.bodyMd.copyWith(
                      color: BoltPeColors.surfaceTextPrimary)),
              onTap: () => Navigator.pop(context, filtered[i]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _PassengerSheet extends StatefulWidget {
  final int count;
  final ValueChanged<int> onChanged;
  const _PassengerSheet({required this.count, required this.onChanged});
  @override
  State<_PassengerSheet> createState() => _PassengerSheetState();
}

class _PassengerSheetState extends State<_PassengerSheet> {
  late int _count;
  @override
  void initState() { super.initState(); _count = widget.count; }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BoltPeSpacing.pageX),
      decoration: const BoxDecoration(
        color: BoltPeColors.surfaceBgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(BoltPeRadii.xxl)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: BoltPeColors.surfaceBorderDefault,
            borderRadius: BorderRadius.circular(BoltPeRadii.full),
          ),
        ),
        const SizedBox(height: BoltPeSpacing.xl),
        Text('Number of Passengers',
            style: BoltPeTypography.headingSm.copyWith(
                color: BoltPeColors.surfaceTextPrimary)),
        const SizedBox(height: BoltPeSpacing.xl),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
            onTap: _count > 1 ? () => setState(() => _count--) : null,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _count > 1 ? BoltPeColors.primary50 : BoltPeColors.surfaceBgTertiary,
                shape: BoxShape.circle,
                border: Border.all(
                    color: _count > 1 ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderDefault),
              ),
              child: Icon(Icons.remove_rounded,
                  color: _count > 1 ? BoltPeColors.primary500 : BoltPeColors.surfaceTextDisabled),
            ),
          ),
          const SizedBox(width: BoltPeSpacing.xl),
          Text('$_count',
              style: BoltPeTypography.display2xl.copyWith(
                  color: BoltPeColors.surfaceTextPrimary)),
          const SizedBox(width: BoltPeSpacing.xl),
          GestureDetector(
            onTap: _count < 6 ? () => setState(() => _count++) : null,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _count < 6 ? BoltPeColors.primary50 : BoltPeColors.surfaceBgTertiary,
                shape: BoxShape.circle,
                border: Border.all(
                    color: _count < 6 ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderDefault),
              ),
              child: Icon(Icons.add_rounded,
                  color: _count < 6 ? BoltPeColors.primary500 : BoltPeColors.surfaceTextDisabled),
            ),
          ),
        ]),
        if (_count == 6) ...[
          const SizedBox(height: BoltPeSpacing.sm),
          Text('Maximum 6 passengers per booking',
              style: BoltPeTypography.bodySm.copyWith(
                  color: BoltPeColors.surfaceTextNegative)),
        ],
        const SizedBox(height: BoltPeSpacing.xxl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () { widget.onChanged(_count); Navigator.pop(context); },
            child: const Text('Confirm'),
          ),
        ),
        const SizedBox(height: BoltPeSpacing.md),
      ]),
    );
  }
}

class _StopList extends StatelessWidget {
  final List<_StopPoint> points;
  final int selectedIndex;
  final String accentLabel;
  final ValueChanged<int> onSelect;
  const _StopList({
    required this.points, required this.selectedIndex,
    required this.accentLabel, required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(BoltPeSpacing.pageX),
      itemCount: points.length,
      separatorBuilder: (_, __) => const SizedBox(height: BoltPeSpacing.xs),
      itemBuilder: (_, i) {
        final sel = selectedIndex == i;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: Container(
            padding: const EdgeInsets.all(BoltPeSpacing.md),
            decoration: BoxDecoration(
              color: sel ? BoltPeColors.surfaceBgSelected : BoltPeColors.cardBgDefault,
              borderRadius: BorderRadius.circular(BoltPeRadii.lg),
              border: Border.all(
                color: sel ? BoltPeColors.cardBorderSelected : BoltPeColors.cardBorderDefault,
                width: sel ? 1.5 : 1,
              ),
            ),
            child: Row(children: [
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sel ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderStrong,
                  border: Border.all(
                    color: sel ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderDefault,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(width: BoltPeSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(points[i].name,
                    style: BoltPeTypography.labelLg.copyWith(
                        color: BoltPeColors.surfaceTextPrimary)),
                Text(points[i].landmark,
                    style: BoltPeTypography.bodySm.copyWith(
                        color: BoltPeColors.surfaceTextSecondary)),
              ])),
              Text(points[i].time,
                  style: BoltPeTypography.labelLg.copyWith(
                      color: sel ? BoltPeColors.primary500 : BoltPeColors.surfaceTextSecondary)),
            ]),
          ),
        );
      },
    );
  }
}

class _SeatWidget extends StatelessWidget {
  final String id;
  final _SeatStatus status;
  final VoidCallback onTap;
  const _SeatWidget({required this.id, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg, border;
    switch (status) {
      case _SeatStatus.available:
        bg = BoltPeColors.surfaceBgSecondary; border = BoltPeColors.surfaceBorderDefault;
        break;
      case _SeatStatus.selected:
        bg = BoltPeColors.primary500; border = BoltPeColors.primary500;
        break;
      case _SeatStatus.booked:
        bg = BoltPeColors.surfaceBgTertiary; border = BoltPeColors.surfaceBorderDefault;
        break;
      case _SeatStatus.ladies:
        bg = const Color(0xFFFCE4EC); border = const Color(0xFFE91E63);
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BoltPeRadii.xs),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            id.substring(id.length - 1),
            style: BoltPeTypography.labelSm.copyWith(
              color: status == _SeatStatus.selected
                  ? BoltPeColors.white
                  : status == _SeatStatus.booked
                      ? BoltPeColors.surfaceTextDisabled
                      : BoltPeColors.surfaceTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SeatLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _LegendItem(color: BoltPeColors.surfaceBgSecondary,
            border: BoltPeColors.surfaceBorderDefault, label: 'Available'),
        _LegendItem(color: BoltPeColors.primary500,
            border: BoltPeColors.primary500, label: 'Selected'),
        _LegendItem(color: BoltPeColors.surfaceBgTertiary,
            border: BoltPeColors.surfaceBorderDefault, label: 'Booked'),
        _LegendItem(color: const Color(0xFFFCE4EC),
            border: const Color(0xFFE91E63), label: 'Ladies'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color, border;
  final String label;
  const _LegendItem({required this.color, required this.border, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 16, height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: border),
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: BoltPeTypography.caption.copyWith(
          color: BoltPeColors.surfaceTextSecondary)),
    ]);
  }
}

class _DeckToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _DeckToggle({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: BoltPeSpacing.lg, vertical: BoltPeSpacing.xs),
        decoration: BoxDecoration(
          color: active ? BoltPeColors.primary500 : BoltPeColors.surfaceBgSecondary,
          borderRadius: BorderRadius.circular(BoltPeRadii.full),
          border: Border.all(
              color: active ? BoltPeColors.primary500 : BoltPeColors.surfaceBorderDefault),
        ),
        child: Text(label, style: BoltPeTypography.labelMd.copyWith(
            color: active ? BoltPeColors.white : BoltPeColors.surfaceTextSecondary)),
      ),
    );
  }
}

class _SummaryStop extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, name, time;
  const _SummaryStop({
    required this.icon, required this.color,
    required this.label, required this.name, required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: BoltPeSpacing.xs),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: BoltPeTypography.caption.copyWith(
            color: BoltPeColors.surfaceTextTertiary)),
        Text(name, style: BoltPeTypography.labelMd.copyWith(
            color: BoltPeColors.surfaceTextPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(time, style: BoltPeTypography.bodySm.copyWith(
            color: BoltPeColors.surfaceTextSecondary)),
      ])),
    ]);
  }
}

class _CityField extends StatelessWidget {
  final String label, hint;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  const _CityField({
    required this.label, required this.hint, required this.value,
    required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(BoltPeSpacing.lg),
        child: Row(children: [
          Icon(icon, color: BoltPeColors.primary500, size: 20),
          const SizedBox(width: BoltPeSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: BoltPeTypography.caption.copyWith(
                color: BoltPeColors.surfaceTextTertiary)),
            Text(
              value.isEmpty ? hint : value,
              style: value.isEmpty
                  ? BoltPeTypography.bodyMd.copyWith(color: BoltPeColors.inputFgPlaceholder)
                  : BoltPeTypography.headingSm.copyWith(color: BoltPeColors.surfaceTextPrimary),
            ),
          ])),
          if (value.isNotEmpty)
            const Icon(Icons.check_circle_rounded,
                color: BoltPeColors.inputBorderPositive, size: 18),
        ]),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback onTap;
  const _InfoCard({
    required this.label, required this.value,
    required this.icon, required this.onTap,
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
        child: Row(children: [
          Icon(icon, color: BoltPeColors.primary500, size: 18),
          const SizedBox(width: BoltPeSpacing.xs),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: BoltPeTypography.caption.copyWith(
                color: BoltPeColors.surfaceTextTertiary)),
            Text(value, style: BoltPeTypography.labelMd.copyWith(
                color: BoltPeColors.surfaceTextPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String time, label;
  final bool alignRight;
  const _TimeBlock({required this.time, required this.label, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time, style: BoltPeTypography.headingLg.copyWith(color: BoltPeColors.white)),
        Text(label, style: BoltPeTypography.bodySm.copyWith(
            color: BoltPeColors.white.withValues(alpha: 0.6)),
            maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _DetailStat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: BoltPeTypography.labelLg.copyWith(
          color: valueColor ?? BoltPeColors.surfaceTextPrimary)),
      Text(label, style: BoltPeTypography.caption.copyWith(
          color: BoltPeColors.surfaceTextSecondary)),
    ]);
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  const _AmenityChip({required this.label});

  static IconData _icon(String label) {
    switch (label) {
      case 'WiFi': return Icons.wifi_rounded;
      case 'Charging': return Icons.electrical_services_rounded;
      case 'Water': return Icons.water_drop_rounded;
      case 'Blanket': return Icons.bed_rounded;
      default: return Icons.check_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: BoltPeSpacing.sm, vertical: BoltPeSpacing.xxs),
      decoration: BoxDecoration(
        color: BoltPeColors.surfaceBgSecondary,
        borderRadius: BorderRadius.circular(BoltPeRadii.full),
        border: Border.all(color: BoltPeColors.surfaceBorderDefault),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(_icon(label), size: 14, color: BoltPeColors.surfaceIconDefault),
        const SizedBox(width: 4),
        Text(label, style: BoltPeTypography.labelSm.copyWith(
            color: BoltPeColors.surfaceTextSecondary)),
      ]),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  const _InlineError(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.error_outline_rounded,
          size: 14, color: BoltPeColors.surfaceIconNegative),
      const SizedBox(width: 4),
      Text(message, style: BoltPeTypography.bodySm.copyWith(
          color: BoltPeColors.surfaceTextNegative)),
    ]);
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BoltPeSpacing.md),
      decoration: BoxDecoration(
        color: BoltPeColors.cardBgDefault,
        borderRadius: BorderRadius.circular(BoltPeRadii.xl),
        border: Border.all(color: BoltPeColors.cardBorderDefault),
      ),
      child: Column(children: [
        Row(children: [
          _Shimmer(width: 120, height: 14),
          const Spacer(),
          _Shimmer(width: 40, height: 14),
        ]),
        const SizedBox(height: BoltPeSpacing.sm),
        Row(children: [
          _Shimmer(width: 60, height: 28),
          const Spacer(),
          _Shimmer(width: 60, height: 28),
        ]),
        const SizedBox(height: BoltPeSpacing.sm),
        Row(children: [
          _Shimmer(width: 80, height: 22),
          const Spacer(),
          _Shimmer(width: 60, height: 22),
        ]),
      ]),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width, height;
  const _Shimmer({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: BoltPeColors.surfaceBgSkeleton,
        borderRadius: BorderRadius.circular(BoltPeRadii.xs),
      ),
    );
  }
}

Widget _vDivider() => Container(
      width: 1, height: 32, color: BoltPeColors.surfaceBorderDefault);

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: BoltPeTypography.bodyMd.copyWith(
          color: BoltPeColors.surfaceTextSecondary)),
      Text(value, style: BoltPeTypography.labelLg.copyWith(
          color: BoltPeColors.surfaceTextPrimary)),
    ]);
  }
}

// ─── Shared AppBar + CTA ──────────────────────────────────────────────────────
PreferredSizeWidget _BoltPeAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    backgroundColor: BoltPeColors.surfaceBgPrimary,
    foregroundColor: BoltPeColors.surfaceTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: BoltPeTypography.headingSm.copyWith(
        color: BoltPeColors.surfaceTextPrimary),
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
      child: Container(color: BoltPeColors.surfaceBorderDefault, height: 1),
    ),
  );
}

class _BottomCTA extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _BottomCTA({required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          BoltPeSpacing.pageX, BoltPeSpacing.md, BoltPeSpacing.pageX, BoltPeSpacing.xl),
      decoration: const BoxDecoration(
        color: BoltPeColors.surfaceBgPrimary,
        border: Border(top: BorderSide(color: BoltPeColors.surfaceBorderDefault)),
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

// ─── Data Models ──────────────────────────────────────────────────────────────
class _BusRoute {
  final String id, operator, type, departure, arrival, duration;
  final double rating;
  final int price, seats;
  final List<String> amenities;
  const _BusRoute({
    required this.id, required this.operator, required this.type,
    required this.departure, required this.arrival, required this.duration,
    required this.rating, required this.price, required this.seats,
    required this.amenities,
  });
}

class _StopPoint {
  final String name, landmark, time;
  const _StopPoint(this.name, this.landmark, this.time);
}

enum _SeatStatus { available, booked, selected, ladies }

String _formatDate(DateTime d) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
}
