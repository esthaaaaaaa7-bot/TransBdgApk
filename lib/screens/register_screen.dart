import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _namaC = TextEditingController();
  final _emailC = TextEditingController();
  final _teleponC = TextEditingController();
  final _passC = TextEditingController();
  final _konfirmasiC = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (_namaC.text.isEmpty || _emailC.text.isEmpty || _passC.text.isEmpty || _konfirmasiC.text.isEmpty) {
      setState(() => _error = 'Semua field wajib diisi');
      return;
    }
    if (_passC.text.length < 6) { setState(() => _error = 'Password minimal 6 karakter'); return; }
    if (_passC.text != _konfirmasiC.text) { setState(() => _error = 'Konfirmasi password tidak cocok'); return; }

    setState(() { _loading = true; _error = null; });
    try {
      final res = await ApiService.register(_namaC.text.trim(), _emailC.text.trim(), _teleponC.text.trim(), _passC.text);
      if (res['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: AppTheme.green));
          Navigator.pop(context);
        }
      } else {
        setState(() => _error = res['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      setState(() => _error = 'Gagal terhubung ke server');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 60, offset: const Offset(0, 20))]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 20)),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('TransBdg', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      Text('Info Transportasi Lokal', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                    ]),
                  ]),
                  const SizedBox(height: 28),
                  Text('Buat Akun Baru', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 6),
                  Text('Daftar untuk memesan tiket transportasi', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                  const SizedBox(height: 28),

                  if (_error != null) Container(
                    padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECACA))),
                    child: Row(children: [const Text('⚠️', style: TextStyle(fontSize: 18)), const SizedBox(width: 10), Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF991B1B))))]),
                  ),

                  _buildField('Nama Lengkap', '👤', 'Masukkan nama lengkap', _namaC, TextInputType.name),
                  const SizedBox(height: 16),
                  _buildField('Email', '📧', 'contoh@email.com', _emailC, TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildField('Nomor Telepon', '📱', '08xxxxxxxxxx', _teleponC, TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildField('Password', '🔒', 'Minimal 6 karakter', _passC, TextInputType.visiblePassword, obscure: true),
                  const SizedBox(height: 16),
                  _buildField('Konfirmasi Password', '🔒', 'Ulangi password', _konfirmasiC, TextInputType.visiblePassword, obscure: true),
                  const SizedBox(height: 24),

                  SizedBox(width: double.infinity, child: Container(
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Daftar Sekarang', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  )),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Sudah punya akun? ', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                    GestureDetector(onTap: () => Navigator.pop(context), child: Text('Login di sini', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary))),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String icon, String hint, TextEditingController controller, TextInputType type, {bool obscure = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF374151))),
      const SizedBox(height: 6),
      TextField(controller: controller, keyboardType: type, obscureText: obscure, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
        decoration: InputDecoration(prefixIcon: Padding(padding: const EdgeInsets.only(left: 14, right: 10), child: Text(icon, style: const TextStyle(fontSize: 16))), prefixIconConstraints: const BoxConstraints(minWidth: 44), hintText: hint)),
    ]);
  }
}
