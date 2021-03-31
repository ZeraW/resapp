import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resapp/wrapper.dart';

import '../models/db_model.dart';

class DatabaseService {
  // Users collection reference
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('Users');
  final CollectionReference restaurantCollection =
  FirebaseFirestore.instance.collection('Restaurant');
  final CollectionReference categoryCollection =
  FirebaseFirestore.instance.collection('Category');
  final CollectionReference citiesCollection =
  FirebaseFirestore.instance.collection('Cities');
  final CollectionReference foodCollection =
  FirebaseFirestore.instance.collection('Food');
  CollectionReference queryFoodRef =
  FirebaseFirestore.instance.collection('Food');

/////////////////////////////////// User ///////////////////////////////////
  //get my user
  Stream<DocumentSnapshot> get getUserById {
    return userCollection.doc(Wrapper.UID).snapshots();
  }

  Stream<List<UserModel>> getLiveUsers(String id) {
    return userCollection.where('restaurantId', isEqualTo: id).snapshots().map(UserModel().fromQuery);
  }

  //upload Image method
  Future uploadImageToStorage({required File file, String? id}) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('images/$id.png');

    firebase_storage.UploadTask task = ref.putFile(file);

    /*task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });*/

    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url = await FirebaseStorage.instance
          .ref('images/${id}.png')
          .getDownloadURL();

      return url;
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  //updateUserData
  Future<void> updateUserData({required UserModel user}) async {
    return await userCollection.doc(user.id).set(user.toJson());
  }

/////////////////////////////////// User ///////////////////////////////////


  /// //////////////////////////////// City //////////////////////////////// ///
  //add new City

  Future addCity({required CityModel newCity}) async {
    var ref = citiesCollection.doc(newCity.id.toString());
    return await ref.set(newCity.toJson());
  }

  //update existing car
  Future updateCity({required CityModel updatedCity}) async {
    return await citiesCollection
        .doc(updatedCity.id.toString())
        .update(updatedCity.toJson());
  }

  //delete existing car
  Future deleteCity({required CityModel deleteCity}) async {
    return await citiesCollection.doc(deleteCity.id.toString()).delete();
  }

  // stream for live cars
  Stream<List<CityModel>> get getLiveCities {
    return citiesCollection.snapshots().map(CityModel().fromQuery);
  }

  /// //////////////////////////////// City //////////////////////////////// ///

/////////////////////////////////// CATEGORY ///////////////////////////////////
  //add new category
  Future addCategory(
      {required CategoryModel newCategory, required File imageFile}) async {
    var ref = categoryCollection.doc();
    newCategory.image = await (DatabaseService().uploadImageToStorage(
        id: 'category/${ref.id}', file: imageFile));
    newCategory.id = ref.id;
    return await ref.set(newCategory.toJson());
  }

  //update existing category
  Future updateCategory(
      {required CategoryModel updatedCategory, File? imageFile}) async {
    imageFile != null ? updatedCategory.image =
    await (DatabaseService().uploadImageToStorage(
        id: 'category/${updatedCategory.id}', file: imageFile)):null;
    return await categoryCollection.doc(updatedCategory.id).update(
        updatedCategory.toJson());
  }

  //delete existing category
  Future deleteCategory({required CategoryModel deleteCategory}) async {
    return await categoryCollection.doc(deleteCategory.id).delete();
  }

  // stream for live category
  Stream<List<CategoryModel>> get getLiveCategories {
    return categoryCollection.snapshots().map(CategoryModel().fromQuery);
  }

/////////////////////////////////// CATEGORY ///////////////////////////////////


/// //////////////////////////////// Restaurant ///////////////////////////////////
  //add new restaurant
  Future addRestaurant(
      {required RestaurantModel newRestaurant, required File imageFile}) async {
    var ref = restaurantCollection.doc();
    newRestaurant.image = await (DatabaseService().uploadImageToStorage(
        id: 'restaurant/${ref.id}', file: imageFile));
    newRestaurant.id = ref.id;
    return await ref.set(newRestaurant.toJson());
  }

  //update existing restaurant
  Future updateRestaurant(
      {required RestaurantModel updatedRestaurant, File? imageFile}) async {
    imageFile != null ? updatedRestaurant.image =
    await (DatabaseService().uploadImageToStorage(
        id: 'restaurant/${updatedRestaurant.id}', file: imageFile)):null;
    return await restaurantCollection.doc(updatedRestaurant.id).update(
        updatedRestaurant.toJson());
  }

  //delete existing restaurant
  Future deleteRestaurant({required RestaurantModel deleteRestaurant}) async {
    return await restaurantCollection.doc(deleteRestaurant.id).delete();
  }

  // stream for live restaurant
  Stream<List<RestaurantModel>> get getLiveRestaurant {
    return restaurantCollection.snapshots().map(RestaurantModel().fromQuery);
  }

  //get my restaurant
  Stream<DocumentSnapshot> getRestaurantById(String? id) {
    return restaurantCollection.doc(id).snapshots();
  }

/// //////////////////////////////// Restaurant ///////////////////////////////////

/////////////////////////////////// FOOD ///////////////////////////////////
  //add new food
  Future addFood(
      {required FoodModel newFood, required File imageFile}) async {
    var ref = foodCollection.doc();
    newFood.image = await (DatabaseService().uploadImageToStorage(
        id: 'food/${ref.id}', file: imageFile));
    newFood.id = ref.id;
    return await ref.set(newFood.toJson());
  }

  //update existing food
  Future updateFood(
      {required FoodModel updatedFood, File? imageFile}) async {
    imageFile != null ? updatedFood.image =
    await (DatabaseService().uploadImageToStorage(
        id: 'food/${updatedFood.id}', file: imageFile)):null;
    return await foodCollection.doc(updatedFood.id).update(
        updatedFood.toJson());
  }

  //delete existing food
  Future deleteFood({required FoodModel deleteFood}) async {
    return await foodCollection.doc(deleteFood.id).delete();
  }

  // stream for live food
  Stream<List<FoodModel>> get getLiveFood {
    return foodCollection.snapshots().map(FoodModel().fromQuery);
  }

  // query for live trips
  Stream<List<FoodModel>>  queryLiveFood({required String category,required String restaurant}) {
    return foodCollection
        .where('keyWords.restaurant', isEqualTo: restaurant)
        .where('keyWords.category', isEqualTo: category).snapshots().map(FoodModel().fromQuery);
  }

/////////////////////////////////// FOOD ///////////////////////////////////
 }
