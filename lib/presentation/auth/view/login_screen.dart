import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_optimizer/core/di/service_locator.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';
import 'package:time_optimizer/presentation/auth/view/forgot_password_screen.dart';
import 'package:time_optimizer/presentation/auth/view/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _supportsBiometrics = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  final _authRepository = sl<AuthRepository>();
  
  @override
  void initState() {
    super.initState();
    
    // Pre-fill for demo purposes
    _emailController.text = 'testuser@example.com';
    _passwordController.text = 'password123';
    
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.mediumAnimation,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _checkBiometrics(); // Check if device supports biometrics
    });
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Check if device supports biometric authentication
  Future<void> _checkBiometrics() async {
    // This would normally use a package like local_auth
    // For now, we'll just simulate biometric support
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      setState(() {
        _supportsBiometrics = true;
      });
    }
  }
  
  // Authenticate with biometrics
  Future<void> _authenticateWithBiometrics() async {
    setState(() => _isLoading = true);
    
    try {
      // This would normally use local_auth package
      // For now, we'll just simulate successful biometric auth
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate successful login with demo credentials
      await _authRepository.logInWithEmailAndPassword(
        email: 'testuser@example.com',
        password: 'password123',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication successful'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authRepository.logInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        setState(() => _isLoading = false);
      } catch (e) {
        setState(() => _isLoading = false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.extraLargePadding),
                    // App logo
                    Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.8),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(AppTheme.largeRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withAlpha(60),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.timer_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.largePadding),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Text(
                          'Welcome Back',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.smallPadding),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Text(
                          'Log in to continue your productivity journey',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withAlpha(180),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.extraLargePadding),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'name@example.com',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainer,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppTheme.mediumPadding),
                            
                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _login(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '••••••••',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colorScheme.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible 
                                        ? Icons.visibility_off_outlined 
                                        : Icons.visibility_outlined,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainer,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            
                            // Remember me and forgot password row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Remember me checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: colorScheme.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    Text(
                                      'Remember me',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorScheme.primary,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppTheme.largePadding),
                            
                            // Login button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: colorScheme.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'LOG IN',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                              ),
                            ),
                            
                            // Biometric login if available
                            if (_supportsBiometrics) ...[  
                              const SizedBox(height: AppTheme.mediumPadding),
                              Center(
                                child: TextButton.icon(
                                  onPressed: _isLoading ? null : _authenticateWithBiometrics,
                                  icon: Icon(
                                    Icons.fingerprint,
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                  label: Text(
                                    'Login with Biometrics',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: AppTheme.largePadding),
                            
                            // Sign up option
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account?',
                                    style: textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignupScreen(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.smallPadding,
                                      ),
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
            );
          },
        ),
      ),
    );
  }
}
