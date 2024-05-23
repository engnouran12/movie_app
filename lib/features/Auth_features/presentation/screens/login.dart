import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_state.dart';
import 'package:movie_app/features/home_feature/presention/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = usernameController.text;
      final password = passwordController.text;

      context.read<AuthCubit>().login(username, password);
    }
  }

  void _skipLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }

          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state is AuthError) {
            setState(() {
              errorMessage = state.message;
            });
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: _validateUsername,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  if (isLoading) const CircularProgressIndicator(),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: _skipLogin,
                        child: const Text('Skip'),
                      ),
                    
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
