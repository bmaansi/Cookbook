import 'dart:io';

import 'package:cookbook/firestorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';





class MyAddRecipesPage extends StatefulWidget {
  const MyAddRecipesPage({super.key});
  

  @override
  State<MyAddRecipesPage> createState() => _MyAddRecipesPageState();
}

class _MyAddRecipesPageState extends State<MyAddRecipesPage> {


  RecipesStorage? _recipesStorage;

  _MyAddRecipesPageState() {
    _recipesStorage =  RecipesStorage();
  }


  final _titleKey = GlobalKey<FormState>();
  final _myTitleController = TextEditingController();

  final _ingredientKey = GlobalKey<FormState>();
  final _myIngredientController = TextEditingController();

  final _stepsKey = GlobalKey<FormState>();
  final _myStepsController = TextEditingController();

  final List<String> _ingredientsList = [];
  final List<String> _stepsList = [];


  void _saveIngredients(String? value) {
    setState(() { 
      _ingredientsList.add(value!);
    }); 
  }

  void _saveSteps(String? value) {
    setState(() { 
      _stepsList.add(value!);
    }); 
  }

  String? _textValidator(String? value) { 
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  void _sumbitIngredientInput() {
    if(_ingredientKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success!'),
        )
      );   
      _ingredientKey.currentState!.save();
      _myIngredientController.clear();
      
    }
  }

  void _sumbitStepsInput() {
    if(_stepsKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success!'),
        )
      );   
      _stepsKey.currentState!.save();
      _myStepsController.clear();
      
    }
  }



  File? _image;
  String imageURL = "";

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() async {
    if(photo != null){
      _image = File(photo.path);
    } else{
      if (kDebugMode) {
        print('No photo captured');
      }
      return;
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages=referenceRoot.child('images');
    String unique = DateTime.now().microsecondsSinceEpoch.toString();


    Reference referenceImageToUpload=referenceDirImages.child(unique);

    try {
      await referenceImageToUpload.putFile(File(photo.path));
      imageURL = await referenceImageToUpload.getDownloadURL();

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        )
      );
      
    }
    
  });

  }




  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create your own Recipe!"),
      ), 
      body: SingleChildScrollView(
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _titleKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _myTitleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          labelText: 'Title',
                        ),
                        validator: _textValidator,
                      ),
                    ),
                  ],
                ),
              ),
            
              Form(
                key: _ingredientKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _myIngredientController,
                        decoration: const InputDecoration(
                          hintText: 'Add Ingredient used 1 at a time',
                          labelText: 'Ingredients',
                        ),
                        onSaved: _saveIngredients,
                        validator: _textValidator,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sumbitIngredientInput,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              
              ListView.builder(
                itemCount: _ingredientsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_ingredientsList[index]),
                      //tileColor: Color.fromARGB(255, 181, 178, 205),
                      onTap: () {
                        setState(() {
                          _ingredientsList.remove(_ingredientsList[index]);
                        });
                      },
                      
                    ),
                  );
                },
              ),


               Form(
                key: _stepsKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _myStepsController,
                        decoration: const InputDecoration(
                          hintText: 'Add steps 1 at a time',
                          labelText: 'Steps',
                        ),
                        onSaved: _saveSteps,
                        validator: _textValidator,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sumbitStepsInput,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              
              ListView.builder(
                itemCount: _stepsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_stepsList[index]),
                      //tileColor: Color.fromARGB(255, 181, 178, 205),
                      onTap: () {
                        setState(() {
                          _stepsList.remove(_stepsList[index]);
                        });
                      },
                      
                    ),
                  );
                },
              ),
            
            ElevatedButton(
                onPressed: _getImage, 
                child: const Icon(Icons.add_a_photo)
              )
            ]
            )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Map<String, dynamic> recipe = {
              'Image': imageURL,
              'Ingredients': _ingredientsList,
              'Steps': _stepsList,
              'Title' : _myTitleController.text
              
            };
          try {
              if(imageURL == "" && _myTitleController.text.isEmpty &&
                  _ingredientsList.isEmpty && _stepsList.isEmpty
              ) {
                throw ErrorDescription("Missing Field");
              }

              if(imageURL == "") {
                 throw ErrorDescription("Missing Picture");
              }
              if(_myTitleController.text.isEmpty) {
                 throw ErrorDescription("Missing Title");
              }
              if(_ingredientsList.isEmpty) {
                 throw ErrorDescription("Missing Ingredients");
              }

              if(_stepsList.isEmpty) {
                 throw ErrorDescription("Missing Ingredients");
              }

            _recipesStorage!.writeRecipe(recipe);
            Navigator.pop(context);
            
          }catch (error) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              )
            );
          }
         
        },
        child: const Icon(Icons.check),
        ),
    );
  }

}
