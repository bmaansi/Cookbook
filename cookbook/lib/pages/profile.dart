import 'package:cookbook/pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  // void signOut() {
  //   await FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold( 
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, 
          icon: const Icon(Icons.logout))
      ],),     
      body: const Center(    
        child: Column(       
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the profile page"),
          ],
        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
