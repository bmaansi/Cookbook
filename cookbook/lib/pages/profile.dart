import 'package:flutter/material.dart';



// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyProfilePage(),
//     );
//   }
// }

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  @override
  Widget build(BuildContext context) {
   
    return const Scaffold(      
      body: Center(    
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
