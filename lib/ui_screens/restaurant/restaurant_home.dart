import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/admin/manage_restaurant.dart';
import 'package:resapp/ui_widget/drawer_items.dart';
import 'package:resapp/ui_widget/top_sheet.dart';
import 'package:resapp/utils/dimensions.dart';

import '../profile_screen.dart';
import 'food_items.dart';
import 'my_orders.dart';

class HomeRestaurant extends StatefulWidget {
  UserModel user;

  HomeRestaurant(this.user);

  @override
  _HomeRestaurantState createState() => _HomeRestaurantState();
}

class _HomeRestaurantState extends State<HomeRestaurant> {
  int _currentPage = 0;
  late List<Widget> restaurantWidgets;
  RestaurantModel? restaurant;


  @override
  void initState() {
    super.initState();
     restaurantWidgets = [MyOrdersScreen(widget.user.restaurantId!),StreamProvider<List<CategoryModel>?>.value(
         initialData: null,
         value: DatabaseService().getLiveCategories, child: FoodItemsScreen(widget.user.restaurantId!))];

  }


  @override
  Widget build(BuildContext context) {

    final snapshot = Provider.of<DocumentSnapshot?>(context);

    if(snapshot!=null){
      restaurant = RestaurantModel.fromJson(snapshot.data()!);
      print('9999999999999 ${restaurant!.keyWords}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage==0?'My Orders':'Food Items'),
        leading: GestureDetector(
          onTap: () => TopSheet.instance.showTopSheet(
              context,
              IntrinsicHeight(
                child: Container(
                    color: Colors.white.withOpacity(0.9),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.getHeight(2),
                              horizontal: Dimensions.getWidth(6)),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    TopSheet.instance.hideTopSheet();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: Dimensions.getWidth(7),
                                  )),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  TopSheet.instance.hideTopSheet();
                                  await AuthService().signOut();
                                },
                                child: Text(
                                  'Log out',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.getWidth(4)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.getHeight(0),
                              horizontal: Dimensions.getWidth(15)),
                          child: Row(
                            children: [
                              DrawerItem(
                                  'assets/images/scooter.png', 'View Orders',
                                  () {
                                    setState(() {
                                      _currentPage =0;

                                    });
                                TopSheet.instance.hideTopSheet();
                              }),
                              Spacer(),
                              DrawerItem('assets/images/profile.png', 'Profile',
                                  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileScreen(widget.user)));
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getHeight(2),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.getHeight(0),
                              horizontal: Dimensions.getWidth(15)),
                          child: Row(
                            children: [
                              DrawerItem(
                                  'assets/images/fooditems.png', 'Food Items',
                                  () {
                                    setState(() {
                                      _currentPage =1;

                                    });
                                TopSheet.instance.hideTopSheet();
                              }),
                              Spacer(),
                              DrawerItem(
                                  'assets/images/application.png', 'Edit',
                                      () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MultiProvider(providers: [
                                                  StreamProvider<List<CityModel>?>.value(
                                                    initialData: null,
                                                    value: DatabaseService().getLiveCities,
                                                  ),
                                                  StreamProvider<List<CategoryModel>?>.value(
                                                    initialData: null,
                                                    value: DatabaseService().getLiveCategories,
                                                  ),
                                                ], child: AddEditRestaurantScreen(editRestaurant: restaurant))));
                                  }),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getHeight(3),
                        ),
                      ],
                    )),
              )),
          child: Icon(Icons.dashboard),
        ),
      ),
      body: restaurantWidgets[_currentPage] ,
    );
  }
}
