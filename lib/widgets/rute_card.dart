import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class RuteCard extends StatefulWidget {
  final Map<String, dynamic> rute;
  const RuteCard({super.key, required this.rute});
  @override
  State<RuteCard> createState() => _RuteCardState();
}

class _RuteCardState extends State<RuteCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.rute;
    final stops = (r['pemberhentian_list'] as List?)?.cast<String>() ?? [];
    final badges = (r['badges_list'] as List?)?.cast<String>() ?? [];
    final pop = int.tryParse(r['popularitas'].toString()) ?? 50;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Expanded(child: Row(children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(child: Text(r['asal'] ?? '', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('→', style: TextStyle(color: AppTheme.textMuted, fontSize: 14))),
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(child: Text(r['tujuan'] ?? '', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
          ])),
          const SizedBox(width: 8),
          Text('🕐 ${r['durasi']}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
        ]),
        const SizedBox(height: 6),
        Text('📍 ${r['via']}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
        const SizedBox(height: 12),
        // Progress bar
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: pop / 100, minHeight: 6, backgroundColor: AppTheme.borderMedium, valueColor: const AlwaysStoppedAnimation(AppTheme.primary)))),
          const SizedBox(width: 10),
          Text('$pop%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ]),
        const SizedBox(height: 12),
        // Badges
        Wrap(spacing: 8, runSpacing: 6, children: badges.map((b) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.borderMedium), color: Colors.white),
          child: Text(b, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        )).toList()),
        const SizedBox(height: 10),
        // Toggle
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(children: [
            AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.textSecondary)),
            const SizedBox(width: 4),
            Text(_expanded ? 'Sembunyikan pemberhentian' : 'Lihat pemberhentian (${stops.length})', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
          ]),
        ),
        // Timeline
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: stops.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(children: [
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 16),
              SizedBox(
                height: 70,
                child: Row(children: List.generate(stops.length, (i) {
                  final isLast = i == stops.length - 1;
                  final isFirst = i == 0;
                  Color nodeColor = isFirst ? const Color(0xFF0EA5E9) : isLast ? AppTheme.green : const Color(0xFFCBD5E1);
                  return Expanded(child: Column(children: [
                    Row(children: [
                      if (i > 0) Expanded(child: Container(height: 2, color: AppTheme.borderMedium)),
                      Container(width: 28, height: 28, decoration: BoxDecoration(color: nodeColor, shape: BoxShape.circle),
                        child: Center(child: Text('${i + 1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
                      if (!isLast) Expanded(child: Container(height: 2, color: AppTheme.borderMedium)),
                    ]),
                    const SizedBox(height: 6),
                    Text(stops[i], style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]));
                })),
              ),
            ]),
          ) : const SizedBox.shrink(),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ]),
    );
  }
}
