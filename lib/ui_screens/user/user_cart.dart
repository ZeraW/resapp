import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/server/menu_manage.dart';
import 'package:resapp/ui_screens/restaurant/food_items.dart';
import 'package:resapp/ui_screens/user/user_address.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/ui_widget/show_cart.dart';
import 'package:resapp/utils/utils.dart';

class UserCart extends StatefulWidget {
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  @override
  Widget build(BuildContext context) {
    //print('rebuild M');
    return WillPopScope(
      onWillPop: () async {
        BotToast.removeAll('usrCart');
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MY CART'),
        ),
        body: ListView(
          children: [
            MultiProvider(
              providers: [
                StreamProvider<List<FoodModel>?>.value(
                    initialData: null, value: DatabaseService().getLiveFood),
                StreamProvider<CartModel?>.value(
                    initialData: null, value: DatabaseService().getMyCart)
              ],
              child: CartList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  List<FoodModel> holderList = [];


  @override
  Widget build(BuildContext context) {
    final mCart = Provider.of<CartModel?>(context);
    final menuList = Provider.of<List<FoodModel>?>(context);

    ShowCart(context).showPaymentDialog(key: 'usrCart',onTap: () {
      placeOrder(mCart!,context);
    });
    return menuList != null && mCart != null
        ? ListView.builder(
            itemCount: mCart.cart != null ? mCart.cart!.length : 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (ctx, index) {
              PriceModel? placeHolderForPrice;
              FoodModel food = menuList.firstWhere(
                  (element) => element.id == mCart.cart![index].id,
                  orElse: () => FoodModel(
                      name: 'item deleted',
                      id: 'null',
                      details: '',
                      price: [],
                      restaurantId: '',
                      image: '',
                      category: ''));
              if (placeHolderForPrice == null) {
                placeHolderForPrice = food.price![0];
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: StatefulBuilder(builder: (context, setState) {
                  return RestaurantMenuItem(
                    title: '${food.name!}',
                    subTitle: '${food.details!}',
                    priceList: food.price!,
                    image: food.image!,
                    food: food,
                    cart: mCart,
                    add: (price) {
                      if (food.id != 'null') addItemToCart(food, mCart, price);
                     /* ShowCart(context).showPaymentDialog(onTap: () {
                        BotToast.removeAll('payment');
                        placeOrder(mCart,context);
                      });*/
                    },
                    remove: (price) {
                      if (food.id != 'null') removeFromCart(food, mCart, price);

                    },
                    currentPrice: (price) {
                      setState(() {
                        placeHolderForPrice = price;
                      });
                    },
                  );
                }),
              );
            })
        : SizedBox();
  }
  void placeOrder(CartModel cart,BuildContext context) async{
    OrderModel newOrder = OrderModel(
      totalCount: cart.totalCount,
      totalPrice: cart.totalPrice,
      cart: cart.cart,
      keyWords: getKeyWords(cart.cart!),
      orderStatus: getOrderStatus(cart.cart!),
      restaurantCart: getRestaurantCart(cart)
    );

    Navigator.push(context, MaterialPageRoute(builder: (_) => UserAddress(newOrder)));
    /*await DatabaseService().addOrder(newOrder: newOrder).then((value) async{
      await DatabaseService().deleteCart();
    });*/
  }
  Map<String, String> getKeyWords(List<CartItemModel> list) {
    Map<String, String> keyWords = {};
    keyWords.clear();
    for (CartItemModel item in list) {
      keyWords['${item.restaurantId}'] = 'true';
    }

  //  print(keyWords.toString());
    return keyWords;
  }
  Map<String, int> getOrderStatus(List<CartItemModel> list) {
    Map<String, int> orderStatus = {};
    orderStatus.clear();
    for (CartItemModel item in list) {
      orderStatus['${item.restaurantId}'] = 0;
    }
    orderStatus['all'] = 0;
    //print(orderStatus.toString());
    return orderStatus;
  }
  Map<String, dynamic> getRestaurantCart(CartModel cart) {
    Map<String, dynamic> restaurantCart = {};
    restaurantCart.clear();
    List<String> totalRes = [];
    // get all the restaurant
    for (CartItemModel item in cart.cart!) {if (!totalRes.contains(item.restaurantId!)) totalRes.add(item.restaurantId!);}

    print(totalRes);
    // loop through each one and get all the food items
    for (String res in totalRes) {
      List<CartItemModel> list = [];
      for (CartItemModel item in cart.cart!) {

        // add the items belongs to the restaurant
        if (item.restaurantId == res) list.add(item);
      }
      restaurantCart['$res'] = CartModel(
          cart: list,
          id: cart.id).toJson();
    }

   // print('ha ${restaurantCart.toString()}');
    return restaurantCart;
  }
  void addItemToCart(
      FoodModel food, CartModel? cart, PriceModel selectedPrice) async {
    if (cart != null) {
      CartItemModel item = cart.cart!.firstWhere(
          (element) => element.id == food.id,
          orElse: () => CartItemModel(id: 'null'));

      if (item.id != 'null') {
        //if item exist in my cart
        CartModel updatedCart = cart;
        PriceModel cartPrice = item.price!.firstWhere(
            (element) => element.size == selectedPrice.size,
            orElse: () => PriceModel(size: 'null552'));
        if (cartPrice.size != 'null552') {
          //size price already there
          cartPrice.count = cartPrice.count! + 1;
          await DatabaseService().updateCart(updatedCart: updatedCart);
        } else {
          //add new size
          selectedPrice.count = 1;
          int itemPosition = updatedCart.cart!.indexOf(item);
          item.price!.add(selectedPrice);
          updatedCart.cart![itemPosition] = item;
          await DatabaseService().updateCart(updatedCart: updatedCart);
        }
      } else {
        //if item do not exist in my cart
        selectedPrice.count = 1;
        CartItemModel newItem = CartItemModel(
            id: food.id,
            restaurantId: food.restaurantId,
            price: [selectedPrice]);
        CartModel newCart = cart;
        newCart.cart!.add(newItem);
        await DatabaseService().updateCart(updatedCart: newCart);
      }
    } else {
      selectedPrice.count = 1;
      CartModel newCart = CartModel(cart: [
        CartItemModel(
            restaurantId: food.restaurantId,
            id: food.id,
            price: [selectedPrice])
      ]);
      await DatabaseService().addCart(newCart: newCart);
    }
  }
  void removeFromCart(
      FoodModel food, CartModel? cart, PriceModel selectedPrice) async {
    if (cart != null) {
      CartItemModel item = cart.cart!.firstWhere(
          (element) => element.id == food.id,
          orElse: () => CartItemModel(id: 'null'));
      if (item.id != 'null') {
        //if item exist in my cart
        CartModel updatedCart = cart;
        PriceModel cartPrice = item.price!.firstWhere(
            (element) => element.size == selectedPrice.size,
            orElse: () => PriceModel(size: 'null552'));
        if (cartPrice.size != 'null552') {
          //size price already there
          if (cartPrice.count! > 1) {
            //reduce the item count by 1
            cartPrice.count = cartPrice.count! - 1;
            await DatabaseService().updateCart(updatedCart: updatedCart);
          }else if (cartPrice.count! == 1 && item.price!.length>1) {
            // remove the item
            int itemPosition = item.price!.indexOf(cartPrice);
            item.price!.removeAt(itemPosition);
            await DatabaseService().updateCart(updatedCart: updatedCart);
          } else if (cartPrice.count! == 1 && item.price!.length==1) {
            // remove the item
            int itemPosition = updatedCart.cart!.indexOf(item);
            updatedCart.cart!.removeAt(itemPosition);
            await DatabaseService().updateCart(updatedCart: updatedCart);
          }
        }
      }
    }
  }
}
