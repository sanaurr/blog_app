import 'package:blog_app/models/user.dart';
import 'package:blog_app/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // Controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool signin = true;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for fading in the elements
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
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
    
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(signin ? 'Sign In' : 'Sign Up'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
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
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      !signin ? TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: colorScheme.primaryContainer,
                        ),
                      ):const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: colorScheme.primaryContainer.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                        
                      // Password TextField
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: colorScheme.primaryContainer.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                        
                     
                      ElevatedButton(
                        onPressed: () async{
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                         signin ? 'Sign In': "Sign Up",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                        
                      // Forgot Password Link
                     if (signin) TextButton(
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
                        
                      // Register Link
                      TextButton(
                        onPressed: () {
                          setState(() {
                            signin = !signin;
                          });
                        },
                        child:  Text(
                         signin ? "Don't have an account? Sign Up": "Already have an account? Sign In",
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
      ),
    );
  }
}

