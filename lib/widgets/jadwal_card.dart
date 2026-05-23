import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class JadwalCard extends StatefulWidget {
  final Map<String, dynamic> jadwal;
  const JadwalCard({super.key, required this.jadwal});
  @override
  State<JadwalCard> createState() => _JadwalCardState();
}

class _JadwalCardState extends State<JadwalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final j = widget.jadwal;
    final jenis = j['jenis'] ?? 'Damri';
    final times = (j['keberangkatan_list'] as List?)?.cast<String>() ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 3, offset: const Offset(0, 1))]),
      child: Column(children: [
        // Top Row
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(gradient: AppTheme.numberGradient(jenis), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(j['nomor'] ?? '', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(j['rute'] ?? '', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.badgeBg(jenis), borderRadius: BorderRadius.circular(6)),
                  child: Text(jenis, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.badgeText(jenis))),
                ),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Text('🕐 ${j['jam_mulai']} - ${j['jam_selesai']}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(width: 14),
                Text('🚌 Interval ${j['interval_menit']} menit', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
              ]),
            ])),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted)),
            ),
          ]),
        ),
        // Expandable Detail
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: times.isNotEmpty ? Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 14),
              Text('Jadwal Keberangkatan Awal:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ...times.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                  child: Text(t, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: AppTheme.borderLight, borderRadius: BorderRadius.circular(8)),
                  child: Text('... dan seterusnya', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                ),
              ]),
            ]),
          ) : const SizedBox.shrink(),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ]),
    );
  }
}
