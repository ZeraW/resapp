import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/profile_screen.dart';
import 'package:resapp/ui_widget/admin/home/admin_card.dart';
import 'package:resapp/ui_widget/drawer_items.dart';
import 'package:resapp/ui_widget/top_sheet.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';
import 'manage_categories.dart';
import 'manage_cities.dart';
import 'manage_restaurant.dart';

class HomeAdmin extends StatelessWidget {
  UserModel user;

  HomeAdmin(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
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
                                    /*_topModalSheetKey.currentState!
                                    .onBackPressed();*/
                                    TopSheet.instance.hideTopSheet();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: Dimensions.getWidth(7),
                                  )),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  /*_topModalSheetKey.currentState!.onBackPressed();*/
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
                              DrawerItem('assets/images/home.png', 'Home', () {
                                TopSheet.instance.hideTopSheet();
                              }),
                              Spacer(),
                              DrawerItem('assets/images/profile.png', 'Profile', () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileScreen(user)));
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getHeight(4),
                        ),
                      ],
                    )),
              )),
          child: Icon(Icons.dashboard),
        ),
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: Dimensions.getWidth(40),
            height: Dimensions.getWidth(40),
          ),
          Center(
            child: Wrap(
              children: [
                AdminCard(
                    title: 'Manage\nCities',
                    open: StreamProvider<List<CityModel>?>.value(
                        initialData: null,
                        value: DatabaseService().getLiveCities,
                        child: ManageCitiesScreen())),
                AdminCard(
                    title: 'Manage\nRestaurants',
                    open: StreamProvider<List<RestaurantModel>?>.value(
                        initialData: null,
                        value: DatabaseService().getLiveRestaurant,
                        child: ManageRestaurantScreen())),
                AdminCard(
                    title: 'Manage\nCategories',
                    open: StreamProvider<List<CategoryModel>?>.value(
                        initialData: null,
                        value: DatabaseService().getLiveCategories,
                        child: ManageCategoriesScreen())),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
