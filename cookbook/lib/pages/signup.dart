import 'package:cookbook/components/textfield.dart';
import 'package:cookbook/firestorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameContoller = TextEditingController();
  final firstNameContoller = TextEditingController();
  final lastNameContoller = TextEditingController();
  final emailContoller = TextEditingController();
  final passwordContoller = TextEditingController();

 UserInfoStorage? _storage;
 _SignupPageState() {
    _storage = UserInfoStorage(); 
  }


  Future<void> userSignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailContoller.text, password: passwordContoller.text
      ).then((firebaseUser) => {
        if(kDebugMode){
          print('User: ${firebaseUser.user!.email} created successfully')
        },

        _storage?.addUserDetails(usernameContoller.text, firstNameContoller.text, lastNameContoller.text.trim(), firebaseUser.user!.email! )
      });
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
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
          
          MyTextField(controller: usernameContoller, hintText: "Username", obscureText: false),
          MyTextField(controller: firstNameContoller, hintText: "First Name", obscureText: false),
          MyTextField(controller: lastNameContoller, hintText: "Last Name", obscureText: false),
          MyTextField(controller: emailContoller, hintText: "Email", obscureText: false),
          MyTextField(controller: passwordContoller, hintText: "Password", obscureText: true),



          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(
                  fontSize: 16
                ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                    
                  },
                  child: const Text(
                  "Login",
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
                  userSignUp();
                  Navigator.pushNamed(context, '/auth');
                

              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
                
              ),
              child: const Text(
                "Sign Up",
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

