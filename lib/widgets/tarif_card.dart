import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class TarifCard extends StatelessWidget {
  final Map<String, dynamic> tarif;
  const TarifCard({super.key, required this.tarif});

  Color _iconBg(String w) {
    switch (w) { case 'tmb': return const Color(0xFFE0F2FE); case 'damri': return const Color(0xFFDBEAFE); case 'angkot': return const Color(0xFFFEF3C7); case 'kereta': return const Color(0xFFFEE2E2); default: return const Color(0xFFE0F2FE); }
  }
  Color _priceBg(String c) {
    switch (c) { case 'green': return const Color(0xFFD1FAE5); case 'blue': return const Color(0xFFDBEAFE); case 'orange': return const Color(0xFFFEF3C7); case 'red': return const Color(0xFFFEE2E2); default: return const Color(0xFFDBEAFE); }
  }
  Color _priceText(String c) {
    switch (c) { case 'green': return AppTheme.greenDark; case 'blue': return const Color(0xFF2563EB); case 'orange': return AppTheme.orange; case 'red': return AppTheme.red; default: return const Color(0xFF2563EB); }
  }
  Color _checkBg(String c) => _priceText(c);
  Color _subtitleColor(String w) {
    switch (w) { case 'tmb': return AppTheme.greenDark; case 'damri': return const Color(0xFF2563EB); case 'angkot': return AppTheme.orange; case 'kereta': return AppTheme.red; default: return AppTheme.primary; }
  }

  @override
  Widget build(BuildContext context) {
    final details = (tarif['details'] as List?) ?? [];
    final warna = tarif['warna'] ?? 'blue';
    final badgeColor = tarif['badge_color'] ?? 'blue';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: _iconBg(warna), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(tarif['icon'] ?? '🚌', style: const TextStyle(fontSize: 20)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tarif['nama'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 2),
            Text(tarif['subtitle'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: _subtitleColor(warna))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _priceBg(badgeColor), borderRadius: BorderRadius.circular(8)),
            child: Text(tarif['harga_badge'] ?? '', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _priceText(badgeColor))),
          ),
        ]),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppTheme.borderLight),
        const SizedBox(height: 12),
        // Detail rows
        ...details.map((d) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Container(width: 20, height: 20, decoration: BoxDecoration(color: _checkBg(badgeColor), shape: BoxShape.circle), child: const Center(child: Text('✓', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 10),
            Expanded(child: Text(d['kategori'] ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary))),
            Text(d['harga'] ?? '', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ]),
        )),
      ]),
    );
  }
}
