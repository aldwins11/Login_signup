import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup_/homepage.dart';
import 'package:login_signup_/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:login_signup_/user_auth/firebase_auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'login': (context) => MyHomePage(),
        'signup': (context) => MySignUpPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final String email = 'aldwins123@gmail.com';
  final String password = '@Dwins1124';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    } else if (email != email) {
      return 'Email do not exist';
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    } else if (password != password) {
      return 'Incorrect Password';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == email &&
          _passwordController.text == password) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHome(
                  email: _emailController.text,
                )));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Credentials')));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text(
          "Login Page",
          style: TextStyle(),
        ),
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
                  width: 200,
                  height: 200,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                      hintText: 'Email'),
                  validator: _emailValidator,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: _toggle,
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 20,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: 'Password'),
                  obscureText: _obscureText,
                  validator: _passwordValidator,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 63, 109),
                      foregroundColor: Colors.white),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.mail,
                    color: Colors.orange,
                  ),
                  onPressed: () {},
                  label: const Text('Sign in with Google',
                      style: TextStyle(color: Color.fromARGB(255, 8, 63, 109))),
                ),
                const SizedBox(height: 10),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: 13)),
                  TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Color.fromRGBO(68, 138, 255, 1),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySignUpPage()))),
                ]))
              ],
            )),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (_formKey.currentState!.validate()) {
      if (user != null) {
        debugPrint("User is successfully signed in");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHome(
                  email: _emailController.text,
                )));
      } else {
        debugPrint('Some error happened');
      }
    }
  }
}
