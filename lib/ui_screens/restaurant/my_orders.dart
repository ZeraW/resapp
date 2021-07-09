import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/payment_confirm.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class MyOrdersScreen extends StatefulWidget {
  String resId;

  MyOrdersScreen(this.resId);

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      StreamProvider<List<OrderModel>?>.value(
          initialData: null,
          value: DatabaseService()
              .getRestaurantOrder(resId: widget.resId, status: 0),
          child: NewOrders(widget.resId)),
      StreamProvider<List<OrderModel>?>.value(
          initialData: null,
          value: DatabaseService()
              .getRestaurantOrder(resId: widget.resId, status: 1),
          child: InProgressOrders(widget.resId)),
      StreamProvider<List<OrderModel>?>.value(
          initialData: null,
          value: DatabaseService()
              .getRestaurantOrder(resId: widget.resId, status: 2),
          child: DeliveredOrders(widget.resId)),
      StreamProvider<List<OrderModel>?>.value(
          initialData: null,
          value: DatabaseService()
              .getRestaurantOrder(resId: widget.resId, status: 3),
          child: DeliveredOrders(widget.resId)),
    ];

    return Column(
      children: [selectOrderType(), Expanded(child: list[currentPage])],
    );
  }

  Widget selectOrderType() {
    return Material(
      elevation: 2.0,
      color: MyColors().mainColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: Dimensions.getHeight(1.5)),
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: Dimensions.getHeight(1),
                horizontal: Dimensions.getWidth(4)),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            child: IntrinsicHeight(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          overlayColor:
                              MyColors.materialColor(Colors.amberAccent),
                          onTap: currentPage == 0
                              ? null
                              : () {
                                  setState(() {
                                    currentPage = 0;
                                  });
                                },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.getHeight(2.5)),
                            color: currentPage == 0
                                ? Colors.amber
                                : Colors.transparent,
                            child: Text(
                              'New',
                              style: MyStyle().whiteStyleW600(),
                            ),
                          ),
                        )),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 0,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          overlayColor:
                              MyColors.materialColor(Colors.amberAccent),
                          onTap: currentPage == 1
                              ? null
                              : () {
                                  setState(() {
                                    currentPage = 1;
                                  });
                                },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.getHeight(2.5)),
                              color: currentPage == 1
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Text(
                                'In Progress',
                                style: MyStyle().whiteStyleW600(),
                              )),
                        )),
                    VerticalDivider(
                        color: Colors.white, thickness: 1, width: 0),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          overlayColor:
                          MyColors.materialColor(Colors.amberAccent),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          onTap: currentPage == 2
                              ? null
                              : () {
                            setState(() {
                              currentPage = 2;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.getHeight(2.5)),
                              color: currentPage == 2
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Text(
                                'In Delivery',
                                style: MyStyle().whiteStyleW600(),
                              )),
                        )),
                    VerticalDivider(
                        color: Colors.white, thickness: 1, width: 0),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          overlayColor:
                          MyColors.materialColor(Colors.amberAccent),
                          onTap: currentPage == 3
                              ? null
                              : () {
                            setState(() {
                              currentPage = 3;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.getHeight(2.5)),
                              color: currentPage == 3
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Text(
                                'Delivered',
                                style: MyStyle().whiteStyleW600(),
                              )),
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class NewOrders extends StatelessWidget {
  String resId;

  NewOrders(this.resId);
  @override
  Widget build(BuildContext context) {
    final mOrder = Provider.of<List<OrderModel>?>(context);
    return mOrder != null
        ? ListView.builder(
            itemCount: mOrder.length,
            shrinkWrap: true,
            /*physics: const NeverScrollableScrollPhysics(),*/
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemBuilder: (ctx, index) {

              Map<String, dynamic> cartModel = Map<String, dynamic>.from(mOrder[index].restaurantCart);
              CartModel cartModel2 =  CartModel.fromJson(cartModel['$resId']!);

              return GestureDetector(
                onTap: () {},
                child: ResOrderItem(
                  title: mOrder[index].userName,
                  price: cartModel2.totalPrice.toString(),
                  method: mOrder[index].payment,
                  status: 'View Order',
                  changeState: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OrderDetails(mOrder[index],resId)));
                  },
                ),
              );
            })
        : SizedBox();
  }
}

class InProgressOrders extends StatelessWidget {
  String resId;

  InProgressOrders(this.resId);
  @override
  Widget build(BuildContext context) {
    final mOrder = Provider.of<List<OrderModel>?>(context);
    return mOrder != null
        ? ListView.builder(
            itemCount: mOrder.length,
            shrinkWrap: true,
            /*physics: const NeverScrollableScrollPhysics(),*/
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemBuilder: (ctx, index) {

              Map<String, dynamic> cartModel = Map<String, dynamic>.from(mOrder[index].restaurantCart);
              CartModel cartModel2 =  CartModel.fromJson(cartModel['$resId']!);

              return GestureDetector(
                onTap: () {},
                child: ResOrderItem(
                  title: mOrder[index].userName,
                  price: cartModel2.totalPrice.toString(),
                  method: mOrder[index].payment,
                  status: 'Ready ?',
                  changeState: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OrderDetails(mOrder[index],resId)));
                  },
                ),
              );
            })
        : SizedBox();
  }
}

class DeliveredOrders extends StatelessWidget {
  String resId;

