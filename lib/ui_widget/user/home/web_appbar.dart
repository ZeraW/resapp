import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/home.dart';
import 'package:resapp/ui_screens/profile_screen.dart';
import 'package:resapp/ui_screens/user/restaurant_search.dart';
import 'package:resapp/ui_screens/user/user_cart.dart';
import 'package:resapp/ui_screens/user/user_orders.dart';

class WebAppBar extends StatelessWidget {

  final UserModel user;
  WebAppBar(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CityModel>?>.value(
        initialData: null,
        value: DatabaseService().getLiveCities,
        child: _TheBar(user));
  }
}


class _TheBar extends StatelessWidget {
  final UserModel user;

  _TheBar(this.user);


  @override
  Widget build(BuildContext context) {
    final mCityList = Provider.of<List<CityModel>?>(context);



   /* Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>
        UserOrders()), (Route<dynamic> route) => route.settings.name == 'Wrapper');*/
    return  Container(
      color: Colors.amber,
      child: Row(
        children: [
          Spacer(),
          GestureDetector(
            onTap: (){
              Navigator.popUntil(context, (route) =>  route.settings.name == 'Wrapper');
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'FOOD',
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
          GestureDetector(
            onTap: (){

              Navigator.popUntil(context, (route) {
                if (route.settings.name != 'SearchRestaurant') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: 'SearchRestaurant',),
                          builder: (_) => StreamProvider<List<RestaurantModel>?>.value(
                              initialData: null,
                              value: DatabaseService().getLiveRestaurant,
                              child: SearchRestaurant(mCityList: mCityList,user: user,searchText: '',))));
                }
                return true;
              });


            },
            child: Text(
              'All Restaurant',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          GestureDetector(
            onTap: (){
              HomeScreen.checkIfAnonymous(context, () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(user))));
            },
            child: Text(
              'Profile',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          GestureDetector(
            onTap: (){
              HomeScreen.checkIfAnonymous(context, () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserOrders())));
            },
            child: Text(
              'My Orders',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          GestureDetector(
            onTap: (){
              HomeScreen.checkIfAnonymous(context, () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserCart())));
            },
            child: Text(
              'Cart',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
