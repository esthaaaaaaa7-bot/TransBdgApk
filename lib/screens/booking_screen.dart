import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<dynamic> _ruteList = [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic>? _user;

  String? _selectedKendaraan;
  int? _selectedRuteId;
  DateTime _selectedDate = DateTime.now();
  String? _selectedJam;
  int _jumlahPenumpang = 1;
  final _bankC = TextEditingController();
  final _cardC = TextEditingController();
  final _nameC = TextEditingController();
  final _expC = TextEditingController();

  final Map<String, int> _hargaMap = {
    'Trans Metro Bandung': 3500,
    'Damri': 4000,
    'Angkot': 3000,
    'Kereta Lokal': 5000,
  };

  final List<String> _jamList = ['05:00','05:30','06:00','06:30','07:00','07:30','08:00','08:30','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([ApiService.getRute(), ApiService.getUser()]);
    setState(() { _ruteList = results[0] as List; _user = results[1] as Map<String, dynamic>?; _loading = false; });
  }

  int get _hargaSatuan => _hargaMap[_selectedKendaraan] ?? 0;
  int get _totalHarga => _hargaSatuan * _jumlahPenumpang;
  String _formatRp(int v) => 'Rp ${NumberFormat('#,###', 'id_ID').format(v)}';

  Future<void> _submit() async {
    if (_selectedKendaraan == null || _selectedRuteId == null || _selectedJam == null) {
      setState(() => _error = 'Lengkapi semua data perjalanan');
      return;
    }
    if (_bankC.text.isEmpty || _cardC.text.isEmpty || _nameC.text.isEmpty || _expC.text.isEmpty) {
      setState(() => _error = 'Lengkapi semua data pembayaran');
      return;
    }
    setState(() { _submitting = true; _error = null; });

    try {
      final res = await ApiService.pesanTiket({
        'user_id': _user?['id'],
        'rute_id': _selectedRuteId,
        'jenis_kendaraan': _selectedKendaraan,
        'tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'jam_keberangkatan': _selectedJam,
        'jumlah_penumpang': _jumlahPenumpang,
        'nama_bank': _bankC.text,
        'no_kartu_last4': _cardC.text.replaceAll(' ', '').substring(_cardC.text.replaceAll(' ', '').length - 4 > 0 ? _cardC.text.replaceAll(' ', '').length - 4 : 0),
      });

      if (res['success'] == true && mounted) {
        Navigator.pushReplacementNamed(context, '/receipt', arguments: res['data']);
      } else {
        setState(() => _error = res['message'] ?? 'Gagal memesan');
      }
    } catch (e) {
      setState(() => _error = 'Gagal terhubung ke server');
    }
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text('Pesan Tiket', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Halo ${_user?['nama'] ?? 'User'}, pilih rute dan jadwal keberangkatanmu!', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: 20),

        if (_error != null) Container(
          padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECACA))),
          child: Row(children: [const Text('⚠️'), const SizedBox(width: 10), Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF991B1B))))]),
        ),

        // STEP 1
        _section('1', 'Informasi Perjalanan', 'Pilih rute, tanggal, dan jam', [
          _dropdown('🚐', 'Pilih Kendaraan', _hargaMap.keys.toList(), _selectedKendaraan, (v) => setState(() { _selectedKendaraan = v; _selectedRuteId = null; })),
          const SizedBox(height: 14),
          _dropdown('🚌', 'Pilih Rute', _ruteList.map((r) => '${r['asal']} → ${r['tujuan']}').toList(), _selectedRuteId != null ? _ruteList.firstWhere((r) => r['id'].toString() == _selectedRuteId.toString(), orElse: () => null) != null ? '${_ruteList.firstWhere((r) => r['id'].toString() == _selectedRuteId.toString())['asal']} → ${_ruteList.firstWhere((r) => r['id'].toString() == _selectedRuteId.toString())['tujuan']}' : null : null, (v) {
            final rute = _ruteList.firstWhere((r) => '${r['asal']} → ${r['tujuan']}' == v, orElse: () => null);
            if (rute != null) setState(() => _selectedRuteId = int.parse(rute['id'].toString()));
          }),
          const SizedBox(height: 14),
          // Date picker
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderMedium, width: 1.5)),
              child: Row(children: [
                const Text('📅', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate), style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary)),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          _dropdown('🕐', 'Pilih Jam', _jamList, _selectedJam, (v) => setState(() => _selectedJam = v)),
          const SizedBox(height: 14),
          // Jumlah penumpang
          Row(children: [
            const Text('👥', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Text('Jumlah Penumpang:', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary)),
            const Spacer(),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderMedium)),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: _jumlahPenumpang > 1 ? () => setState(() => _jumlahPenumpang--) : null),
                Text('$_jumlahPenumpang', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                IconButton(icon: const Icon(Icons.add, size: 18), onPressed: _jumlahPenumpang < 10 ? () => setState(() => _jumlahPenumpang++) : null),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          // Price summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFBAE6FD))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Harga tiket', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                Text('${_formatRp(_hargaSatuan)} × $_jumlahPenumpang orang', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
              ]),
              const SizedBox(height: 10),
              Container(height: 1.5, color: const Color(0xFF93C5FD)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total Pembayaran', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                Text(_formatRp(_totalHarga), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 20),

        // STEP 2
        _section('2', 'Pembayaran Kartu Debit', 'Masukkan informasi kartu debit', [
          _textField('🏦', 'Nama Bank (cth: BCA)', _bankC),
          const SizedBox(height: 14),
          _textField('💳', 'Nomor Kartu', _cardC, keyboard: TextInputType.number),
          const SizedBox(height: 14),
          _textField('👤', 'Nama Pemegang Kartu', _nameC),
          const SizedBox(height: 14),
          _textField('📅', 'MM/YY', _expC),
        ]),
        const SizedBox(height: 24),

        // Submit
        Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 4))]),
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 18)),
            child: _submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔒', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text('Bayar & Pesan Tiket', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
          ),
        ),
        const SizedBox(height: 40),
      ]),
    );
  }

  Widget _section(String step, String title, String subtitle, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4))], border: Border.all(color: AppTheme.borderLight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(step, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)))),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
          ]),
        ]),
        const SizedBox(height: 20),
        const Divider(height: 1, color: AppTheme.borderLight),
        const SizedBox(height: 20),
        ...children,
      ]),
    );
  }

  Widget _dropdown(String icon, String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderMedium, width: 1.5)),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ))),
      ]),
    );
  }

  Widget _textField(String icon, String hint, TextEditingController controller, {TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(prefixIcon: Padding(padding: const EdgeInsets.only(left: 14, right: 10), child: Text(icon, style: const TextStyle(fontSize: 16))), prefixIconConstraints: const BoxConstraints(minWidth: 44), hintText: hint),
    );
  }
}
