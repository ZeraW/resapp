import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class ShowCart {
  BuildContext context;
  ShowCart(this.context);
  showCartDialog({onTap}) {
    BotToast.removeAll('cart');
    BotToast.showWidget(
        groupKey: 'cart',
        toastBuilder: (_) => Align(
              alignment: Alignment.bottomLeft,
              child: StreamBuilder<CartModel?>(
                  stream: DatabaseService().getMyCart,
                  builder: (context, snapshot) {
                    print('dada ');
                    return Material(
                      child: InkWell(
                        onTap: onTap == null
                            ? () => BotToast.removeAll('cart')
                            : onTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: Responsive.width(context, 100),
                          height: Responsive.height(context, 8),
                          child: Row(
                            children: [
                              Text(
                                  '${snapshot.data != null ? snapshot.data!.totalPrice : ''}L.E (${snapshot.data != null ? '${snapshot.data!.totalCount}' : ''} item)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Spacer(),
                              Text(
                                'CONFIRM ORDER',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ));
  }
  showPaymentDialog({onTap,key}) {
    BotToast.removeAll('$key');
    BotToast.showWidget(groupKey: '$key', toastBuilder: (_) => Align(
          alignment: Alignment.bottomLeft,
          child: StreamBuilder<CartModel?>(
              stream: DatabaseService().getMyCart,
              builder: (context, snapshot) {

                return Container(
                  width: Responsive.width(context, 100),
                  height: Responsive.height(context, 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          width: Responsive.width(context, 100),
                          height: Responsive.height(context, 6),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                              color: Colors.white
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  'Total Price',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),Spacer(),
                                Text(
                                    '${snapshot.data != null ? snapshot.data!.totalPrice : ''} L.E',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.amberAccent,
                        child: InkWell(
                          onTap: onTap == null
                              ? () => BotToast.removeAll('payment')
                              : onTap,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: Responsive.width(context, 100),
                            height: Responsive.height(context, 8),
                            child: Row(
                              children: [

                                Spacer(),
                                Text(
                                  'PROCEED TO CHECKOUT',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,letterSpacing: 1.0),
                                ),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,size: 30,color: MyColors().textColor,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) ;
              }),
        ));
  }
}

