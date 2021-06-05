import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/ui_screens/home.dart';
import 'package:resapp/ui_screens/user/user_orders.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';
import 'package:resapp/wrapper.dart';

class OrderConfirmDetails extends StatelessWidget {
  OrderModel newOrder;

  OrderConfirmDetails(this.newOrder);

  @override
  Widget build(BuildContext context) {
    BotToast.removeAll('payment');
    BotToast.removeAll('address');
    BotToast.removeAll('usrCart');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColors().mainColor.withOpacity(0.75)));
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),            Spacer(),

            Center(
                child: Image.asset(
              'assets/images/foodpackage.png',
              width: 200,
              height: 200,
            )),
            Spacer(),
            Spacer(),

            Center(
              child: Text(
                'Hey , ${HomeScreen.USERNAME}',
                style: MyStyle().bigWhiteBold(),
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                'Your Order Is Confirmed !',
                style: MyStyle().whiteStyleW600(),
              ),
            ),
            Spacer(),
            DetailsCard(newOrder),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: OnClick(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text('Track Order',style: MyStyle().bigBold(),)),
              ),color: Colors.amberAccent, onTap: (){
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>
                    UserOrders()), (Route<dynamic> route) => route.settings.name == 'Wrapper');
              }),
            ),
            Spacer(),

          ],
        ),
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  OrderModel newOrder;
  DetailsCard(this.newOrder);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    '${newOrder.id}',
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
                '${newOrder.address!.address}',
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
                    '${newOrder.totalPrice} L.E',
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
                    '${newOrder.payment}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
