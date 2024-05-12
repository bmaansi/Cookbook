import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cookbook/firestorage.dart';
import 'package:flutter/foundation.dart';
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
  const MyFavPage({super.key});

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

  Future<List<dynamic>> searchByID() async {
    faves = await _favStorage!.readFavorites();
    //List<dynamic> jsonResponseList = [];
    String ids = "";
    //late var jsonResponse;
    for (int id in faves) {
      if (id != faves.last) {
        ids += '$id,';
      } else {
        ids += "$id";
      }
    }
      var url = Uri.parse('https://api.spoonacular.com/recipes/informationBulk?ids=$ids&apiKey=$apiKey');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }
        return jsonResponse;
        //jsonResponseList.add(jsonResponse);
      } else {
        if (kDebugMode) {
          print('HERE: Response status: ${response.statusCode}');
        }
        return List.empty();
      } 
    //}   
    
  }

  Future<List<int>> getData() async {
    //byID = searchByID(716429);
    faves = await _favStorage!.readFavorites();
    return faves;
  
  }

  void favoriteRecipe(int id, int index) {
    faves.contains(id) ? _favStorage?.removeFavorites(id) : _favStorage?.writeFavorites(id)
    .then((_) {
      setState(()async  {
        faves.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(      
      body: SafeArea(    
        child: CustomScrollView(       
          slivers: <Widget> [
             FutureBuilder<dynamic> (
                future: searchByID(),
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
                          itemCount: faves.length,
                          itemBuilder: (context, index) {
                            //return Text(snapshot.data![index]['title']);
                            return GestureDetector (
                              onTap : () async {
                                //print("PRINTING: $byID\n");
                                Uri url = Uri.parse(snapshot.data[index]['sourceUrl']);
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
                                                favoriteRecipe(snapshot.data![index]['id'], index);
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
                      
              )
          ]
        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
