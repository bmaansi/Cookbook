import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("C o o k B o o k"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Enter App"),
          onPressed: () {
            Navigator.pushNamed(context, '/navbar');
          },
          
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

