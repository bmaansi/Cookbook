import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';


class EmailAgeStorage {
  EmailAgeStorage();

  Future<void> writeEmail(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('Authentication').doc('email').set({
      'Email': email,
    }).then((value) {
        if(kDebugMode) {
          print("email write successful");
        } 
    }).catchError((error) {
        if(kDebugMode) {
          print("writeEmail error: $error");
        } 
    });

  }

  Future<String> readEmail() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('Authentication').doc('email').get();
    if(ds.data() != null){
      Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
      if(data.containsKey('Email')){
        return data['Email'];
        
      }
    }
    return "";
  }

  Future<void> writePassword(String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('Authentication').doc('password').set({
      'Password': password,
    }).then((value) {
        if(kDebugMode) {
          print("password write successful");
        } 
    }).catchError((error) {
        if(kDebugMode) {
          print("writePassword error: $error");
        } 
    });

  }

  Future<String> readPassword() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('Authentication').doc('password').get();
    if(ds.data() != null){
      Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
      if(data.containsKey('Password')){
        return data['Password'];
        
      }
    }
    return "";
  }


}


class GroceryListStorage {
  GroceryListStorage();


  Future<void> writeList(List<String> ingredients) async {
    await Firebase.initializeApp(); // Initialize Firebase if not done elsewhere

    FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('GroceryList').doc('List').update({
        'List': FieldValue.arrayUnion(ingredients)
      }).then((value) {
          if(kDebugMode) {
            print(" write successful");
          } 
      }).catchError((error) {
          if(kDebugMode) {
            print("write error: $error");
          } 
      });
  }
  Future<void> removeList(String ingredients) async {
  await Firebase.initializeApp(); // Initialize Firebase if not done elsewhere

  FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('GroceryList').doc('List').update({
      'List': FieldValue.arrayRemove([ingredients])
    }).then((value) {
        if(kDebugMode) {
          print(" remcve successful");
        } 
    }).catchError((error) {
        if(kDebugMode) {
          print("remove error: $error");
        } 
    });
}


  Future<List<String>> readList() async {
    await Firebase.initializeApp(); 
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('GroceryList').doc('List').get();
    if(ds.exists) { // Check if document exists
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>? ?? {};
    if(data.containsKey('List') && data['List'] is List) { // Check if 'List' key exists and its value is a List
      return List<String>.from(data['List']);
    }
  }
    return [];
  }

}
