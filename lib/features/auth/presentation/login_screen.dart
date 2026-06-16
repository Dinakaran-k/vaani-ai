import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/presentation/vaani_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'owner@vaani.ai');
  final _password = TextEditingController(text: 'password123');
  final _phone = TextEditingController(text: '9876543210');
  var _mode = _LoginMode.email;
  var _obscurePassword = true;
  var _rememberDevice = true;
  var _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          children: [
            Row(
              children: [
                const VaaniLogo(size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Sign in to continue managing your shop.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: VaaniTheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SegmentedButton<_LoginMode>(
              segments: const [
                ButtonSegment(
                  value: _LoginMode.email,
                  icon: Icon(Icons.mail_outline_rounded),
                  label: Text('Email'),
                ),
                ButtonSegment(
                  value: _LoginMode.phone,
                  icon: Icon(Icons.phone_android_rounded),
                  label: Text('Phone'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (value) {
                setState(() => _mode = value.single);
              },
            ),
            const SizedBox(height: 20),
            VaaniCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _mode == _LoginMode.email
                          ? Column(
                              key: const ValueKey('email-form'),
                              children: [
                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Email address',
                                    prefixIcon: Icon(Icons.mail_outline),
                                  ),
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _password,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      tooltip: _obscurePassword
                                          ? 'Show password'
                                          : 'Hide password',
                                      onPressed: () {
                                        setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        );
                                      },
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: _validatePassword,
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('phone-form'),
                              children: [
                                TextFormField(
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile number',
                                    prefixText: '+91 ',
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                  validator: _validatePhone,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'We will send an OTP after Firebase phone auth is configured.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: VaaniTheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _rememberDevice,
                      onChanged: (value) {
                        setState(() => _rememberDevice = value);
                      },
                      title: const Text('Remember this device'),
                      subtitle: const Text('Keep daily shop workflows quick'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _loading ? null : _continue,
                      icon: _loading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _mode == _LoginMode.email
                                  ? Icons.login_rounded
                                  : Icons.sms_outlined,
                            ),
                      label: Text(
                        _mode == _LoginMode.email
                            ? 'Sign in'
                            : 'Send OTP preview',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => showVaaniSnackBar(
                                context,
                                'Password reset link prepared',
                              ),
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VaaniTheme.onSurfaceVariant,
                        ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            _AuthOption(
              icon: Icons.g_mobiledata_rounded,
              title: 'Continue with Google',
              onTap: () => showVaaniSnackBar(
                context,
                'Google sign-in will connect after OAuth setup',
              ),
            ),
            const SizedBox(height: 12),
            _AuthOption(
              icon: Icons.storefront_outlined,
              title: 'Open demo business',
              onTap: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (!text.contains('@') || !text.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return 'Enter a 10 digit mobile number';
    return null;
  }

  Future<void> _continue() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _loading = false);
    if (_mode == _LoginMode.phone) {
      showVaaniSnackBar(context, 'OTP preview sent');
      return;
    }
    context.go('/home');
  }
}

class _AuthOption extends StatelessWidget {
  const _AuthOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E0EE)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: VaaniTheme.primaryContainer,
                child: Icon(icon, color: VaaniTheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

enum _LoginMode { email, phone }
