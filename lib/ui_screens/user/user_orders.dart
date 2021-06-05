import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/payment_confirm.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class UserOrders extends StatefulWidget {
  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  int status = 0;

  @override
  Widget build(BuildContext context) {
    TextStyle selectedStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: Responsive.width(context, 4.5));
    TextStyle unSelectedStyle = TextStyle(
        color: Colors.white60,
        fontWeight: FontWeight.w600,
        fontSize: Responsive.width(context, 4.0));
    return Scaffold(
      appBar: AppBar(
        title: Text('MY ORDERS'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (status != 0) status = 0;
                    });
                  },
                  child: Text(
                    'Upcoming Orders',
                    style: status == 0 ? selectedStyle : unSelectedStyle,
                  )),
              SizedBox(
                width: 40,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (status == 0) status = 3;
                    });
                  },
                  child: Text(
                    'Past Orders',
                    style: status == 3 ? selectedStyle : unSelectedStyle,
                  )),
            ],
          ),
          Expanded(
            child: StreamProvider<List<OrderModel>?>.value(
                initialData: null,
                value: DatabaseService().getMyOrder(status),
                child: MyOrders()),
          )
        ],
      ),
    );
  }
}

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mOrder = Provider.of<List<OrderModel>?>(context);
    /*CartModel cart = mOrder![0].restaurantCart.values.first;
    String restaurant = mOrder[0].restaurantCart.keys.first;
    print('999999999 ${restaurant}');*/
    return mOrder != null
        ? ListView.builder(
            itemCount: mOrder.length,
            shrinkWrap: true,
            /*physics: const NeverScrollableScrollPhysics(),*/
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MultiProvider(providers: [
                                StreamProvider<List<CityModel>?>.value(
                                  initialData: null,
                                  value: DatabaseService().getLiveCities,
                                ),
                                StreamProvider<List<RestaurantModel>?>.value(
                                  initialData: null,
                                  value: DatabaseService().getLiveRestaurant,
                                ),
                              ], child: MyOrderDetails(mOrder[index]))));
                },
                child: UserOrderItem(
                  title: mOrder[index].id,
                  price: mOrder[index].totalPrice.toString(),
                  method: mOrder[index].payment,
                  status: getStatus(mOrder[index].orderStatus!['all']!),
                ),
              );
            })
        : SizedBox();
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'in Progress';
      case 1:
        return 'in Preparation';
      case 2:
        return 'On The Way';
      case 3:
        return 'Delivered';
      default:
        return '';
    }
  }
}

class MyOrderDetails extends StatefulWidget {
  OrderModel order;

  MyOrderDetails(this.order);

  @override
  _MyOrderDetailsState createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {

  @override
  Widget build(BuildContext context) {
    final restaurantList = Provider.of<List<RestaurantModel>?>(context);
    final cityList = Provider.of<List<CityModel>?>(context);

    List<RestaurantModel> myRes = [];
    if(restaurantList!=null){
      for(String id in widget.order.orderStatus!.keys){
        if(id != 'all'){
          myRes.add(restaurantList.firstWhere((element) => element.id == id,orElse: ()=> restaurantList[0]));
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.order.id}'),
      ),
      body: restaurantList !=null && cityList!=null ?ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
              child: Image.asset(
                getImage(widget.order.orderStatus!['all']!),
                width: 200,
                height: 200,
              )),
          SizedBox(height: 20,),
          Center(
            child: Text(
              '${getStatus(widget.order.orderStatus!['all']!)}',
              style: MyStyle().bigWhiteBold(),
            ),
          ),
          SizedBox(height: 10,),

          DetailsCard(widget.order),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Text('Restaurants',style: TextStyle(color: Colors.white60),),
          ),
          RestaurantList(restaurantList: myRes, mCityList: cityList),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Text('Item Ordered',style: TextStyle(color: Colors.white60),),
          ),
          MultiProvider(
            providers: [
              StreamProvider<List<FoodModel>?>.value(
                  initialData: null, value: DatabaseService().getLiveFood),
            ],
            child: FoodOrderedList(widget.order.cart!),
          )
        ],
      ):SizedBox(),
    );
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'in Progress';
      case 1:
        return 'in Preparation';
      case 2:
        return 'On The Way';
      case 3:
        return 'Delivered';
      default:
        return '';
    }
  }
  String getImage(int status) {
    switch (status) {
      case 0:
        return 'assets/images/foodpackage.png';
      case 1:
        return 'assets/images/deliveryman.png';
      case 2:
        return 'assets/images/scooter.png';
      case 3:
        return 'assets/images/time.png';
      default:
        return '';
    }
  }
}

class RestaurantList extends StatelessWidget {
  List<RestaurantModel> restaurantList;
  List<CityModel> mCityList;

  RestaurantList(
      {required this.restaurantList,
        required this.mCityList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: restaurantList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RestaurantUserCard(
              onTap: () {},
              onRateTap: (){},
              title: '${restaurantList[index].name}',
              image: '${restaurantList[index].image}',
              address:
              '${restaurantList[index].address},${mCityList.firstWhere((element) => element.id == restaurantList[index].city).name}',
              rate: '${restaurantList[index].getRate()}',
              rateCount: '${restaurantList[index].getRateCount()}',
            ),
          );
        });
  }
}


class FoodOrderedList extends StatelessWidget {
  final List<CartItemModel> mCart ;
  FoodOrderedList(this.mCart);
  @override
  Widget build(BuildContext context) {
    final menuList = Provider.of<List<FoodModel>?>(context);

    return menuList != null ? ListView.builder(
        itemCount: mCart.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (ctx, index) {
          PriceModel? placeHolderForPrice;
          FoodModel food = menuList.firstWhere(
                  (element) => element.id == mCart[index].id,
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
              return UserMenuItem(
                title: '${food.name!}',
                subTitle: '${food.details!}',
                priceList: food.price!,
                image: food.image!,
                food: food,
                cart: mCart,
              );
            }),
          );
        })
        : SizedBox();
  }

}