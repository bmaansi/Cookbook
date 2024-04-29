import 'dart:convert';

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
  List<String> suggestions = [
    "Pasta", "Burgers", "Cake"
  ];

  List<String> list = [
    "apples","flour","sugar"
  ];

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (kDebugMode) {
      print('Could not launch $url'); 
      }
    }
  }

  late Future<List<dynamic>> byIngredients;
  late List<dynamic> byID;
  int itemCount = 10;


  Future<List<dynamic>> searchByIngredients() async {
    var url = Uri.parse('https://api.spoonacular.com/recipes/findByIngredients?ingredients=${list[0]},+${list[1]},+${list[2]}&number=10&apiKey=$apiKey');
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

  Future<List<dynamic>> searchByID(int id) async {
    var url = Uri.parse('https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print(jsonResponse[0]['title']);
      }
      return jsonResponse;
    } else {
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      return List.empty();
    } 
  }



  @override
  void initState() {
    super.initState();
    //setState(() {
      byIngredients = searchByIngredients();  
    //});

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
                        //return Text(snapshot.data![0]['title']);
                        return SliverList.builder(
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            //return Text(snapshot.data![index]['title']);
                            return GestureDetector (
                              onTap : () async {
                                byID = await searchByID(snapshot.data![index]['id']);
                                //print(byID);
                                Uri url = Uri.parse('${byID[index]['spoonacularSourceUrl']}');
                                _launchUrl(url);
                                 
                                
                                },
                              child: Card(
                                child: Column (
                                  children: [
                                    ListTile(
                                      title: Text(snapshot.data![index]['title']),
                                      subtitle: Image.network(snapshot.data![index]['image']),
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
