import 'dart:convert';
import 'package:cookbook/firestorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiKey = "4b0512405e9543dc9b91d7ceaaf0fcde";

  GroceryListStorage? _grocStorage;
  FavoritesStorage? _favStorage;
  _MyHomePageState() {
    _grocStorage = GroceryListStorage(); 
    _favStorage = FavoritesStorage();
  }
  late List<String> list;
  late List<int> faves;
  String items = '';

  

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (kDebugMode) {
      print('Could not launch $url'); 
      }
    }
  }

  late Future<List<dynamic>> byIngredients;
  late dynamic byID;
  int itemCount = 15;
  bool pressed = false;


  void listForAPI() async {
    for (var i in list) {
      if (i != list.last) {
        items += '$i,+';
      } else {
        items += i;
      }
    }
  }

  Future<List<dynamic>> searchByIngredients() async {
    list = await _grocStorage!.readList();
    faves = await _favStorage!.readFavorites();
    listForAPI();
    var url = Uri.parse('https://api.spoonacular.com/recipes/findByIngredients?ingredients=$items&number=15&ranking=1&apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print(jsonResponse[0]['id']);
      }
      return jsonResponse;
    } else {
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      return List.empty();
    } 
  }

  Future<dynamic> searchByID(int id) async {
    var url = Uri.parse('https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print(jsonResponse['sourceUrl']);
      }
      return jsonResponse;
    } else {
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      return List.empty();
    } 
  }

  void favoriteRecipe(int id) {
    faves.contains(id) ? _favStorage?.removeFavorites(id) : _favStorage?.writeFavorites(id)
    .then((_) {
      setState(()async  {
        faves = await _favStorage!.readFavorites();
      });
    });
  }


  @override
  void initState() {
    super.initState();
    byIngredients = searchByIngredients();  
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xff6750a4)),
      home: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                clipBehavior: Clip.none,
                shape: const StadiumBorder(),
                scrolledUnderElevation: 0.0,
                titleSpacing: 0.0,
                backgroundColor: Colors.transparent,
                pinned: true, // We can also uncomment this line and set `pinned` to true to see a pinned search bar.
                title: SearchAnchor.bar(
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<Widget>.generate(
                      5,
                      (int index) {
                        return ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Text('Initial list item $index'),
                        );
                      },
                    );
                  },
                ),
              ),
              FutureBuilder<List> (
                future: byIngredients,
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    default:
                      if(snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      } else {
                        
                        return SliverList.builder(
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            //return Text(snapshot.data![index]['title']);
                            return GestureDetector (
                              onTap : () async {
                                byID = await searchByID(snapshot.data![index]['id']);
                                //print("PRINTING: $byID\n");
                                Uri url = Uri.parse(byID['sourceUrl']);
                                _launchUrl(url);
                                },
                              child: Card(
                                child: Column (
                                  
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data![index]['title'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        ),
                                        subtitle: Column(
                                          children: <Widget>[
                                            Image.network(snapshot.data![index]['image']),
                                            IconButton(
                                              onPressed: () {
                                                favoriteRecipe(snapshot.data![index]['id']);
                                                //setState(() {});
                                              },  
                                              icon: Icon(
                                                 faves.contains(snapshot.data![index]['id']) 
                                                 ? Icons.favorite
                                                 : Icons.favorite_border
                                              ),
                                              color: 
                                                faves.contains(snapshot.data![index]['id']) 
                                                 ? Colors.red
                                                 : Colors.black,
                                            )
                                          ],
                                        ),
                                      //subtitle: Image.network(snapshot.data![index]['image']),
                                    ),
                                    //Image.network(snapshot.data![index]['thumbnail']['lqip']),     
                                  ],
                                )      
                              ),                   
                            );
                          }
                        );
                        
                      }
                  }
                }
              ),

            ],
            
          ), 
        ),

      ),
    );
  }
}
