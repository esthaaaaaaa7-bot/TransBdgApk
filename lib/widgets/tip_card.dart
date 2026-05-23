import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class TipCard extends StatelessWidget {
  final Map<String, dynamic> tip;
  const TipCard({super.key, required this.tip});

  LinearGradient _iconGrad(String w) {
    switch (w) { case 'blue': return AppTheme.primaryGradient; case 'green': return AppTheme.greenGradient; case 'mint': return const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF14B8A6)]); case 'pink': return const LinearGradient(colors: [Color(0xFFE11D48), Color(0xFFF43F5E)]); case 'yellow': return const LinearGradient(colors: [Color(0xFFD97706), Color(0xFFF59E0B)]); case 'purple': return const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFA855F7)]); default: return AppTheme.primaryGradient; }
  }
  Color _catBg(String w) {
    switch (w) { case 'blue': return const Color(0xFFDBEAFE); case 'green': return const Color(0xFFD1FAE5); case 'mint': return const Color(0xFFCCFBF1); case 'pink': return const Color(0xFFFEE2E2); case 'yellow': return const Color(0xFFFEF3C7); case 'purple': return const Color(0xFFF3E8FF); default: return const Color(0xFFDBEAFE); }
  }
  Color _catText(String w) {
    switch (w) { case 'blue': return const Color(0xFF1D4ED8); case 'green': return AppTheme.greenDark; case 'mint': return const Color(0xFF0D9488); case 'pink': return AppTheme.red; case 'yellow': return const Color(0xFF92400E); case 'purple': return const Color(0xFF7C3AED); default: return AppTheme.primary; }
  }
  List<Color> _tintColors(String w) {
    switch (w) { case 'blue': return [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)]; case 'green': return [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)]; case 'mint': return [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1)]; case 'pink': return [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)]; case 'yellow': return [const Color(0xFFFEFCE8), const Color(0xFFFEF9C3)]; case 'purple': return [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)]; default: return [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)]; }
  }

  @override
  Widget build(BuildContext context) {
    final warna = tip['warna'] ?? 'blue';
    final tints = _tintColors(warna);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: tints), borderRadius: BorderRadius.circular(18), border: Border.all(color: tints.last)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(gradient: _iconGrad(warna), borderRadius: BorderRadius.circular(14)),
          child: Center(child: Text(tip['icon'] ?? '💡', style: const TextStyle(fontSize: 20)))),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: _catBg(warna), borderRadius: BorderRadius.circular(6)),
          child: Text(tip['kategori'] ?? '', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _catText(warna)))),
        const SizedBox(height: 10),
        Text(tip['judul'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        Text(tip['deskripsi'] ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.6)),
      ]),
    );
  }
}
