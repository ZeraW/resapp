import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/ui_widget/drop_down.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class BaseItem extends StatelessWidget {
  final String? title, image;
  final Widget? child, subTitle;

  BaseItem({this.title, this.subTitle, this.image, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: Dimensions.getHeight(6),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.getWidth(1.5)),
                child: child,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: Dimensions.getHeight(6)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(1.5),
                  horizontal: Dimensions.getWidth(4)),
              title: Text(
                '$title',
                style: MyStyle().blackStyleW600(),
              ),
              trailing: Image.network(
                '$image',
              ),
              subtitle: subTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class BaseItemLeading extends StatelessWidget {
  final String? title, image;
  final Widget? child, subTitle;

  BaseItemLeading({this.title, this.subTitle, this.image, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: Dimensions.getHeight(6),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
                child: child,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: Dimensions.getHeight(6)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(1),
                  horizontal: Dimensions.getWidth(4)),
              title: Text(
                '$title',
                style: MyStyle().bigBold(),
              ),
              leading: Image.network(
                '$image',
                width: Dimensions.getWidth(14),
                height: Dimensions.getWidth(14),
                fit: BoxFit.cover,
              ),
              subtitle: subTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantFoodItem extends StatefulWidget {
  String? title, image, subTitle;
  List<PriceModel> priceList;
  Function(PriceModel?) currentPrice;
  Function() onEditTap, onDeleteTap;

  RestaurantFoodItem(
      {required this.title,
      required this.priceList,
      required this.image,
      this.subTitle = '',
      required this.onEditTap,
      required this.onDeleteTap,
      required this.currentPrice});

  @override
  _RestaurantFoodItemState createState() => _RestaurantFoodItemState();
}

class _RestaurantFoodItemState extends State<RestaurantFoodItem> {
  PriceModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (selectedItem == null) {
      selectedItem = widget.priceList[0];
    } else if (!widget.priceList.contains(selectedItem)) {
      selectedItem = widget.priceList[0];
    }

    return BaseItem(
      title: widget.title,
      image: widget.image,
      subTitle: Padding(
        padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
        child: Text('${widget.subTitle}'),
      ),
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          DropDownPriceList(
              mList: widget.priceList,
              selectedItem: selectedItem,
              onChange: (price) {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.currentPrice(price);
                setState(() {
                  selectedItem = price;
                });
              }),
          Spacer(),
          Text(
            '${widget.priceList.firstWhere((element) => element.size == selectedItem!.size, orElse: () => PriceModel(size: '', price: 0)).price}',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: Dimensions.getWidth(5),
          ),
          ElevatedButton(
            onPressed: widget.onEditTap,
            child: Text('Edit'),
            style: ButtonStyle(
                backgroundColor: MyColors.materialColor(Colors.amber)),
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: widget.onDeleteTap,
            child: Text('Delete'),
            style: ButtonStyle(
                backgroundColor: MyColors.materialColor(Colors.redAccent)),
          )
        ],
      ),
    );
  }
}

// add item select price
class BaseItemAdd extends StatelessWidget {
  final String? title, subTitle, imageUrl;
  final File? image;
  final Widget? child;

  BaseItemAdd(
      {this.title, this.subTitle, this.imageUrl, this.image, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: Dimensions.getHeight(6),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
              child: child,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: Dimensions.getHeight(6)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: Dimensions.getHeight(1.5),
                horizontal: Dimensions.getWidth(4)),
            title: Text(
              '$title',
              style: MyStyle().blackStyleW600(),
            ),
            trailing: imageUrl != null
                ? Image.network(imageUrl!)
                : Image.file(
                    image!,
                  ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
              child: Text('$subTitle'),
            ),
          ),
        ),
      ],
    );
  }
}

// add item
class RestaurantFoodItemAdd extends StatefulWidget {
  String? title, subTitle, imageUrl;
  File? image;
  List<PriceModel> priceList;
  PriceModel? selectedItem;
  Function(PriceModel?) currentPrice;
  Function() onEditTap, onDeleteTap;

  RestaurantFoodItemAdd(
      {required this.title,
      required this.priceList,
      required this.image,
      this.selectedItem,
      this.imageUrl,
      this.subTitle = '',
      required this.onEditTap,
      required this.onDeleteTap,
      required this.currentPrice});

  @override
  _RestaurantFoodItemAddState createState() => _RestaurantFoodItemAddState();
}

