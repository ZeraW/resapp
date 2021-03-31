import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id, password, firstName, lastName, phone, logo, type, restaurantId;

  UserModel(
      {this.id,
      this.password,
      this.firstName,
      this.lastName,
      this.phone,
      this.restaurantId,
      this.logo,
      this.type});

  List<UserModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          id: doc.data()!['id'],
          password: doc.data()!['password'],
          firstName: doc.data()!['firstName'],
          lastName: doc.data()!['lastName'],
          phone: doc.data()!['phone'],
          type: doc.data()!['type'],
          restaurantId: doc.data()!['restaurantId'],
          logo: doc.data()!['logo']);
    }).toList();
  }

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.data()!['id'],
        password = doc.data()!['password'],
        firstName = doc.data()!['firstName'],
        lastName = doc.data()!['lastName'],
        phone = doc.data()!['phone'],
        type = doc.data()!['type'],
        restaurantId = doc.data()!['restaurantId'],
        logo = doc.data()!['logo'];

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        restaurantId = json['restaurantId'],
        phone = json['phone'],
        type = json['type'],
        logo = json['logo'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'restaurantId': restaurantId,
      'phone': phone,
      'logo': logo,
      'type': type,
    };
  }
}

class CityModel {
  final String? id;
  final String? name;

  CityModel({this.id, this.name});

  List<CityModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CityModel(
        id: doc.data()!['id'] ?? '',
        name: doc.data()!['name'] ?? '',
      );
    }).toList();
  }

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CategoryModel {
  String? id;
  String? name, image;

  CategoryModel({this.id, this.name, this.image});

  List<CategoryModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CategoryModel(
        id: doc.data()!['id'] ?? '',
        name: doc.data()!['name'] ?? '',
        image: doc.data()!['image'] ?? '',
      );
    }).toList();
  }

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class RestaurantModel {
  String? id;
  String? name, image, phone, city, address;
  List<String>? categoryList;
  final Map<String, String>? keyWords;

  RestaurantModel(
      {this.id,
      this.name,
      this.image,
      this.phone,
      this.city,
      this.address,
      this.keyWords,
      this.categoryList});

  List<RestaurantModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RestaurantModel(
        id: doc.data()!['id'] ?? '',
        name: doc.data()!['name'] ?? '',
        image: doc.data()!['image'] ?? '',
        phone: doc.data()!['phone'] ?? '',
        address: doc.data()!['address'] ?? '',
        keyWords: Map<String, String>.from(doc.data()!['keyWords']),
        categoryList: List.from(doc.data()!['categoryList']),
        city: doc.data()!['city'] ?? '',
      );
    }).toList();
  }

  RestaurantModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phone = json['phone'],
        city = json['city'],
        address = json['address'],
        keyWords = Map<String, String>.from(json['keyWords']),
        categoryList = List.from(json['categoryList']),
        image = json['image'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['address'] = this.address;
    data['keyWords'] = this.keyWords;
    data['categoryList'] = this.categoryList;
    data['image'] = this.image;
    return data;
  }
}

class PriceModel {
  String? size;
  int? price;

  PriceModel({this.size, this.price});

  List<PriceModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PriceModel(
        size: doc.data()!['size'] ?? '',
        price: doc.data()!['price'] ?? 0,
      );
    }).toList();
  }

  PriceModel.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['price'] = this.price;
    return data;
  }
}

class FoodModel {
  String? id,restaurantId;
  String? name, image, details, category;
  List<PriceModel>? price;
  Map<String, String>? keyWords;

  FoodModel(
      {this.id,
        this.name,
        this.image,
        this.restaurantId,
        this.details,
        this.category,
        this.price,
        this.keyWords,});

  List<FoodModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodModel(
        id: doc.data()!['id'] ?? '',
        name: doc.data()!['name'] ?? '',
        image: doc.data()!['image'] ?? '',
        restaurantId: doc.data()!['restaurantId'] ?? '',

        details: doc.data()!['details'] ?? '',
        keyWords: Map<String, String>.from(doc.data()!['keyWords']),
        category: doc.data()!['category'] ?? '',
        price: List.from(doc.data()!['price'])
            .map((data) => PriceModel.fromJson(data))
            .toList(),
      );
    }).toList();
  }

  FoodModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        details = json['details'],
        restaurantId = json['restaurantId'],

      category = json['category'],
        price = json['price'],
      keyWords = json['keyWords'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['details'] = this.details;
    data['restaurantId'] = this.restaurantId;

    data['category'] = this.category;
    data['price'] = this.price!.map((i) => i.toJson()).toList();

    data['keyWords'] = this.keyWords;
    data['image'] = this.image;
    return data;
  }
}
