import 'package:flutter/material.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int currentPage = 0;
  List<Widget> list= [NewOrders(),InProgressOrders(),DeliveredOrders()];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selectOrderType(),
        Expanded(child: list[currentPage])
      ],
    );
  }

  Widget selectOrderType(){
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
                                'Delivered',
                                style: MyStyle().whiteStyleW600(),
                              )),
                        ))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}


class NewOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child:Container(child: Text('NewOrders',style: MyStyle().textStyleBold(),),));
  }
}
class InProgressOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child:Container(child: Text('InProgressOrders',style: MyStyle().textStyleBold(),),));
  }
}

class DeliveredOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child:Container(child: Text('DeliveredOrders',style: MyStyle().textStyleBold(),),));
  }
}