class _RestaurantFoodItemAddState extends State<RestaurantFoodItemAdd> {
  @override
  Widget build(BuildContext context) {
    return BaseItemAdd(
      title: widget.title,
      image: widget.image,
      imageUrl: widget.imageUrl,
      subTitle: widget.subTitle,
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          widget.priceList.isNotEmpty
              ? DropDownPriceList(
                  mList: widget.priceList,
                  selectedItem: widget.selectedItem,
                  onChange: (price) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    widget.currentPrice(price);
                    setState(() {
                      widget.selectedItem = price;
                    });
                  })
              : SizedBox(),
          Spacer(),
          widget.priceList.isNotEmpty
              ? Text(
                  '${widget.selectedItem!.price}',
                  style: TextStyle(color: Colors.white70),
                )
              : SizedBox(),
          SizedBox(
            width: Dimensions.getWidth(5),
          ),
          ElevatedButton(
            onPressed: widget.onEditTap,
            child: Text('Edit'),
            style: ButtonStyle(
                backgroundColor: MyColors.materialColor(Colors.amber)),
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: widget.onDeleteTap,
            child: Text('Delete'),
            style: ButtonStyle(
                backgroundColor: MyColors.materialColor(Colors.redAccent)),
          )
        ],
      ),
    );
  }
}

// restaurant items
class RestaurantUserCard extends StatelessWidget {
  final String? image, address, rateCount, rate, title;
  final Function() onTap,onRateTap;

  RestaurantUserCard(
      {this.image,
      this.address,
      this.rateCount,
      this.rate,
      this.title,
      required this.onTap , required this.onRateTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BaseItemLeading(
        image: image,
        title: title,
        subTitle: GestureDetector(
          onTap: onRateTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '$rate',
                          style: MyStyle().whiteStyleW600(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    )),
                SizedBox(
                  width: 10,
                ),
                Text('$rateCount People rated')
              ],
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '$address',
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}

// menu items
class RestaurantMenuItem extends StatefulWidget {
  String? title, image, subTitle;
  List<PriceModel> priceList;
  Function(PriceModel?)? currentPrice;
  Function(PriceModel) add, remove;
  FoodModel? food;
  CartModel? cart;

  RestaurantMenuItem(
      {required this.title,
      required this.priceList,
      required this.image,
      this.food,
      this.cart,
      this.subTitle = '',
      required this.currentPrice,
      required this.add,
      required this.remove});

  @override
  _RestaurantMenuItemState createState() => _RestaurantMenuItemState();
}

class _RestaurantMenuItemState extends State<RestaurantMenuItem> {
  PriceModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (selectedItem == null) {
      selectedItem = widget.priceList[0];
    } else if (!widget.priceList.contains(selectedItem)) {
      selectedItem = widget.priceList[0];
    }

    int currentItemCount(
        FoodModel food, CartModel? cart, PriceModel selectedPrice) {
      if (cart != null) {
        CartItemModel item = cart.cart!.firstWhere(
            (element) => element.id == food.id,
            orElse: () => CartItemModel(id: 'null'));
        if (item.id != 'null') {
          //if item exist in my cart
          PriceModel cartPrice = item.price!.firstWhere(
              (element) => element.size == selectedPrice.size,
              orElse: () => PriceModel(size: 'null552'));
          if (cartPrice.size != 'null552') {
            //size price already there
            return cartPrice.count!;
          } else {
            return 0;
          }
        } else {
          //if item do not exist in my cart
          return 0;
        }
      } else {
        return 0;
      }
    }

    return BaseItem(
      title: widget.title,
      image: widget.image,
      subTitle: Padding(
        padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
        child: Text('${widget.subTitle}'),
      ),
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          DropDownPriceList(
              mList: widget.priceList,
              selectedItem: selectedItem,
              onChange: (price) {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.currentPrice!(price);
                setState(() {
                  selectedItem = price;
                });
              }),
          Spacer(),
          Text(
            '${widget.priceList.firstWhere((element) => element.size == selectedItem!.size, orElse: () => PriceModel(size: '', price: 0)).price}',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: Dimensions.getWidth(2),
          ),
          FloatingActionButton(
            heroTag: 'addToCart${RandomStrings().get(3)}',
            onPressed: () => widget.add(selectedItem!),
            elevation: 0.0,
            child: Icon(
              Icons.add,
              color: MyColors().mainColor,
            ),
            backgroundColor: Colors.amberAccent,
          ),
          Text(
            '${widget.cart != null ? currentItemCount(widget.food!, widget.cart!, selectedItem!) : 0}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          FloatingActionButton(
            heroTag: 'removeFromCart${RandomStrings().get(3)}',
            onPressed: () => widget.remove(selectedItem!),
            elevation: 0.0,
            child: Icon(
              Icons.remove,
              color: MyColors().mainColor,
            ),
            backgroundColor: Colors.amberAccent,
          ),
        ],
      ),
    );
  }
}