  DeliveredOrders(this.resId);
  @override
  Widget build(BuildContext context) {
    final mOrder = Provider.of<List<OrderModel>?>(context);
    return mOrder != null
        ? ListView.builder(
            itemCount: mOrder.length,
            shrinkWrap: true,
            /*physics: const NeverScrollableScrollPhysics(),*/
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemBuilder: (ctx, index) {

              Map<String, dynamic> cartModel = Map<String, dynamic>.from(mOrder[index].restaurantCart);
              CartModel cartModel2 =  CartModel.fromJson(cartModel['$resId']!);

              return GestureDetector(
                onTap: () {},
                child: ResOrderItem(
                  title: mOrder[index].userName,
                  price: cartModel2.totalPrice.toString(),
                  method: mOrder[index].payment,
                  status: 'Delivery',
                  changeState: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OrderDetails(mOrder[index],resId)));
                  },
                ),
              );
            })
        : SizedBox();
  }
}

class OrderDetails extends StatefulWidget {
  OrderModel order;
  String resId;

  OrderDetails(this.order,this.resId);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int  currentPage = 0;


  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> cartModel = Map<String, dynamic>.from(widget.order.restaurantCart);

    CartModel cartModel2 =  CartModel.fromJson(cartModel['${widget.resId}']!);
    Map<String,int> orderStatus = Map<String , int>.from(widget.order.orderStatus!);
    int currentStatus = orderStatus['${widget.resId}']!;

    return Scaffold(
      appBar: AppBar(
        title: Text('order: ${widget.order.id}'),
      ),
      body: Column(
        children: [
          selectOrderType(),
          Expanded(child: currentPage == 0 ? StreamProvider<List<FoodModel>?>.value(
              initialData: null,
              value: DatabaseService().getLiveFood,
              child: OrderItems(cartModel2)) :orderInfo(cartModel2)),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30,vertical: 20),
            child: SizedBox(
                height: Responsive.height(context, 7),
                width: double.infinity,
                child: OnClick(
                    child: Center(child: Text('${orderStatusX(currentStatus)}',style: MyStyle().bigBold(),)),
                    color: Colors.amberAccent,
                    onTap: () async{

                      if(currentStatus==0){
                        await DatabaseService().updateResReport(price: cartModel2.totalPrice!,resId: widget.resId);
                      }
                      currentStatus!=3 ?updateStatus(currentStatus):null;


                    })),
          )
        ],
      ),
    );
  }


  void updateStatus(int status)async{
    Map<String,int> orderStatus2 = Map<String , int>.from(widget.order.orderStatus!);
    orderStatus2.removeWhere((key, value) => key == "all");
    orderStatus2['${widget.resId}'] = status+1;
    List<int> weightData = orderStatus2.entries.map( (entry) => entry.value).toList();

    print(weightData);
    if(weightData.any((element) => element<status+1)){
      // change res only
       await DatabaseService().changeOrderStatusResOnly(myOrder: widget.order.id!, resId: widget.resId, status: status+1);
        Navigator.pop(context);

    }else{
      //change all
       await DatabaseService().changeOrderStatusAll(myOrder: widget.order.id!, resId: widget.resId, status: status+1);
        Navigator.pop(context);
    }

  }

  String orderStatusX(int status){
    if(status==0){
      return'Start Preparing';
    }else if(status==1){
      return'Order Ready ?';
    }else if(status==2){
      return'Delivered ?';
    }else{
      return'Delivered';
    }
  }

  Widget orderInfo(CartModel cartM){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Order Number',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Text(
                        '${widget.order.id}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),SizedBox(height: 20,),
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),SizedBox(height: 10,),

                  Text(
                    '${widget.order.address!.address}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),SizedBox(height: 20,),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),SizedBox(height: 10,),

                  Text(
                    '${widget.order.address!.phone}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),SizedBox(height: 20,),
                  Row(
                    children: [
                      Text(
                        'Total Amount Paid',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Text(
                        '${cartM.totalPrice} L.E',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),SizedBox(height: 20,),
                  Row(
                    children: [
                      Text(
                        'Amount Paid Via',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Text(
                        '${widget.order.payment}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Image.asset('assets/images/customer.png'),
              title: Text('Ordered by',style: TextStyle(fontSize: 13),),
              subtitle: Text('${widget.order.userName}',style: MyStyle().bigBold(),),

            ),
          ),
        )
      ],
    );
  }

  Widget selectOrderType() {
    return Material(
      elevation: 2.0,
      color: MyColors().mainColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: Dimensions.getHeight(1.5)),
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: Dimensions.getHeight(1),
                horizontal: Dimensions.getWidth(4)),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            child: IntrinsicHeight(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          overlayColor:
                              MyColors.materialColor(Colors.amberAccent),
                          onTap: () {
                            setState(() {
                              currentPage = 0;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.getHeight(2.5)),
                            color: currentPage == 0
                                ? Colors.amberAccent
                                : Colors.transparent,
                            child: Text(
                              'Ordered Items',
                              style: MyStyle().whiteStyleW600(),
                            ),
                          ),
                        )),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 0,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: InkWell(
                          overlayColor:
                              MyColors.materialColor(Colors.amberAccent),
                          onTap: currentPage == 1
                              ? null
                              : () {
                                  setState(() {
                                    currentPage = 1;
                                  });
                                },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.getHeight(2.5)),
                              color: currentPage == 1
                                  ? Colors.amberAccent
                                  : Colors.transparent,
                              child: Text(
                                'Order Info',
                                style: MyStyle().whiteStyleW600(),
                              )),
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class OrderItems extends StatelessWidget {
  CartModel cartModel;

  OrderItems(this.cartModel);

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<List<FoodModel>?>(context);

    return food !=null ?ListView.builder(
        itemCount: cartModel.cart!.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (ctx, index) {
          CartItemModel item = cartModel.cart![index];
          FoodModel foodItem = food.firstWhere((element) => element.id==item.id,orElse: ()=>FoodModel(name: 'deleted',image: ''));
          return FoodItemWithPrices(title: '${foodItem.name}',image:'${foodItem.image}',prices: item.price,);
        }):SizedBox();
  }
}

