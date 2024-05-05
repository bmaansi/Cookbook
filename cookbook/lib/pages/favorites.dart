import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cookbook/firestorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



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
  MyFavPage({super.key});

  @override
  State<MyFavPage> createState() => _MyFavPageState();
}



class _MyFavPageState extends State<MyFavPage> {
   FavoritesStorage? _favStorage;
  _MyFavPageState() {
    _favStorage = FavoritesStorage();
  }
    String apiKey = "4b0512405e9543dc9b91d7ceaaf0fcde";
    late dynamic byID;
    late List<String> list;
    late List<int> faves;


    Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (kDebugMode) {
      print('Could not launch $url'); 
      }
    }
  }

  Future<dynamic> searchByID(int id) async {
    var url = Uri.parse('https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      return jsonResponse;
    } else {
      if (kDebugMode) {

        print('HERE: Response status: ${response.statusCode}');
      }
      return List.empty();
    } 
  }

  Future<List<int>> getData() async {
    //byID = searchByID(716429);
    faves = await _favStorage!.readFavorites();
    return _favStorage!.readFavorites();
  
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
  Widget build(BuildContext context) {
   
    return Scaffold(      
      body: SafeArea(    
        child: CustomScrollView(       
          slivers: <Widget> [
             FutureBuilder<List<int>> (
                future: getData(),
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
                        List<int> ids = snapshot.data!;

                        return SliverList.builder( 
                          itemCount: ids.length,
                          itemBuilder: (context, index) {
                          return FutureBuilder<dynamic>(
                          future: searchByID(ids[index]),
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
                                   //return Text(snapshot.data![index]['title']);
                                   
                            return GestureDetector (
                              onTap : () async {
                                //print("PRINTING: $byID\n");
                                Uri url = Uri.parse(snapshot.data['sourceUrl']);
                                _launchUrl(url);
                                },
                              child: Card(
                                child: Column (
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data['title'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        ),
                                        subtitle: Column(
                                          children: <Widget>[
                                            Image.network(snapshot.data['image']),
                                            IconButton(
                                              onPressed: () {
                                                favoriteRecipe(ids[index]);
                                                //setState(() {});
                                              },  
                                              icon: Icon(
                                                 faves.contains(ids[index]) 
                                                 ? Icons.favorite
                                                 : Icons.favorite_border
                                              ),
                                              color: 
                                                faves.contains(ids[index]) 
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
                            }

                          }
                        );
                          }

                        );           



                        
                      } 
                  }
                }
                      
              )
          ]
        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
