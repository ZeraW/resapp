import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/server/menu_manage.dart';
import 'package:resapp/ui_screens/restaurant/food_items.dart';
import 'package:resapp/ui_screens/user/user_cart.dart';
import 'package:resapp/ui_widget/appbar_search.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/ui_widget/show_cart.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

import '../home.dart';

class MenuRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<DocumentSnapshot?>(context);
    final mCategoryList = Provider.of<List<CategoryModel>?>(context);

    final food = Provider.of<List<FoodModel>?>(context);

   /* if (food != null) print('${food[0].name}');*/

    return SafeArea(
      child: restaurantData != null && mCategoryList != null
          ? Responsive(
              mobile: ChangeNotifierProvider(
                  create: (context) => MenuManage(
                      allCategory: mCategoryList,
                      restaurant:
                          RestaurantModel.fromJson(restaurantData.data()!)),
                  child: UserMobMenu()),
              tablet: UserWebMenu(),
              desktop: UserWebMenu())
          : SizedBox(),
    );
  }
}

class UserWebMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

class UserMobMenu extends StatefulWidget {
  @override
  _UserMobMenuState createState() => _UserMobMenuState();
}

class _UserMobMenuState extends State<UserMobMenu> {
  @override
  Widget build(BuildContext context) {
    //print('rebuild M');
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(),
      ),
      body: ListView(
        children: [
          selectOrderType(),
          MultiProvider(
            providers: [
              StreamProvider<List<FoodModel>?>.value(
                  initialData: null,
                  value: DatabaseService().queryLiveFood(
                      category: context
                          .select<MenuManage, CategoryModel>(
                              (menu) => menu.selectedCategory!)
                          .id!,
                      restaurant: context
                          .select<MenuManage, RestaurantModel>(
                              (menu) => menu.restaurant!)
                          .id!)),
              StreamProvider<CartModel?>.value(
                  initialData: null, value: DatabaseService().getMyCart)
            ],
            child: MenuList(),
          ),
        ],
      ),
    );
  }

  Widget selectOrderType() {
    return Container(
      height: 100,
      child: Material(
        elevation: 2.0,
        color: MyColors().mainColor,
        child: Center(
          child: Consumer<MenuManage>(builder: (context, menu, child) {
            return ListView.builder(
                itemCount: menu.restaurant!.categoryList!.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (ctx, index) {
                  CategoryModel category = menu.myCategory![index];
                  return CategoryItem(
                      image: category.image!,
                      title: category.name!,
                      selected: menu.selectedCategory,
                      id: category.id!,
                      onTap: () {
                        menu.selectCategory(category);
                      });
                });
          }),
        ),
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  List<FoodModel> holderList = [];
  @override
  Widget build(BuildContext context) {
    final mCart = Provider.of<CartModel?>(context);
    final menuList = Provider.of<List<FoodModel>?>(context);
    if (menuList != null && menuList.isNotEmpty) {
      holderList.addAll(menuList);
      menuList.clear();
      Future.delayed(Duration.zero, () async {
        Provider.of<MenuManage>(context, listen: false).saveFood(holderList);
      });
     // print('hola');
    }
    return Consumer<MenuManage>(builder: (context, menu, child) {

      return ListView.builder(
          itemCount: menu.searchList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (ctx, index) {
            FoodModel food = menu.searchList[index];

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return RestaurantMenuItem(
                      title: '${food.name!}',
                      subTitle: '${food.details!}',
                      priceList: food.price!,
                      image: food.image!,
                      cart: mCart,
                      food: food,

                      add: (price) async {

                        HomeScreen.checkIfAnonymous(context,()async{
                          await menu.addItemToCart(food,mCart,price);
                          ShowCart(context).showCartDialog(onTap: (){
                            BotToast.removeAll('cart');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserCart()));
                          });
                        });

                      },
                      remove: (price) {
                        HomeScreen.checkIfAnonymous(context,()async{
                          menu.removeFromCart(food,mCart,price);
                          ShowCart(context).showCartDialog(onTap: (){
                            BotToast.removeAll('cart');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserCart()));
                          });
                        });

                      },
                      currentPrice: (price) {
                      },);
                }
              ),
            );
          });
    });
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSearchBar(
      label: "RESTAURANT",
      labelStyle: TextStyle(fontSize: 16),
      centerLabel: true,
      searchStyle: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      searchDecoration: InputDecoration(
        hintText: "Search...",
        alignLabelWithHint: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        Provider.of<MenuManage>(context, listen: false).search(value);
      },
    );
  }
}
