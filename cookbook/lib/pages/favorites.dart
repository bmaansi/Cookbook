import 'package:flutter/material.dart';



// class FavPage extends StatelessWidget {
//   const FavPage({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyFavPage(),
//     );
//   }
// }

class MyFavPage extends StatefulWidget {
  const MyFavPage({super.key});

  @override
  State<MyFavPage> createState() => _MyFavPageState();
}

class _MyFavPageState extends State<MyFavPage> {

  @override
  Widget build(BuildContext context) {
   
    return const Scaffold(      
      body: Center(    
        child: Column(       
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the Fav page"),
          ],
        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
