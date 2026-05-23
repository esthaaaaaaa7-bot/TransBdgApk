import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    if (_emailC.text.isEmpty || _passC.text.isEmpty) {
      setState(() => _error = 'Email dan password wajib diisi');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await ApiService.login(_emailC.text.trim(), _passC.text);
      if (res['success'] == true) {
        await ApiService.saveUser(res['user']);
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => _error = res['message'] ?? 'Login gagal');
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 60, offset: const Offset(0, 20))],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // Logo
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('TransBdg', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      Text('Info Transportasi Lokal', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                    ]),
                  ]),
                  const SizedBox(height: 28),
                  Text('Selamat Datang Kembali', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 6),
                  Text('Login untuk memesan tiket transportasi', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                  const SizedBox(height: 28),

                  // Error
                  if (_error != null) Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECACA))),
                    child: Row(children: [
                      const Text('⚠️', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF991B1B)))),
                    ]),
                  ),

                  // Email
                  _buildField('Email', '📧', 'contoh@email.com', _emailC, TextInputType.emailAddress),
                  const SizedBox(height: 18),
                  // Password
                  _buildField('Password', '🔒', 'Masukkan password', _passC, TextInputType.visiblePassword, obscure: true),
                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Login', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Belum punya akun? ', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: Text('Daftar di sini', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                    ),
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
      TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
        decoration: InputDecoration(prefixIcon: Padding(padding: const EdgeInsets.only(left: 14, right: 10), child: Text(icon, style: const TextStyle(fontSize: 16))), prefixIconConstraints: const BoxConstraints(minWidth: 44), hintText: hint),
      ),
    ]);
  }
}