// user order items
class UserOrderItem extends StatelessWidget {
  String? title, price, method, status;

  UserOrderItem({required this.title, this.price = '', this.method, this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: BaseItem(
        title: title,
        image:
            'https://firebasestorage.googleapis.com/v0/b/resturant-app-eb35e.appspot.com/o/images%2Ffood%2Faddress.png?alt=media&token=3bd2b329-6dd9-430f-b896-04cd39c3025c',
        subTitle: Padding(
          padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$price L.E'),
              SizedBox(
                height: 5,
              ),
              Text('Paid via $method'),
            ],
          ),
        ),
        child: Row(
          children: [
            Text(
              'Order Status',
              style: TextStyle(color: Colors.white70),
            ),
            Spacer(),
            Text(
              '$status',
              style: TextStyle(
                  color: Colors.amberAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


// user order items
class ResOrderItem extends StatelessWidget {
  String? title, price, method, status;
  Function() changeState;

  ResOrderItem({required this.title, this.price = '', this.method, this.status, required this.changeState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: BaseItem(
        title: title,
        image:
        'https://firebasestorage.googleapis.com/v0/b/resturant-app-eb35e.appspot.com/o/images%2Frestaurant%2Fcustomer.png?alt=media&token=47e0fced-4330-4f54-8753-4541a6e8e4af',
        subTitle: Padding(
          padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$price L.E'),
              SizedBox(
                height: 5,
              ),
              Text('Paid via $method'),
            ],
          ),
        ),
        child: Row(
          children: [
            Text(
              '',
              style: TextStyle(color: Colors.white70),
            ),
            Spacer(),
            ElevatedButton(onPressed: changeState, child: Text(
              '$status',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),style: ButtonStyle(backgroundColor: MyColors.materialColor(Colors.amberAccent)),),
          ],
        ),
      ),
    );
  }
}

// User menu items
class UserMenuItem extends StatefulWidget {
  String? title, image, subTitle;
  List<PriceModel> priceList;
  FoodModel? food;
  List<CartItemModel>? cart;

  UserMenuItem(
      {required this.title,
        required this.priceList,
        required this.image,
        this.food,
        this.cart,
        this.subTitle = '',
       });

  @override
  _UserMenuItemState createState() => _UserMenuItemState();
}

class _UserMenuItemState extends State<UserMenuItem> {
  PriceModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (selectedItem == null) {
      selectedItem = widget.priceList[0];
    } else if (!widget.priceList.contains(selectedItem)) {
      selectedItem = widget.priceList[0];
    }

    int currentItemCount(
        FoodModel food, List<CartItemModel>? cart, PriceModel selectedPrice) {
      if (cart != null) {
        CartItemModel item = cart.firstWhere(
                (element) => element.id == food.id,
            orElse: () => CartItemModel(id: 'null'));
        if (item.id != 'null') {
          //if item exist in my cart
          PriceModel cartPrice = item.price!.firstWhere(
                  (element) => element.size == selectedPrice.size,
              orElse: () => PriceModel(size: 'null552'));
          if (cartPrice.size != 'null552') {
            //size price already there
            return cartPrice.count!;
          } else {
            return 0;
          }
        } else {
          //if item do not exist in my cart
          return 0;
        }
      } else {
        return 0;
      }
    }

    return BaseItem(
      title: widget.title,
      image: widget.image,
      subTitle: Padding(
        padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
        child: Text('${widget.subTitle}'),
      ),
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          DropDownPriceList(
              mList: widget.priceList,
              selectedItem: selectedItem,
              onChange: (price) {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  selectedItem = price;
                });
              }),
          SizedBox(width: 20,),
          Text(
            'Count : ${widget.cart != null ? currentItemCount(widget.food!, widget.cart!, selectedItem!) : 0}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            '${widget.priceList.firstWhere((element) => element.size == selectedItem!.size, orElse: () => PriceModel(size: '', price: 0)).price}',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: Dimensions.getWidth(2),
          ),

        ],
      ),
    );
  }
}



class FoodItemWithPrices extends StatelessWidget {
  final String? title, image;
  final List<PriceModel>? prices;

  FoodItemWithPrices({this.title, this.prices, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: Dimensions.getHeight(2)),
        child: ListTile(
          title: Text(
            '$title',
            style: MyStyle().blackStyleW600(),
          ),
          trailing: Image.network(
            '$image',
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: prices!.map((item) => Padding(
                padding: EdgeInsets.only(top: 5,bottom: 5,right: 50),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text('${item.size}'),
                  Text('Quantity: ${item.count}'),
                  Text('${item.price}L.E'),
                ],),
              )).toList().cast<Widget>(),
            ),
          ),
        ),
      ),
    );
  }
}