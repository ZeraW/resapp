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
          id: doc.data()['id'],
          password: doc.data()['password'],
          firstName: doc.data()['firstName'],
          lastName: doc.data()['lastName'],
          phone: doc.data()['phone'],
          type: doc.data()['type'],
          restaurantId: doc.data()['restaurantId'],
          logo: doc.data()['logo']);
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
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? '',
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
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? '',
        image: doc.data()['image'] ?? '',
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
  final Map<String, int>? rate;


  int getRateCount(){
    return this.rate!.length;
  }

  double getRate(){
    int rate = 0;
    for(var v in this.rate!.values) {
      rate = rate + v;
    }


    return this.rate!.length >0 ?rate/this.rate!.length:0;
  }
  RestaurantModel(
      {this.id,
      this.name,
      this.image,
      this.phone,this.rate,

        this.city,
      this.address,
      this.keyWords,
      this.categoryList});

  List<RestaurantModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RestaurantModel(
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? '',
        image: doc.data()['image'] ?? '',
        phone: doc.data()['phone'] ?? '',
        address: doc.data()['address'] ?? '',
        keyWords: Map<String, String>.from(doc.data()['keyWords']),
        rate: doc.data()['rate'] !=null ?Map<String, int>.from(doc.data()['rate']) : {},

        categoryList: List.from(doc.data()['categoryList']),
        city: doc.data()['city'] ?? '',
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
        rate = json['rate']!=null ? Map<String, int>.from(json['rate']): {},

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
    data['rate'] = this.rate;
    data['categoryList'] = this.categoryList;
    data['image'] = this.image;
    return data;
  }
}

class PriceModel {
  String? size;
  int? price, count;

  PriceModel({this.size, this.price, this.count});

  List<PriceModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PriceModel(
        size: doc.data()['size'] ?? '',
        price: doc.data()['price'] ?? 0,
        count: doc.data()['count'] ?? 0,
      );
    }).toList();
  }

  PriceModel.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        price = json['price'],
        count = json['count'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['price'] = this.price;
    data['count'] = this.count;
    return data;
  }
}

class FoodModel {
  String? id, restaurantId;
  String? name, image, details, category;
  List<PriceModel>? price;
  Map<String, String>? keyWords;

  FoodModel({
    this.id,
    this.name,
    this.image,
    this.restaurantId,
    this.details,
    this.category,
    this.price,
    this.keyWords,
  });

  List<FoodModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodModel(
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? '',
        image: doc.data()['image'] ?? '',
        restaurantId: doc.data()['restaurantId'] ?? '',
        details: doc.data()['details'] ?? '',
        keyWords: Map<String, String>.from(doc.data()['keyWords']),
        category: doc.data()['category'] ?? '',
        price: List.from(doc.data()['price'])
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
        price = List.from(json['price'])
            .map((data) => PriceModel.fromJson(data))
            .toList(),
        keyWords = Map<String, String>.from(json['keyWords']),
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

class CartModel {
  String? id;
  int? totalCount, totalPrice;
  List<CartItemModel>? cart;

  CartModel({this.id, this.cart, this.totalPrice, this.totalCount});

  int totalItemsCount(List<CartItemModel> cartItem) {
    int count = 0;
    for (CartItemModel i in cartItem) {
      count = count + i.itemCount(i.price!);
    }
    return count;
  }

  int totalItemsPrice(List<CartItemModel> cartItem) {
    int price = 0;
    for (CartItemModel i in cartItem) {
      price = price + i.totalPrice(i.price!);
    }
    return price;
  }

  List<CartModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CartModel(
        id: doc.data()['id'] ?? '',
        totalCount: doc.data()['totalCount'] ?? 0,
        totalPrice: doc.data()['totalPrice'] ?? 0,
        cart: List.from(doc.data()['cart'])
            .map((data) => CartItemModel.fromJson(data))
            .toList(),
      );
    }).toList();
  }

  CartModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        totalCount = json['totalCount'],
        totalPrice = json['totalPrice'],
        cart = List.from(json['cart'])
            .map((data) => CartItemModel.fromJson(data))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalPrice'] = totalItemsPrice(this.cart!);
    data['totalCount'] = totalItemsCount(this.cart!);
    data['cart'] = this.cart!.map((i) => i.toJson()).toList();
    return data;
  }
}

