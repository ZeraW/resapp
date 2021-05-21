import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/auth.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/restaurant_search.dart';
import 'package:resapp/ui_screens/user/user_cart.dart';
import 'package:resapp/ui_screens/user/user_orders.dart';
import 'package:resapp/ui_widget/drawer_items.dart';
import 'package:resapp/ui_widget/top_sheet.dart';
import 'package:resapp/ui_widget/user/home/order_type.dart';
import 'package:resapp/ui_widget/user/home/resturant_near.dart';
import 'package:resapp/ui_widget/user/home/slider_ads.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

import '../profile_screen.dart';

class HomeUser extends StatelessWidget {
  UserModel user;

  HomeUser(this.user);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Responsive(
          mobile: StreamProvider<List<CityModel>?>.value(
              initialData: null,
              value: DatabaseService().getLiveCities,
              child: UserMobHome(user)),
          tablet: UserWebHome(),
          desktop: UserWebHome()),
    );
  }
}

class UserWebHome extends StatelessWidget {
  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.amber,
              child: Row(
                children: [
                  Spacer(),
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
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Text(
                    'All Restaurant',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'My Orders',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Cart',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(width: Responsive.width(context, 100),
              padding: EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  Container(
                    color: MyColors().mainColor,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/right.png',
                          scale: 1.4,
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/left.png',
                          scale: 1.0,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Transform.scale(
                      scale: 0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Dimensions.getHeight(2),
                          ),
                          Center(
                            child: Text(
                              'Order Food Online In Egypt',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.width(context, 12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: Responsive.height(context, 9),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.amber, width: 1)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              Responsive.width(context, 3)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.search,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: TextFormField(
                                                  style: TextStyle(color: Colors.black,),
                                                  // maxLength: maxLength,
                                                  controller: controller,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please Enter a valid text";
                                                    }
                                                    return null;
                                                  },
                                                  //controller: _controller,
                                                  maxLines: 1,
                                                  //onChanged: onChange,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "What'd you like to eat today?",
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    errorStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    fillColor: Colors.black,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: Responsive.height(context, 9),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Let's Go",
                                          style: TextStyle(fontSize: 25),
                                          textAlign: TextAlign.center,
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MyColors.materialColor(
                                                    Colors.amber),
                                            foregroundColor:
                                                MyColors.materialColor(
                                                    Colors.white)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.getHeight(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: Text(
                'Your everyday, right away',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Order food and grocery delivery online from hundreds of \n restaurants and shops nearby.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Image.asset('assets/images/download.png'),
            ),

            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}

class UserMobHome extends StatefulWidget {
  UserModel user;
  UserMobHome(this.user);

  @override
  _UserMobHomeState createState() => _UserMobHomeState();
}

class _UserMobHomeState extends State<UserMobHome> {
  String selectedCity ='2';
  @override
  Widget build(BuildContext context) {
    final mCityList = Provider.of<List<CityModel>?>(context);



    return Scaffold(
      appBar: AppBar(
        title: Text(''),
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
                              DrawerItem('assets/images/profile.png', 'Profile',
                                  () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileScreen(widget.user)));
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getHeight(4),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.getHeight(0),
                              horizontal: Dimensions.getWidth(15)),
                          child: Row(
                            children: [
                              DrawerItem(
                                  'assets/images/scooter.png', 'My Order', () {
                                Navigator.pop(context);
                              /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserOrders()));*/ //todo uncomment
                              }),
                              Spacer(),
                              DrawerItem('assets/images/grocery.png', 'Cart',
                                  () {
                                    /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => UserCart()));*/ //todo uncomment

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
        actions: [

          PopupMenuButton<CityModel>(
            tooltip: 'Show Cities',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
              mCityList!=null ?'${mCityList.firstWhere((element) => element.id == selectedCity).name}':'',
                    style: MyStyle().whiteStyleW600(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.location_on)
                ],
              ),
            ),
            onSelected: (city){
              if(selectedCity != city.id!){
                setState(() {
                  selectedCity = city.id!;
                });
              }

            },
            itemBuilder: (context) => mCityList!.map((item) => PopupMenuItem<CityModel>(value: item, child: Text('${item.name}'))).toList(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        StreamProvider<List<FoodModel>?>.value(
          initialData: null,
          value: DatabaseService().getLiveFood,
            child: SliderAds()),
            SizedBox(
              height: Dimensions.getHeight(2),
            ),
            Center(
              child: Text(
                'Order Food Online In Egypt',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: ()async{

           /* final re = await DatabaseService().getFoodByListOfIds(['0GbU3R8nN1IaGx8NmtYa','u0FLyUkNN8js0dCMiSoT']);
            print('${re.toString()}');
             print('${re[0].name}');
            */


                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: 'SearchRestaurant',),
                        builder: (_) => StreamProvider<List<RestaurantModel>?>.value(
                            initialData: null,
                            value: DatabaseService().getLiveRestaurantByCity(selectedCity),
                            child: SearchRestaurant(mCityList: mCityList,))));
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.getHeight(3))),
                  height: Dimensions.getHeight(6),
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.getWidth(5),
                      vertical: Dimensions.getHeight(2)),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.getWidth(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 10,
                      ),
                      Text("What'd you like to eat today?")
                    ],
                  )),
            ),
            StreamProvider<List<CategoryModel>?>.value(
              initialData: null,
              value: DatabaseService().getLiveCategories,
              child: SizedBox.fromSize(
                  size: Size(double.maxFinite, Responsive.height(context, 13)),
                  child: mCityList!=null ?SelectOrderType(selectedCity,mCityList): SizedBox()),
            ),
            SizedBox(
              height: Dimensions.getHeight(2),
            ),
            mCityList!=null?StreamProvider<List<RestaurantModel>?>.value(
                initialData: null,
                value: DatabaseService().getLiveRestaurantByCity(selectedCity),
                child: RestaurantNearYou(mCityList,selectedCity)):SizedBox()
          ],
        ),
      ),
    );
  }
}
