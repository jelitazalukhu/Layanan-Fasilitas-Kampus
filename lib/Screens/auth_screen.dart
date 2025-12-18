import 'package:flutter/material.dart';
import '../Navigation/main_navigation.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _isLoading = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // Not used for login anymore, but maybe for register
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _inputField(
    String hint, {
    bool isPassword = false,
    IconData? icon,
    bool obscure = false,
    VoidCallback? onToggle,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: icon != null
              ? Icon(icon, size: 20, color: Color(0xFF9CA3AF))
              : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: const Color(0xFF9CA3AF),
                  ),
                  onPressed: onToggle,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF065F46), width: 1.5),
          ),
        ),
      ),
    );
  }

  Future<void> _submitAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> result;

    if (isLogin) {
      result = await _authService.login(
        _nimController.text,
        _passwordController.text,
      );
    } else {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password tidak sama")),
        );
        return;
      }

      result = await _authService.register(
        _nameController.text,
        _emailController.text,
        _nimController.text,
        _passwordController.text,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Terjadi kesalahan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF1FFF4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER (DISSOLVE)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(isLogin),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin ? "Selamat Datang Kembali" : "Buat Akun Baru",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin
                            ? "Cari dan booking fasilitas kampus dengan mudah"
                            : "Daftar sekarang untuk mulai mengakses fasilitas kampus",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// FORM (DISSOLVE)
                Form(
                  key: _formKey,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(isLogin),
                      children: [
                        if (!isLogin)
                          _inputField(
                            "Nama Lengkap",
                            icon: Icons.person_outline,
                            controller: _nameController,
                            validator: (val) => val!.isEmpty ? 'Nama wajib diisi' : null,
                          ),
                        if (!isLogin)
                          _inputField(
                            "Email",
                            icon: Icons.email_outlined,
                            controller: _emailController,
                            validator: (val) => val!.isEmpty ? 'Email wajib diisi' : null,
                          ),
                        _inputField(
                          "NIM",
                          icon: Icons.badge_outlined,
                          controller: _nimController,
                          validator: (val) => val!.isEmpty ? 'NIM wajib diisi' : null,
                        ),
                        _inputField(
                          "Password",
                          isPassword: true,
                          obscure: _obscurePassword,
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          validator: (val) => val!.length < 6 ? 'Min 6 karakter' : null,
                          onToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        if (!isLogin)
                          _inputField(
                            "Konfirmasi Password",
                            isPassword: true,
                            obscure: _obscureConfirmPassword,
                            icon: Icons.lock_outline,
                            controller: _confirmPasswordController,
                            onToggle: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),

                        const SizedBox(height: 24),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF065F46),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    isLogin ? "Login" : "Sign Up",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SWITCH LOGIN <-> REGISTER
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                              _formKey.currentState?.reset();
                              _nameController.clear();
                              _emailController.clear();
                              _nimController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLogin
                                    ? "Belum punya akun? "
                                    : "Sudah punya akun? ",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLogin ? "Daftar" : "Login",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF065F46),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 36,
                                    height: 1.2,
                                    color: Color(0xFF065F46),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
