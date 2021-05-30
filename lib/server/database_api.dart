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
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Cart');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Order');
  CollectionReference queryFoodRef =
      FirebaseFirestore.instance.collection('Food');

/////////////////////////////////// User ///////////////////////////////////
  //get my user
  Stream<DocumentSnapshot> get getUserById {
    return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  }


  Stream<UserModel> get getUserById2 {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Stream<List<UserModel>> getLiveUsers(String id) {
    return userCollection
        .where('restaurantId', isEqualTo: id)
        .snapshots()
        .map(UserModel().fromQuery);
  }

  //upload Image method
  Future uploadImageToStorage({required File file, String? id}) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('images/$id.png');

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
    newCategory.image = await (DatabaseService()
        .uploadImageToStorage(id: 'category/${ref.id}', file: imageFile));
    newCategory.id = ref.id;
    return await ref.set(newCategory.toJson());
  }

  //update existing category
  Future updateCategory(
      {required CategoryModel updatedCategory, File? imageFile}) async {
    imageFile != null
        ? updatedCategory.image = await (DatabaseService().uploadImageToStorage(
            id: 'category/${updatedCategory.id}', file: imageFile))
        : null;
    return await categoryCollection
        .doc(updatedCategory.id)
        .update(updatedCategory.toJson());
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
    newRestaurant.image = await (DatabaseService()
        .uploadImageToStorage(id: 'restaurant/${ref.id}', file: imageFile));
    newRestaurant.id = ref.id;
    return await ref.set(newRestaurant.toJson());
  }

  //update existing restaurant
  Future updateRestaurant(
      {required RestaurantModel updatedRestaurant, File? imageFile}) async {
    imageFile != null
        ? updatedRestaurant.image = await (DatabaseService()
            .uploadImageToStorage(
                id: 'restaurant/${updatedRestaurant.id}', file: imageFile))
        : null;
    return await restaurantCollection
        .doc(updatedRestaurant.id)
        .update(updatedRestaurant.toJson());
  }

  //delete existing restaurant
  Future deleteRestaurant({required RestaurantModel deleteRestaurant}) async {
    return await restaurantCollection.doc(deleteRestaurant.id).delete();
  }

  // stream for live restaurant
  Stream<List<RestaurantModel>> get getLiveRestaurant {
    return restaurantCollection.snapshots().map(RestaurantModel().fromQuery);
  }

  // stream for live restaurant byCity
  Stream<List<RestaurantModel>> getLiveRestaurantByCity(String cityId) {
    return restaurantCollection
        .where('city', isEqualTo: cityId)
        .snapshots()
        .map(RestaurantModel().fromQuery);
  }

  // stream for live restaurant
  Stream<List<RestaurantModel>> getLiveRestaurantByCityAndCategory(
      String cityId, String category) {
    return restaurantCollection
        .where('keyWords.city', isEqualTo: cityId)
        .where('keyWords.$category', isEqualTo: 'true')
        .snapshots()
        .map(RestaurantModel().fromQuery);
  }

  //get my restaurant
  Stream<DocumentSnapshot> getRestaurantById(String? id) {
    return restaurantCollection.doc(id).snapshots();
  }




  //rate restaurant
  Future rateRestaurant({required RestaurantModel rateRes,required int ratting}) async {
    return await restaurantCollection.doc(rateRes.id).update({
      'rate.${FirebaseAuth.instance.currentUser!.uid}': ratting
    });
  }
  ///add item to array
/* return await carsCollection.doc(updatedCar.id).update({
  'upvoters': FieldValue.arrayUnion(['12345'])
  });*/

  ///remove item from array
/* return await carsCollection.doc(updatedCar.id).update({
  'user_fav': FieldValue.arrayRemove(['12345'])
  });*/


  /// //////////////////////////////// Restaurant ///////////////////////////////////

/////////////////////////////////// FOOD ///////////////////////////////////
  //add new food
  Future addFood({required FoodModel newFood, required File imageFile}) async {
    var ref = foodCollection.doc();
    newFood.image = await (DatabaseService()
        .uploadImageToStorage(id: 'food/${ref.id}', file: imageFile));
    newFood.id = ref.id;
    return await ref.set(newFood.toJson());
  }

  //update existing food
  Future updateFood({required FoodModel updatedFood, File? imageFile}) async {
    imageFile != null
        ? updatedFood.image = await (DatabaseService().uploadImageToStorage(
            id: 'food/${updatedFood.id}', file: imageFile))
        : null;
    return await foodCollection
        .doc(updatedFood.id)
        .update(updatedFood.toJson());
  }

  //delete existing food
  Future deleteFood({required FoodModel deleteFood}) async {
    return await foodCollection.doc(deleteFood.id).delete();
  }

  // stream for live food
  Stream<List<FoodModel>> get getLiveFood {
    return foodCollection.snapshots().map(FoodModel().fromQuery);
  }

  Future<List<FoodModel>> getFoodByListOfIds(List<String> idsList) async {
    List<DocumentSnapshot> futureList = [];
    for (String id in idsList) {
      futureList.add(await foodCollection.doc(id).get());
    }
    //  List<FoodModel> list = futureList.map((e) => FoodModel.fromJson(e.data()!)).toList();
    return futureList.map((e) => FoodModel.fromJson(e.data()!)).toList();
  }

  Stream<List<FoodModel>> foodByIds(List<String> idsList) {
    return Stream.fromFuture(getFoodByListOfIds(idsList));
  }

  // query for live trips
  Stream<List<FoodModel>> queryLiveFood(
      {required String category, required String restaurant}) {
    //print('req');
    return foodCollection
        .where('keyWords.restaurant', isEqualTo: restaurant)
        .where('keyWords.category', isEqualTo: category)
        .snapshots()
        .map(FoodModel().fromQuery);
  }