class CartItemModel {
  String? id, restaurantId;
  List<PriceModel>? price;

  CartItemModel({
    this.id,
    this.restaurantId,
    this.price,
  });

  int totalPrice(List<PriceModel> items) {
    int totalPrice = 0;
    for (PriceModel i in items) {
      totalPrice = totalPrice + (i.price! * i.count!);
    }
    return totalPrice;
  }

  int itemCount(List<PriceModel> items) {
    int count = 0;
    for (PriceModel i in items) {
      count = count + i.count!;
    }
    return count;
  }

  CartItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        restaurantId = json['restaurantId'],
        price = List.from(json['price'])
            .map((data) => PriceModel.fromJson(data))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['price'] = this.price!.map((i) => i.toJson()).toList();
    return data;
  }
}

class OrderModel {
  String? id, userId,userName, payment;
  int? totalCount, totalPrice;
  List<CartItemModel>? cart;
  Map<String, String>? keyWords;
  Map<String, int>? orderStatus;
  AddressModel? address;

  dynamic restaurantCart;

  OrderModel(
      {this.id,
      this.userId,
      this.payment,
      this.cart,this.userName,
      this.totalPrice,
      this.totalCount,
      this.address,
      this.orderStatus,
      this.keyWords,
      this.restaurantCart});

  List<OrderModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OrderModel(
        id: doc.data()['id'] ?? '',
        userName: doc.data()['userName'] ?? '',

        payment: doc.data()['payment'] ?? '',
        userId: doc.data()['userId'] ?? '',
        totalCount: doc.data()['totalCount'] ?? 0,
        totalPrice: doc.data()['totalPrice'] ?? 0,
        address: AddressModel.fromJson(doc.data()['address']),
        keyWords: Map<String, String>.from(doc.data()['keyWords']),
        orderStatus: Map<String, int>.from(doc.data()['orderStatus']),
        restaurantCart: doc.data()['restaurantCart'],
        cart: List.from(doc.data()['cart'])
            .map((data) => CartItemModel.fromJson(data))
            .toList(),
      );
    }).toList();
  }

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        userName = json['userName'],

      payment = json['payment'],
        totalCount = json['totalCount'],
        totalPrice = json['totalPrice'],
        address = AddressModel.fromJson(json['totalPrice']),
        keyWords = Map<String, String>.from(json['keyWords']),
        orderStatus = Map<String, int>.from(json['orderStatus']),
        restaurantCart = json['restaurantCart'],
        cart = List.from(json['cart'])
            .map((data) => CartItemModel.fromJson(data))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userName'] = this.userName;

    data['payment'] = this.payment;

    data['address'] = this.address!.toJson();
    data['totalPrice'] = this.totalPrice;
    data['totalCount'] = this.totalCount;
    data['cart'] = this.cart!.map((i) => i.toJson()).toList();
    data['keyWords'] = this.keyWords;
    data['orderStatus'] = this.orderStatus;
    data['restaurantCart'] = this.restaurantCart;
    return data;
  }
}

class AddressModel {
  String? id, address, phone, addressTitle;

  AddressModel({this.id, this.address, this.phone, this.addressTitle});

  List<AddressModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AddressModel(
        id: doc.data()['id'] ?? '',
        address: doc.data()['address'] ?? '',
        phone: doc.data()['phone'] ?? '',
        addressTitle: doc.data()['addressTitle'] ?? '',
      );
    }).toList();
  }

  AddressModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        address = json['address'],
        phone = json['phone'],
        addressTitle = json['addressTitle'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['addressTitle'] = this.addressTitle;
    return data;
  }
}

class ReportModel {
  final String? id;
  Map<String, int>? report;

  ReportModel({this.id, this.report});

  List<ReportModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ReportModel(
        id: doc.data()['id'] ?? '',
        report: doc.data()['report'] != null
            ? Map<String, int>.from(doc.data()['report'])
            : {},
      );
    }).toList();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report'] = this.report;
    return data;
  }

  ReportModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        report = json['report'] != null
            ? Map<String, int>.from(json['report'])
            : {};
}
