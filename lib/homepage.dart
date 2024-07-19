import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text('Homepage'),
          backgroundColor: const Color.fromARGB(255, 8, 63, 109),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/tma_logo.png',
                width: 200,
                height: 200,
              ),
              Text('Welcome! $email', style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, 'login');
              }, child: Text("Sign out"))
            ],
          ),
        ));
  }
}
