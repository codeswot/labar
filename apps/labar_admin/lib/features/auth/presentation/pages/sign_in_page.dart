import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:labar_admin/core/router/app_router.gr.dart';
import 'package:ui_library/ui_library.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _showResend = false;
  bool _showOtpEntry = false;
  bool _isResending = false;
  String? _successMessage;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _showResend = false;
      _successMessage = null;
    });

    try {
      final user = await getIt<AuthRepository>().signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user == null) {
        setState(() => _error = 'Invalid email or password');
      } else {
        if (mounted) {
          context.router.replaceAll([const DashboardRoute()]);
        }
      }
    } on AuthException catch (e) {
      setState(() {
        _error = e.message;
        if (e.message.toLowerCase().contains('email not confirmed')) {
          _showResend = true;
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
      _error = null;
    });

    try {
      await getIt<AuthRepository>().resendOtp(
        email: _emailController.text.trim(),
      );
      setState(() {
        _successMessage = 'Confirmation email resent. Please check your inbox.';
        _showResend = false;
        _showOtpEntry = true;
      });
    } catch (e) {
      setState(() => _error = 'Failed to resend confirmation email: $e');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await getIt<AuthRepository>().verifyOtp(
        email: _emailController.text.trim(),
        token: _otpController.text.trim(),
      );

      if (user == null) {
        setState(() => _error = 'Invalid OTP');
      } else {
        context.router.replaceAll([const DashboardRoute()]);
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: context.moonColors?.gohan,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Labar Admin',
                style: context.moonTypography?.heading.text24,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please sign in to continue',
                style: context.moonTypography?.body.text14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (!_showOtpEntry) ...[
                MoonTextInput(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                MoonTextInput(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
              ] else ...[
                Text(
                  'Enter the 6-digit code sent to ${_emailController.text}',
                  style: context.moonTypography?.body.text12,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                MoonTextInput(
                  controller: _otpController,
                  hintText: '6-digit code',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _showOtpEntry = false),
                  child: const Text('Back to Sign In'),
                ),
              ],
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
              if (_successMessage != null) ...[
                Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
              if (_showResend && !_showOtpEntry) ...[
                AppButton.outlined(
                  onTap: _isResending ? null : _resendOtp,
                  isLoading: _isResending,
                  label: const Text('Resend Confirmation Email'),
                ),
                const SizedBox(height: 16),
              ],
              AppButton.filled(
                onTap:
                    _isLoading ? null : (_showOtpEntry ? _verifyOtp : _signIn),
                isLoading: _isLoading,
                label: Text(_showOtpEntry ? 'Verify OTP' : 'Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
