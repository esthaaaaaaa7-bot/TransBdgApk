import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/api_service.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/tarif_card.dart';
import '../widgets/rute_card.dart';
import '../widgets/tip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _user;
  Map<String, dynamic> _pengaturan = {};
  List<dynamic> _jadwal = [], _tarif = [], _rute = [], _tips = [];
  bool _loading = true;
  String _jadwalFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ApiService.getUser(),
        ApiService.getPengaturan(),
        ApiService.getJadwal(),
        ApiService.getTarif(),
        ApiService.getRute(),
        ApiService.getTips(),
      ]);
      setState(() {
        _user = results[0] as Map<String, dynamic>?;
        _pengaturan = results[1] as Map<String, dynamic>;
        _jadwal = results[2] as List;
        _tarif = results[3] as List;
        _rute = results[4] as List;
        _tips = results[5] as List;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _logout() async {
    await ApiService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : IndexedStack(index: _currentIndex, children: [
            _buildBeranda(),
            _buildJadwal(),
            _buildTarif(),
            _buildRute(),
            _buildTips(),
          ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule_rounded), label: 'Jadwal'),
            BottomNavigationBarItem(icon: Icon(Icons.payments_rounded), label: 'Tarif'),
            BottomNavigationBarItem(icon: Icon(Icons.route_rounded), label: 'Rute'),
            BottomNavigationBarItem(icon: Icon(Icons.tips_and_updates_rounded), label: 'Tips'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/booking'),
        backgroundColor: AppTheme.primary,
        icon: const Text('🎫', style: TextStyle(fontSize: 18)),
        label: Text('Pesan Tiket', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  // ==================== BERANDA ====================
  Widget _buildBeranda() {
    return CustomScrollView(slivers: [
      // Hero AppBar
      SliverAppBar(
        expandedHeight: 420,
        pinned: true,
        backgroundColor: AppTheme.primaryDark,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Top Bar
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.2))), child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 20)),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('TransBdg', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text('Info Transportasi Lokal', style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
                      ]),
                    ]),
                    PopupMenuButton<String>(
                      onSelected: (v) { if (v == 'logout') _logout(); },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'user', enabled: false, child: Text('Halo, ${_user?['nama'] ?? 'User'}', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                        const PopupMenuItem(value: 'logout', child: Text('🚪 Logout')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                        child: Row(children: [
                          CircleAvatar(radius: 12, backgroundColor: Colors.white.withValues(alpha: 0.2), child: Text((_user?['nama'] ?? 'U')[0].toUpperCase(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                          const SizedBox(width: 6),
                          Text(_user?['nama']?.split(' ')[0] ?? 'User', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white.withValues(alpha: 0.7)),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.white.withValues(alpha: 0.15))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('Kota Bandung, Jawa Barat', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Text('Info Transportasi', style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white, height: 1.15)),
                  Text('Lokal Bandung', style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.accentBlue, height: 1.15)),
                  const SizedBox(height: 14),
                  Text('Panduan lengkap jadwal, tarif, dan rute transportasi umum di Kota Bandung.', style: GoogleFonts.inter(fontSize: 14, color: Colors.white70, height: 1.7)),
                  const SizedBox(height: 20),
                  // Stats Grid
                  Row(children: [
                    _statCard('🚌', _pengaturan['jumlah_armada'] ?? '240+', 'Armada'),
                    const SizedBox(width: 10),
                    _statCard('📍', _pengaturan['jumlah_halte'] ?? '180+', 'Halte'),
                    const SizedBox(width: 10),
                    _statCard('🕐', _pengaturan['jam_operasional'] ?? '17 Jam', 'Operasional'),
                    const SizedBox(width: 10),
                    _statCard('🚏', _pengaturan['jumlah_rute'] ?? '42 Rute', 'Rute'),
                  ]),
                ]),
              ),
            ),
          ),
        ),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.white, size: 20))],
      ),
      // Quick sections preview
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionHeader('Jadwal Harian', 'Jadwal Bus Bandung', () => setState(() => _currentIndex = 1)),
          const SizedBox(height: 16),
          ...(_jadwal.take(3).map((j) => JadwalCard(jadwal: j))),
          const SizedBox(height: 32),
          _sectionHeader('Rute Populer', 'Rute Yang Sering Dipakai', () => setState(() => _currentIndex = 3)),
          const SizedBox(height: 16),
          ...(_rute.take(2).map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: RuteCard(rute: r)))),
          const SizedBox(height: 80),
        ]),
      )),
    ]);
  }

  Widget _statCard(String icon, String value, String label) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
      child: Column(children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600)),
      ]),
    ));
  }

  Widget _sectionHeader(String badge, String title, VoidCallback onSeeAll) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(50)),
          child: Text(badge, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0369A1)))),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      ]),
      TextButton(onPressed: onSeeAll, child: Text('Lihat Semua →', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary))),
    ]);
  }

  // ==================== JADWAL ====================
  Widget _buildJadwal() {
    final filtered = _jadwalFilter == 'all' ? _jadwal : _jadwal.where((j) {
      final jenis = (j['jenis'] ?? '').toString().toLowerCase().replaceAll(' ', '');
      return jenis == _jadwalFilter;
    }).toList();

    return SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      _pageTitle('Jadwal Harian', 'Jadwal Bus Bandung', 'Informasi jadwal keberangkatan bus kota Bandung.'),
      const SizedBox(height: 20),
      // Filter tabs
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        _filterChip('Semua', 'all'),
        _filterChip('Damri', 'damri'),
        _filterChip('Angkot', 'angkot'),
        _filterChip('Trans Metro', 'transmetro'),
      ])),
      const SizedBox(height: 20),
      ...filtered.map((j) => JadwalCard(jadwal: j)),
      const SizedBox(height: 80),
    ]));
  }

  Widget _filterChip(String label, String value) {
    final active = _jadwalFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _jadwalFilter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: active ? AppTheme.primary : AppTheme.borderMedium),
          ),
          child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppTheme.textSecondary)),
        ),
      ),
    );
  }

  // ==================== TARIF ====================
  Widget _buildTarif() {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      _pageTitle('Tarif Terbaru 2026', 'Tarif Transportasi', 'Informasi tarif terkini transportasi umum Bandung.'),
      const SizedBox(height: 20),
      ..._tarif.map((t) => Padding(padding: const EdgeInsets.only(bottom: 16), child: TarifCard(tarif: t))),
      const SizedBox(height: 80),
    ]));
  }

  // ==================== RUTE ====================
  Widget _buildRute() {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      _pageTitle('Rute Populer', 'Rute Yang Sering Dipakai', 'Rute-rute yang paling banyak digunakan warga Bandung.'),
      const SizedBox(height: 20),
      ..._rute.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: RuteCard(rute: r))),
      const SizedBox(height: 80),
    ]));
  }

  // ==================== TIPS ====================
  Widget _buildTips() {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      _pageTitle('Panduan Perjalanan', 'Tips Naik Transportasi Umum', 'Panduan praktis agar perjalananmu lebih nyaman dan efisien.'),
      const SizedBox(height: 20),
      ..._tips.map((t) => Padding(padding: const EdgeInsets.only(bottom: 16), child: TipCard(tip: t))),
      const SizedBox(height: 80),
    ]));
  }

  Widget _pageTitle(String badge, String title, String desc) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(50)),
        child: Text(badge, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0369A1)))),
      const SizedBox(height: 10),
      Text(title, style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 6),
      Text(desc, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
    ]);
  }
}
