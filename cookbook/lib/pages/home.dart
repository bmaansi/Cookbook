import 'dart:convert';
import 'package:cookbook/firestorage.dart';
import 'package:cookbook/pages/searchbar.dart';
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
  int itemCount = 10;
  bool pressed = false;
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];


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
     if (items == '') {
      items += 'apples';
    }
    var url = Uri.parse('https://api.spoonacular.com/recipes/findByIngredients?ingredients=$items&number=10&ranking=1&apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print(jsonResponse[0]['id']);
      }
      return jsonResponse;
    } 
    else {
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


  Future<List<dynamic>> searchBar(String s) async {
    var url = Uri.parse('https://api.spoonacular.com/recipes/autocomplete?number=5&query=$s&apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print(jsonResponse);
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
                    (BuildContext context, SearchController controller) async {
                      _searchingWithQuery = controller.text;
                      final List<dynamic> options = (
                        await searchBar(_searchingWithQuery!)
                      );

                      if (_searchingWithQuery != controller.text) {
                        return _lastOptions;
                      }
                      _lastOptions = List<ListTile>.generate(options.length, (index) {
                        final String title = options[index]["title"];
                        final int id = options[index]["id"];
                        return ListTile(
                          title: Text(title),
                          onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MySearchBar(id: id),
                            ),
                          );
                          },
                        );
                      });
                      return _lastOptions;
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
                               // byID = await searchByID(snapshot.data![index]['id']);
                                // Uri url = Uri.parse(byID['sourceUrl']);
                                // _launchUrl(url);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(snapshot.data![index]['title']),
                                      content: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Missing Ingredients: ${snapshot.data![index]["missedIngredientCount"]}"
                                        "\nYou are missing:" +
                                       (snapshot.data![index]["missedIngredients"] as List)
                                        .map((ingredient) => "\n-${ingredient["name"]} ${ingredient["amount"]} ${ingredient["unitShort"]}")
                                        .join(),
                                        
                                        ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            byID = await searchByID(snapshot.data![index]['id']);
                                            Uri url = Uri.parse(byID['sourceUrl']);
                                            Navigator.pop(context, 'Cancel');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Summary"),
                                                  content: Text(
                                                    "Time: ${byID["readyInMinutes"]} minutes\n"
                                                    "Servings: ${byID["servings"]}"
                                                  ),
                                                  
                                                  actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      launchUrl(url);
                                                    },
                                                    child: const Text('Go to recipe'),
                                                  ),
                                                  ]
                                                );
                                              }
                                            );              
                                          },
                                          child: const Text('More Information >'),
                                        ),
                                      ],
                                    );
                                    }
                                );
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
