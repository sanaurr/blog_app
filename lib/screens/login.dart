import 'package:blog_app/models/user.dart';
import 'package:blog_app/service.dart';
import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/widgets/neu_button.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool signin = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
      appBar: AppBar(
        backgroundColor: isDark ? NeuColors.neuBaseDark : NeuColors.neuBase,
        foregroundColor: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
        elevation: 0,
        title: Text(
          signin ? 'Sign In' : 'Sign Up',
          style: TextStyle(
            color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: NeuContainer(
              isDark: isDark,
              borderRadius: 24,
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      signin ? "Welcome Back" : "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!signin)
                      TextField(
                        controller: nameController,
                        style: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          labelStyle: TextStyle(
                            color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                          ),
                          prefixIcon: Icon(Icons.person, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDark ? NeuColors.neuBaseDark.withOpacity(0.8) : NeuColors.neuBase.withOpacity(0.8),
                        ),
                      )
                    else
                      const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        prefixIcon: Icon(Icons.email, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? NeuColors.neuBaseDark.withOpacity(0.8) : NeuColors.neuBase.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
                        ),
                        prefixIcon: Icon(Icons.lock, color: isDark ? NeuColors.neuTextDark : NeuColors.neuText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? NeuColors.neuBaseDark.withOpacity(0.8) : NeuColors.neuBase.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    NeuButton(
                      label: signin ? 'Sign In' : "Sign Up",
                      isDark: isDark,
                      onPressed: () async {
                        var navigator = Navigator.of(context);
                        var messenger = ScaffoldMessenger.of(context);
                        if (signin) {
                          Map<String, String> data = {
                            "email": emailController.text,
                            "password": passwordController.text,
                          };
                          var success = await login(data, context.read<User>());
                          if (success) {
                            navigator.pop();
                          } else {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Login failed.'),
                              ),
                            );
                          }
                        } else {
                          Map<String, String> data = {
                            "name": nameController.text,
                            "email": emailController.text,
                            "password": passwordController.text,
                          };
                          var success = await signup(data, context.read<User>());
                          if (success) {
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            navigator.pop();
                          } else {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Sign up failed.'),
                              ),
                            );
                          }
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      borderRadius: 12,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 10),
                    if (signin)
                      TextButton(
                        onPressed: () {
                          // Forgot password action
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          signin = !signin;
                        });
                      },
                      child: Text(
                        signin ? "Don't have an account? Sign Up" : "Already have an account? Sign In",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
