import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  String _formatRp(dynamic v) => 'Rp ${NumberFormat('#,###', 'id_ID').format(int.tryParse(v.toString()) ?? 0)}';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 10),
              // Receipt Card
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 60, offset: const Offset(0, 20))]),
                child: Column(children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('🚌', style: TextStyle(fontSize: 18)))),
                        const SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('TransBdg', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                          Text('E-Ticket', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                        ]),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(50)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Text('✅', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(data['status'] ?? 'Berhasil', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.greenDark)),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  // Booking Code
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF93C5FD), style: BorderStyle.solid, width: 1.5)),
                    child: Column(children: [
                      Text('KODE BOOKING', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 1)),
                      const SizedBox(height: 6),
                      Text(data['kode_booking'] ?? 'TBD-XXXXXXXX', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.primary, letterSpacing: 3)),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  // Dashed divider
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _dashedLine()),
                  const SizedBox(height: 16),
                  // Route
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      _routePoint(AppTheme.primary, 'Asal', data['asal'] ?? ''),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
                          decoration: const BoxDecoration(border: Border(left: BorderSide(color: AppTheme.borderMedium, width: 2, style: BorderStyle.solid))),
                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.borderLight, borderRadius: BorderRadius.circular(6)),
                            child: Text('🕐 ${data['durasi'] ?? ''}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary))),
                        ),
                      ),
                      _routePoint(AppTheme.green, 'Tujuan', data['tujuan'] ?? ''),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _dashedLine()),
                  const SizedBox(height: 16),
                  // Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      _detailRow('Kendaraan', data['jenis_kendaraan'] ?? ''),
                      _detailRow('Tanggal', data['tanggal'] ?? ''),
                      _detailRow('Jam', data['jam_keberangkatan'] ?? ''),
                      _detailRow('Penumpang', '${data['jumlah_penumpang'] ?? 1} orang'),
                      _detailRow('Pembayaran', 'Kartu Debit'),
                      _detailRow('Bank', data['nama_bank'] ?? ''),
                      _detailRow('No. Kartu', '**** **** **** ${data['no_kartu_last4'] ?? '****'}'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  // Total
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total Pembayaran', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
                      Text(_formatRp(data['total_harga'] ?? 0), style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  // Notice
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFEFCE8)]), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFDE68A))),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('⚠️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Tunjukkan kode booking ini kepada petugas di halte keberangkatan. Tiket berlaku untuk tanggal dan jam yang dipilih.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF92400E), height: 1.5))),
                    ]),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                  icon: const Text('🏠', style: TextStyle(fontSize: 16)),
                  label: Text('Beranda', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
                const SizedBox(width: 12),
                Expanded(child: Container(
                  decoration: BoxDecoration(gradient: AppTheme.greenGradient, borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/booking'),
                    icon: const Text('🎫', style: TextStyle(fontSize: 16)),
                    label: Text('Pesan Lagi', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                )),
              ]),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _routePoint(Color color, String label, String name) {
    return Row(children: [
      Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 0, spreadRadius: 4)])),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
        Text(name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
    ]);
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
        Flexible(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), textAlign: TextAlign.right)),
      ]),
    );
  }

  Widget _dashedLine() {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(children: List.generate((constraints.maxWidth / 8).floor(), (i) => Container(width: 4, height: 1, margin: const EdgeInsets.symmetric(horizontal: 2), color: AppTheme.borderMedium)));
    });
  }
}