/////////////////////////////////// FOOD ///////////////////////////////////
  /// //////////////////////////////// CART ///////////////////////////////////
  //add new restaurant
  Future addCart({required CartModel newCart}) async {
    newCart.id = FirebaseAuth.instance.currentUser!.uid;
    return await cartCollection.doc(newCart.id).set(newCart.toJson());
  }

  ///add item to array
/* return await carsCollection.doc(updatedCar.id).update({
  'upvoters': FieldValue.arrayUnion(['12345'])
  });*/

  ///remove item from array
/* return await carsCollection.doc(updatedCar.id).update({
  'user_fav': FieldValue.arrayRemove(['12345'])
  });*/

  //delete existing cart
  Future deleteCart() async {
    CartModel updatedCart = CartModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        totalCount: 0,
        totalPrice: 0,
        cart: []);
    return await cartCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(updatedCart.toJson());
  }

  //update existing restaurant
  Future updateCart({required CartModel updatedCart}) async {
    return await cartCollection
        .doc(updatedCart.id)
        .update(updatedCart.toJson());
  }

  //get my Cart
  Stream<CartModel> get getMyCart {
    return cartCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) => CartModel.fromJson(event.data()!));
  }

  /// //////////////////////////////// CART ///////////////////////////////////

/////////////////////////////////// ORDER ///////////////////////////////////
  //add new restaurant
  Future addOrder({required OrderModel newOrder}) async {
    var ref = orderCollection.doc();
    newOrder.id = ref.id;
    newOrder.userId = FirebaseAuth.instance.currentUser!.uid;
    return await ref.set(newOrder.toJson());
  }


  //update existing restaurant
  Future updateOrder({required OrderModel updatedOrder}) async {
    return await orderCollection
        .doc(updatedOrder.id)
        .update(updatedOrder.toJson());
  }


  //changeOrderStatusResOnly
  Future changeOrderStatusResOnly({required String myOrder,required String resId,required int status}) async {
    return await orderCollection.doc(myOrder).update({
      'orderStatus.$resId': status
    });
  }

  //changeOrderStatusAll
  Future changeOrderStatusAll({required String myOrder,required String resId,required int status}) async {
    return await orderCollection.doc(myOrder).update({
      'orderStatus.$resId': status,
      'orderStatus.all': status
    });
  }


  //get my Order user
  Stream<List<OrderModel>>  getMyOrder(int status) {
    if(status == 3){
      return orderCollection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('orderStatus.all',isEqualTo: 3)
          .snapshots()
          .map(OrderModel().fromQuery);
    }else {
      return orderCollection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('orderStatus.all',isLessThan: 3)
          .snapshots()
          .map(OrderModel().fromQuery);
    }

  }


  //get my Order restaurant
  Stream<List<OrderModel>>  getRestaurantOrder({required String resId, required int status}) {


    return orderCollection
        .where('keyWords.${resId}',isEqualTo: 'true')
        .where('orderStatus.${resId}',isEqualTo: status)
        .snapshots()
        .map(OrderModel().fromQuery);

  }



/////////////////////////////////// ORDER ///////////////////////////////////

  /// //////////////////////////////// ADDRESS ///////////////////////////////////
  //add new address
  Future addAddress({required AddressModel newAddress}) async {
    var ref = userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('address').doc();
    newAddress.id = ref.id;
    return await ref.set(newAddress.toJson());
  }

  //update existing address
  Future updateAddress({required AddressModel updatedAddress}) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .doc(updatedAddress.id)
        .update(updatedAddress.toJson());
  }

  //delete existing address
  Future deleteAddress({required AddressModel deleteAddress}) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .doc(deleteAddress.id)
        .delete();
  }

  // stream for live address
  Stream<List<AddressModel>> get getLiveAddress {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .snapshots()
        .map(AddressModel().fromQuery);
  }

  /// //////////////////////////////// ADDRESS ///////////////////////////////////

}
