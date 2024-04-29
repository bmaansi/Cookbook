import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
//import 'package:cookbook/main.dart';
import 'package:cookbook/pages/home.dart';
import 'package:cookbook/pages/favorites.dart';
import 'package:cookbook/pages/list.dart';
import 'package:cookbook/pages/profile.dart';




class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookBook',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyNavBarPage(title: 'Cookbook'),
    );
  }

}

class MyNavBarPage extends StatefulWidget {
  const MyNavBarPage({super.key, required this.title});

  final String title;

  @override
  State<MyNavBarPage> createState() => _MyNavBarPageState();
}

class _MyNavBarPageState extends State<MyNavBarPage> {
  int _selectedIndex = 0;

  
  final screens = [
    const MyHomePage(),
    const MyFavPage(),
    const MyListPage(),
    const MyProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            backgroundColor: Colors.black,
            color:  const Color.fromARGB(255, 160, 160, 160),
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 26, 26, 26),
            gap: 8,
            onTabChange: (value) => {
              setState(() {
                _selectedIndex = value;
              })
            },
            
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home, 
                text: 'Home', 
                // onPressed: () {
                //   Navigator.pushNamed(context, '/home');
                // }
                ),
              GButton(
                icon: Icons.favorite, 
                text: 'Favorites',
                // onPressed: () {
                //   Navigator.pushNamed(context, '/fav');
                // }
                ),
              GButton(
                icon: Icons.list, 
                text: 'List',
                // onPressed: () {
                //   Navigator.pushNamed(context, '/list');
                // }
                ),
              GButton(
                icon: Icons.person, 
                text: 'Profile',
                // onPressed: () {
                //   Navigator.pushNamed(context, '/profile');
                // }
                ),
                
            ],
          ),         
        ),
        
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
