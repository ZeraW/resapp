import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/ui_widget/drop_down.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class BaseItem extends StatelessWidget {
  final String? title, subTitle,image;
  final Widget? child;

  BaseItem({this.title, this.subTitle, this.image,this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: Dimensions.getHeight(6),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
                child: child,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: Dimensions.getHeight(6)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(1.5),
                  horizontal: Dimensions.getWidth(4)),
              title: Text(
                '$title',
                style: MyStyle().blackStyleW600(),
              ),
              trailing: Image.network(
                '$image',
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
                child: Text('$subTitle'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantFoodItem extends StatefulWidget {
  String? title, subTitle,image;
  List<PriceModel> priceList;
  Function(PriceModel?) currentPrice;
  Function() onEditTap;

  RestaurantFoodItem(
      {required this.title,
        required this.priceList,
        required this.image,
        this.subTitle = '',
        required this.onEditTap,
        required this.currentPrice});

  @override
  _RestaurantFoodItemState createState() => _RestaurantFoodItemState();
}

class _RestaurantFoodItemState extends State<RestaurantFoodItem> {
  PriceModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (selectedItem == null) {
      selectedItem = widget.priceList[0];
    }
    return BaseItem(title: widget.title,image: widget.image,subTitle: widget.subTitle,child:Row(
      children: [
        Text(
          'Size',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(
          width: 10,
        ),
        DropDownPriceList(
            mList: widget.priceList,
            selectedItem: selectedItem,
            onChange: (price) {
              FocusScope.of(context).requestFocus(new FocusNode());
              widget.currentPrice(price);
              setState(() {
                selectedItem = price;
              });
            }),
        Spacer(),
        Text(
          '${widget.priceList.firstWhere((element) => element.size==selectedItem!.size).price}',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(
          width: Dimensions.getWidth(8),
        ),
        ElevatedButton(
          onPressed: widget.onEditTap,
          child: Text('Edit'),
          style: ButtonStyle(
              backgroundColor:
              MyColors.materialColor(Colors.amber)),
        )
      ],
    ),);
  }
}

// add item select price
class BaseItemAdd extends StatelessWidget {
  final String? title, subTitle,imageUrl;
  final File?image;
  final Widget? child;

  BaseItemAdd({this.title, this.subTitle,this.imageUrl, this.image,this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: Dimensions.getHeight(6),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: Dimensions.getWidth(3)),
              child: child,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: Dimensions.getHeight(6)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: Dimensions.getHeight(1.5),
                horizontal: Dimensions.getWidth(4)),
            title: Text(
              '$title',
              style: MyStyle().blackStyleW600(),
            ),
            trailing: imageUrl!=null? Image.network(imageUrl!) : Image.file(
              image!,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: Dimensions.getHeight(1)),
              child: Text('$subTitle'),
            ),
          ),
        ),
      ],
    );
  }
}

class RestaurantFoodItemAdd extends StatefulWidget {
  String? title, subTitle,imageUrl;
  File? image;
  List<PriceModel> priceList;
  PriceModel? selectedItem;
  Function(PriceModel?) currentPrice;
  Function() onEditTap;

  RestaurantFoodItemAdd(
      {required this.title,
        required this.priceList,
        required this.image,
        this.selectedItem,
        this.imageUrl,
        this.subTitle = '',
        required this.onEditTap,
        required this.currentPrice});

  @override
  _RestaurantFoodItemAddState createState() => _RestaurantFoodItemAddState();
}

class _RestaurantFoodItemAddState extends State<RestaurantFoodItemAdd> {


  @override
  Widget build(BuildContext context) {

    return BaseItemAdd(title: widget.title,image: widget.image,imageUrl: widget.imageUrl,subTitle: widget.subTitle
      ,child:Row(
      children: [
        Text(
          'Size',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(
          width: 10,
        ),
        widget.priceList.isNotEmpty ?DropDownPriceList(
            mList: widget.priceList,
            selectedItem: widget.selectedItem,
            onChange: (price) {
              FocusScope.of(context).requestFocus(new FocusNode());
              widget.currentPrice(price);
              setState(() {
                widget.selectedItem = price;
              });
            }):SizedBox(),
        Spacer(),
        widget.priceList.isNotEmpty ?Text(
          '${widget.selectedItem!.price}',
          style: TextStyle(color: Colors.white70),
        ):SizedBox(),
        SizedBox(
          width: Dimensions.getWidth(8),
        ),
        ElevatedButton(
          onPressed: widget.onEditTap,
          child: Text('Edit'),
          style: ButtonStyle(
              backgroundColor:
              MyColors.materialColor(Colors.amber)),
        )
      ],
    ),);
  }
}