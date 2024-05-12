import 'package:cookbook/firestorage.dart';
import 'package:cookbook/pages/myrecipes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  // void signOut() {
  //   await FirebaseAuth.instance.signOut();
  // }
  UserInfoStorage? _userInfoStorage;
  RecipesStorage? _recipesStorage;

  _MyProfilePageState() {
    _userInfoStorage = UserInfoStorage();
    _recipesStorage =  RecipesStorage();

    
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold( 
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, 
          icon: const Icon(Icons.logout))
      ],),     
      body: SafeArea(
  child: SingleChildScrollView(
     child: Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<String?>(
          future: _userInfoStorage!.readFirstname(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '${snapshot.data} ',
                    style: const TextStyle(fontSize: 20),
                  );
                }
            }
          }),
        ),
        FutureBuilder<String?>(
          future: _userInfoStorage!.readLastname(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '${snapshot.data}',
                    style: const TextStyle(fontSize: 20),
                  );
                }
            }
          }),
        ),
        FutureBuilder<String?>(
          future: _userInfoStorage!.readUsername(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '@${snapshot.data}',
                    style: const TextStyle(fontSize: 17),
                  );
                }
            }
          }),
        ),
        const SizedBox(
          height: 10,
        ),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text( "MY RECIPES" ),
            IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.add)
            ),
              
          ]
          
          ),
        const SizedBox(
          height: 10,
        ),
          FutureBuilder(
          future: _recipesStorage?.readRecipes(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return SizedBox(
                    height: 200.0,
                    
                    child: ListView.builder(
                      
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                       return GestureDetector (
                        onTap : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyRecipesPage(detail: snapshot.data![index]),
                            ),
                          );
                        },
                       child: Card(
                          child: Column (   
                            children: [
                              ListTile(
                                title: Text(
                                  snapshot.data![index]['Title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  ),
                              )
                            ]
                          )
                       ),
                    );
                      },
                    ),


                  );
                }
            }
          },
          
        ),
        
      ],
      
    ),
    
  ),
  
),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            
          }, 
          child: const Icon(Icons.add)
        ),

    );
  }
}
