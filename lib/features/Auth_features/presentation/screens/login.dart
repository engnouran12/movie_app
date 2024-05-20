import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_state.dart';
import 'package:movie_app/features/Auth_features/presentation/screens/signup.dart';
import 'package:movie_app/features/home_feature/presention/screens/home.dart';
import 'package:movie_app/features/now.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void _login() {
    final username = usernameController.text;
    final password = passwordController.text;

    context.read<AuthCubit>().login(username, password);
  }

  void _skipLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>
       HomeScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>
       SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocListener<AuthCubit, 
      AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => 
              HomeScreen()),
            );
          } else if (state is AuthError) {
            setState(() {
              errorMessage = state.message;
            });
          }
        },
        child:Center(
          child: 
         Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator(),
              if (errorMessage != null) Text(errorMessage!, style: TextStyle(color: Colors.red)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: _skipLogin,
                    child: Text('Skip'),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToSignUp,
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
