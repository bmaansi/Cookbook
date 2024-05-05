import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';


class UserInfoStorage {
  UserInfoStorage();

  Future<void> addUserDetails(String uname, String fname, String lname, String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('Users').doc(email).set({
      'Username': uname,
      'First Name': fname,
      'Last Name': lname,
      'List': [],
      'Favorites': []
    }).then((value) {
        if(kDebugMode) {
          print("\nSUCCESSFUL\n");
        } 
    }).catchError((error) {
        if(kDebugMode) {
          print("\nERROR: $error\n");
        } 
    });
  }

}


class GroceryListStorage {
  GroceryListStorage();


  Future<void> writeList(String ingredients) async {
    // print("\nWRITING TO LIST\n");
    await Firebase.initializeApp(); 
    FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).update({
        'List': FieldValue.arrayUnion([ingredients])
      }).then((value) {
          if(kDebugMode) {
            print("WRITING SUCCESSFUL");
          } 
      }).catchError((error) {
          if(kDebugMode) {
            print("WRITING ERROR: $error");
          } 
      });
  }


  Future<void> removeList(String ingredients) async {
    await Firebase.initializeApp(); // Initialize Firebase if not done elsewhere

    FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).update({
        'List': FieldValue.arrayRemove([ingredients])
      }).then((value) {
          if(kDebugMode) {
            print("remcve successful");
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
    DocumentSnapshot ds = await firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).get();
    if(ds.exists) { // Check if document exists
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>? ?? {};
      if(data.containsKey('List') && data['List'] is List) { // Check if 'List' key exists and its value is a List
        return List<String>.from(data['List']);
      }
    }
    return [];
  }

}


class FavoritesStorage {
  FavoritesStorage();

   Future<void> writeFavorites(int id) async {
    // print("\nWRITING TO LIST\n");
    await Firebase.initializeApp(); 
    FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).update({
        'Favorites': FieldValue.arrayUnion([id])
      }).then((value) {
          if(kDebugMode) {
            print("WRITING SUCCESSFUL");
          } 
      }).catchError((error) {
          if(kDebugMode) {
            print("WRITING ERROR: $error");
          } 
      });
  }


  Future<void> removeFavorites(int id) async {
    await Firebase.initializeApp(); // Initialize Firebase if not done elsewhere

    FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).update({
        'Favorites': FieldValue.arrayRemove([id])
      }).then((value) {
          if(kDebugMode) {
            print("remcve successful");
          } 
      }).catchError((error) {
          if(kDebugMode) {
            print("remove error: $error");
          } 
      });
  }

  Future<List<int>> readFavorites() async {
    await Firebase.initializeApp(); 
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot ds = await firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.email!.trim()).get();
    if(ds.exists) { // Check if document exists
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>? ?? {};
      if(data.containsKey('Favorites') && data['Favorites'] is List) { // Check if 'List' key exists and its value is a List
        return List<int>.from(data['Favorites']);
      }
    }
    return [];
  }

}