// import 'package:flutter/material.dart';
// import 'package:movie_app/features/Auth_features/data/datasource/remote_data_source.dart';
// import 'package:movie_app/now.dart';

// class SignUpScreen extends StatefulWidget {
//   final TMDBAuth tmdbAuth;

//   const SignUpScreen({super.key, required this.tmdbAuth});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//   String? errorMessage;

//   void _signUp() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       await widget.tmdbAuth.getRequestToken();
//       // Assuming there's an API endpoint to register the user
//       // You would replace this with the actual API call to sign up the user
//       await widget.tmdbAuth.validateWithLogin(
//         usernameController.text,
//         passwordController.text,
//       );
//       await widget.tmdbAuth.createSession();
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const NowPlayingMoviesScreen()),
//       );
//     } catch (e) {
//       setState(() {
//         errorMessage = e.toString();
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             if (isLoading) const CircularProgressIndicator(),
//             if (errorMessage != null)
//               Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _signUp,
//                   child: const Text('Sign Up'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_cubit.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_state.dart';
import 'package:movie_app/features/home_feature/presention/screens/home.dart';
import 'package:movie_app/features/now.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void _signUp() {
    final username = usernameController.text;
    final password = passwordController.text;

    context.read<AuthCubit>().login(username, password); // Replace this with actual sign-up logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: BlocListener<AuthCubit, AuthState>(
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
        child: Padding(
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
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
