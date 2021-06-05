import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/home.dart';
import 'package:resapp/ui_screens/user/payment_confirm.dart';
import 'package:resapp/ui_widget/show_cart.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class PaymentMethods extends StatefulWidget {
  OrderModel newOrder;

  PaymentMethods(this.newOrder);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String payment = 'null';

  @override
  Widget build(BuildContext context) {
    ShowCart(context).showPaymentDialog(
        key: 'payment',
        onTap: () async {
          if (payment == 'null') {
            BotToast.showText(
                text: 'SELECT PAYMENT METHOD', contentColor: Colors.redAccent);
          } else {
            widget.newOrder.payment = payment;
            widget.newOrder.userName = HomeScreen.USERNAME;
            await DatabaseService()
                .addOrder(newOrder: widget.newOrder)
                .then((value) async {
              await DatabaseService().deleteCart().then((value) {
                BotToast.removeAll('payment');
                BotToast.removeAll('address');
                BotToast.removeAll('usrCart');
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>
                    OrderConfirmDetails(widget.newOrder)), (Route<dynamic> route) => route.settings.name == 'Wrapper');
                /*Navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    LoginScreen()), (Route<dynamic> route) => false);
                pushReplacement(context,
                    MaterialPageRoute(builder: (_) => OrderConfirmDetails(widget.newOrder)));*/

              });
            });
          }
        });
    return WillPopScope(
      onWillPop: () async {
        BotToast.removeAll('payment');
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SELECT PAYMENT METHOD'),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: Responsive.height(context, 13)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        payment = 'credit';
                      });
                    },
                    leading: Icon(Icons.credit_card),
                    title: Text('Credit / Debit Card'),
                    trailing: payment == 'credit'
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.amberAccent,
                          )
                        : Icon(Icons.radio_button_unchecked),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        payment = 'cash';
                      });
                    },
                    leading: Icon(Icons.monetization_on),
                    title: Text('Cash on Delivery'),
                    trailing: payment == 'cash'
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.amberAccent,
                          )
                        : Icon(Icons.radio_button_unchecked),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
