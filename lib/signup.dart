import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup_/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:login_signup_/main.dart';
import 'package:login_signup_/user_auth/firebase_auth_services.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    } 
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    } else if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      return 'Minimum eight characters, at least one letter, one number and one special character';
    }
    return null;
  }

  String? _cPasswordValidator(String? cPassword) {
    if (cPassword == null || cPassword.isEmpty) {
      return 'Please confirm your password';
    } else if (_passwordController.text != cPassword) {
      return 'Password must be same as above';
    }
    return null;
  }

  // void _submit() {
  //   if (_formKey.currentState!.validate()) {
  //     if (_cPasswordController.text == _passwordController.text) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //             builder: (context) => MyHome(
  //                   email: _emailController.text,
  //                 )),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Invalid Credentials')),
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text('Signup Page'),
          backgroundColor: const Color.fromARGB(255, 8, 63, 109),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tma_logo.png',
                  width: 150,
                  height: 150,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: _emailValidator,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                      hintText: 'Email'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: _passwordValidator,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      hintText: 'Password'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: _cPasswordValidator,
                  controller: _cPasswordController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.check_circle),
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password'),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 35,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 8, 63, 109),
                        foregroundColor: Colors.white),
                    child: _isSigning? const CircularProgressIndicator(color: Colors.white,): const Text('Sign up'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(fontSize: 13)),
                  TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        color: Color.fromRGBO(68, 138, 255, 1),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()))),
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isSigning = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    // String cPassword = _cPasswordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);
setState(() {
      _isSigning = false;
    });
    if (_formKey.currentState!.validate()) {
      if (user != null) {
        debugPrint("User is successfully created");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHome(
                  email: _emailController.text,
                )));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email already exist')));
      }
    }
  }
}
