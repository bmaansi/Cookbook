import 'package:cookbook/navbar.dart';
// import 'package:cookbook/pages/favorites.dart';
// import 'package:cookbook/pages/home.dart';
// import 'package:cookbook/pages/list.dart';
// import 'package:cookbook/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/pages/login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // title: 'Flutter Demo',
       theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
         useMaterial3: true,
       ),
      routes: {
        //'/login': (context) => const LoginPage(),
        '/navbar': (context) => const NavBarPage(),
        // '/home': (context) => const MyHomePage(),
        // '/fav': (context) => const MyFavPage(),
        // '/list': (context) => const MyListPage(),
        // '/profile': (context) => const MyProfilePage()
      },
      home: const LoginPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       appBar: AppBar(
       
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
       
//         child: Column(
          
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
           
//           ],
//         ),
//       ),
//        // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
