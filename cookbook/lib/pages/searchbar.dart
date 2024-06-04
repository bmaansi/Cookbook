import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



class MySearchBar extends StatefulWidget {
  final int id;
  MySearchBar({super.key, required this.id});
  

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  String apiKey = "4b0512405e9543dc9b91d7ceaaf0fcde";

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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (kDebugMode) {
      print('Could not launch $url'); 
      }
    }
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back to Search"),
        ),
      body: SafeArea(
        child: Column(
           children: <Widget>[
            FutureBuilder<dynamic>(
              future: searchByID(widget.id),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SingleChildScrollView (
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

  
                      children: [
                        Center(
                          child: Text(
                            "${snapshot.data["title"]}",
                            style: const TextStyle(
                              fontSize: 25
                            ),
                          
                          ),
                        ),
                        Text(
                          "Serving: ${snapshot.data["servings"]}",
                          style: const TextStyle(
                            fontSize: 15
                          )
                        ),
                      

                        Text(
                          "Time: ${snapshot.data["readyInMinutes"]}",
                          style: const TextStyle(
                            fontSize: 15
                          )
                        ),
                        const SizedBox(height: 10),

                        Image.network(snapshot.data["image"]),

                        
  
                        
                        const Text("Ingredients: ", 
                            style: TextStyle(
                              fontSize: 18
                          ),
                          ),

                        Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          (snapshot.data["extendedIngredients"] as List)
                          .map((item) => "${item["name"]} ${item["amount"]} ${item["unit"]}\n")
                          .join(),
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Uri url = Uri.parse(snapshot.data['sourceUrl']);
                            launchUrl(url);
                          }, 
                          icon: const Icon(Icons.open_in_new)
                        )

                      ]

                    )
                  );
                }
            }
              }),
            )

           ]
        ),
        
      ),
    );
  }

}
