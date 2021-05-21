import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/restaurant_menu.dart';
import 'package:resapp/ui_screens/user/restaurant_search.dart';
import 'package:resapp/ui_widget/ratting.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/ui_widget/show_cart.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class RestaurantNearYou extends StatelessWidget {
  List<CityModel> mCityList;
  String currentCity;

  RestaurantNearYou(this.mCityList, this.currentCity);

  @override
  Widget build(BuildContext context) {
    final restaurantList = Provider.of<List<RestaurantModel>?>(context);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: Dimensions.getWidth(6),
            ),
            Text(
              'Restaurants Near You',
              style: MyStyle().whiteStyleW600(),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: 'SearchRestaurant',),
                        builder: (_) => SearchRestaurant(
                            mCityList: mCityList,
                            restaurantList: restaurantList)));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.getHeight(4)),
                        bottomLeft: Radius.circular(Dimensions.getHeight(4)))),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.getHeight(2),
                    horizontal: Dimensions.getWidth(6)),
                child: Text(
                  'See More',
                  style: MyStyle().blackStyleW600(),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        restaurantList != null
            ? RestaurantList(
                restaurantList: restaurantList, mCityList: mCityList, count: 3)
            : SizedBox()
      ],
    );
  }
}

class RestaurantList extends StatelessWidget {
  List<RestaurantModel> restaurantList;
  List<CityModel> mCityList;
  int count = 3;

  RestaurantList(
      {required this.restaurantList,
      required this.mCityList,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: count == 3 && restaurantList.length > count
            ? count
            : restaurantList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RestaurantUserCard(
              onTap: () {
                //popup a attachments toast
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiProvider(providers: [
                              StreamProvider<DocumentSnapshot?>.value(
                                  initialData: null,
                                  value: DatabaseService().getRestaurantById(
                                      restaurantList[index].id)),
                          StreamProvider<List<FoodModel>?>.value(
                              initialData: null,
                              value: DatabaseService().foodByIds(['u0FLyUkNN8js0dCMiSoT','0GbU3R8nN1IaGx8NmtYa'])),
                              StreamProvider<List<CategoryModel>?>.value(
                                  initialData: null,
                                  value: DatabaseService().getLiveCategories),
                          StreamProvider<CartModel>.value(
                              initialData: CartModel(),
                              value: DatabaseService().getMyCart)
                            ], child: MenuRestaurant())));

              },
              onRateTap: () {
                DoRate().rate(context,restaurantList[index]);
              },
              title: '${restaurantList[index].name}',
              image: '${restaurantList[index].image}',
              address:
                  '${restaurantList[index].address},${mCityList.firstWhere((element) => element.id == restaurantList[index].city).name}',
              rate: '${restaurantList[index].getRate()}',
              rateCount:  '${restaurantList[index].getRateCount()}',
            ),
          );
        });
  }
}
