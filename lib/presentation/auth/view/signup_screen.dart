import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_optimizer/core/di/service_locator.dart';
import 'package:time_optimizer/core/theme/app_theme.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Focus nodes for managing keyboard focus
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // UI state variables
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  // Password strength variables
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Password strength';
  Color _passwordStrengthColor = Colors.grey;
  
  @override
  void initState() {
    super.initState();
    
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
    });
    
    // Add listeners to update password strength
    _passwordController.addListener(_updatePasswordStrength);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    
    super.dispose();
  }

  // Calculate password strength based on various criteria
  void _updatePasswordStrength() {
    final String password = _passwordController.text;
    
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = 'Password strength';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }
    
    double strength = 0.0;
    String text = 'Weak';
    Color color = Colors.red;
    
    // Length check (25%)
    if (password.length >= 8) strength += 0.25;
    
    // Contains uppercase letter (25%)
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    
    // Contains digit (25%)
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;
    
    // Contains special character (25%)
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.25;
    
    // Determine text and color based on strength
    if (strength > 0.75) {
      text = 'Strong';
      color = Colors.green;
    } else if (strength > 0.5) {
      text = 'Good';
      color = Colors.orange;
    } else if (strength > 0.25) {
      text = 'Fair';
      color = Colors.orangeAccent;
    }
    
    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions to continue'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      setState(() => _isLoading = true);
      
      try {
        final authRepository = sl<AuthRepository>();
        await authRepository.signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        setState(() => _isLoading = false);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful! Please login.')),
          );
          Navigator.of(context).pop();
        }
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
                    const SizedBox(height: AppTheme.smallPadding),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Text(
                          'Create Account',
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
                        offset: Offset(0, _slideAnimation.value * 1.2),
                        child: Text(
                          'Sign up to start your productivity journey',
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
                            // Full Name field
                            TextFormField(
                              controller: _nameController,
                              focusNode: _nameFocusNode,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => _emailFocusNode.requestFocus(),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'John Doe',
                                prefixIcon: Icon(
                                  Icons.person_outline,
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
                                  return 'Please enter your name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                  return 'Name should only contain letters';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: AppTheme.mediumPadding),
                            
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => _passwordFocusNode.requestFocus(),
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
                                // Email validation with regex pattern
                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => _confirmPasswordFocusNode.requestFocus(),
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
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter';
                                }
                                if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                                  return 'Password must contain at least one number';
                                }
                                if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
                                  return 'Password must contain at least one special character';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: AppTheme.smallPadding),
                            
                            // Password strength indicator
                            if (_passwordController.text.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _passwordStrengthText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _passwordStrengthColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (_passwordStrength < 0.75)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (!RegExp(r'.{8,}').hasMatch(_passwordController.text))
                                            const Text(
                                              '• At least 8 characters',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text))
                                            const Text(
                                              '• At least one uppercase letter',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          if (!RegExp(r'[0-9]').hasMatch(_passwordController.text))
                                            const Text(
                                              '• At least one number',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text))
                                            const Text(
                                              '• At least one special character',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              
                            const SizedBox(height: AppTheme.mediumPadding),
                            
                            // Confirm Password field
                            TextFormField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              obscureText: !_isConfirmPasswordVisible,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.largeRadius),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: AppTheme.mediumPadding),
                            
                            // Terms and Conditions Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                  },
                                  activeColor: colorScheme.primary,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'I agree to the ',
                                          ),
                                          TextSpan(
                                            text: 'Terms of Service',
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' and ',
                                          ),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppTheme.largePadding),
                            
                            // Sign Up button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signup,
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
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
                                    : const Text('SIGN UP'),
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.extraLargePadding),
                            
                            // Login option
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Go back to login
                                    },
                                    child: const Text('Log In'),
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
