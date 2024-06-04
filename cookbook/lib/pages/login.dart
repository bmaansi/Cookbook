// ignore_for_file: use_build_context_synchronously

import 'package:cookbook/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailContoller = TextEditingController();

  final passwordContoller = TextEditingController();

  void userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailContoller.text, password: passwordContoller.text
    );
    } on FirebaseAuthException catch (e) {    
        showDialog(context: context, builder: (context) {
          return AlertDialog(title: Text(e.code));
        });
    } 

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      // backgroundColor: Color.fromARGB(255, 21, 35, 43),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("C o o k B o o k"),
      ),
      
      body: SafeArea (
        child: Center (
          
        child: SingleChildScrollView (
        child: Column(
        children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.auto_stories,
            size: 100,
            // color: Color.fromARGB(255, 202, 206, 234),
            color: Colors.black,
            ),
          const SizedBox(height: 25),

          const Text (
            "Welcome to Cookbook!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16
            )
          ),


          const SizedBox(height: 50),
          MyTextField(controller: emailContoller, hintText: "Email", obscureText: false),
          const SizedBox(height: 15),
         
          MyTextField(controller: passwordContoller, hintText: "Password", obscureText: true),
          

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have account? ",
                style: TextStyle(
                  fontSize: 16
                ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                    
                  },
                  child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                userLogin();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
                
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),

        ],

        ),
        )
       
      )
      )
      );
       // This trailing comma makes auto-formatting nicer for build methods.
  }
}

