import 'package:flutter/material.dart';
import 'dart:async';
import '../firestorage.dart';


class MyListPage extends StatefulWidget {
  const MyListPage({super.key});
  

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
 GroceryListStorage? _storage;
  _MyListPageState() {
    _storage = GroceryListStorage(); 
  }
  final _formKey = GlobalKey<FormState>();
  final _myInputController = TextEditingController();
  List<String> _ingredients = [];
  
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _myInputController.dispose();
    super.dispose();
  }


  Future<void> _saveText(String? value) async {
    setState(() {
      _ingredients.add(value!);
    });
    await _storage?.writeList(_ingredients);

    
  }

 

  void _sumbitInput() {
    if(_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success!'),
        )
      );   
      _formKey.currentState!.save();
      _myInputController.clear();
      
    }
  }


  String? _textValidator(String? value) { 
    if (value == null || value.isEmpty) {
      return 'Please enter ingredient';
    }
    return null;
  }
  
  Future<List<String>> getData() async {
    return _storage!.readList();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _myInputController,
                        decoration: const InputDecoration(
                          hintText: 'Add an Ingredient/Grocery Item',
                          labelText: 'Grocery List',
                        ),
                        onSaved: _saveText,
                        validator: _textValidator,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sumbitInput,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<String>>(
                future: getData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7, // Set a fixed height or use constraints
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(snapshot.data![index]),
                                  //tileColor: Color.fromARGB(255, 181, 178, 205),
                                  onTap: () {
                                    _storage!.removeList(snapshot.data![index]).then((_) {
                                      setState(() {
                                        // Clear the list to trigger a rebuild
                                        _ingredients = [];
                                      });
                                    });
                                  },
                                  
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

      
    );
  }

}
