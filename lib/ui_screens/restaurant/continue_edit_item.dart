import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';


class ContinueEditItem extends StatefulWidget {
  final File? image;
  FoodModel foodItem;

  ContinueEditItem({required this.image, required this.foodItem});

  @override
  _ContinueEditItemState createState() => _ContinueEditItemState();
}

class _ContinueEditItemState extends State<ContinueEditItem> {

  List<PriceModel> priceList=[];
  Map<String,String> keyWords={};

  PriceModel? selectedPrice,editPrice;

  @override
  void initState() {
    super.initState();
    priceList.addAll(widget.foodItem.price!);
    selectedPrice = widget.foodItem.price![0];
  }
  @override
  Widget build(BuildContext context) {
    print('setstate');
    return Scaffold(
      appBar: AppBar(title: Text('Edit ITEM VARIETIES')),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 18,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(2),
                  horizontal: Dimensions.getWidth(5)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RestaurantFoodItemAdd(
                        title: '${widget.foodItem.name}',//title
                        subTitle: '${widget.foodItem.details}',//details
                        priceList: priceList,//selected price ( i used this cuz i won't have more than one item )
                        selectedItem: selectedPrice,
                        image: widget.image,
                        imageUrl: widget.foodItem.image,
                        onEditTap: () {
                          print('there');
                          editPrice = selectedPrice;
                          setState(() {

                          });
                        },
                    onDeleteTap: () {
                      priceList.removeWhere((element) => element.size == selectedPrice!.size);
                      if(priceList.length>0) selectedPrice = priceList[0];
                      setState(() {

                      });
                    },
                        currentPrice: (price) {
                          print(price!.price);
                          selectedPrice =price;
                          setState(() {

                          });
                        }),
                    SizedBox(height: Dimensions.getHeight(3),),

                    //variety
                    VarietyWidget(editVariety: editPrice,onChange: (price){
                      FocusScope.of(context).requestFocus(new FocusNode());
                      print(price!.price);
                      setState(() {
                        priceList.removeWhere((element) => element.size == price.size);
                        priceList.add(price);
                        priceList.sort((a,b)=>a.price!.compareTo(b.price!));
                        editPrice = null;
                        selectedPrice =price;
                      });

                    },)
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom==0,
            child: Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: OnClick(
                color: Colors.amberAccent,
                onTap: () {
                  _addItem(context);
                },
                child: Container(
                    height: Dimensions.getHeight(8),
                    alignment: Alignment.center,
                    child: Text(
                      'UPDATE ITEM',
                      style: MyStyle().bigBold(),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  _addItem(BuildContext context) async {
    if (priceList.isNotEmpty){
      widget.foodItem.price =priceList;
      createSearchKeywordsList();
      print(widget.foodItem.keyWords);
      BotToast.showLoading();
      await DatabaseService().updateFood(
          updatedFood: widget.foodItem, imageFile: widget.image);
      BotToast.cleanAll();
      Navigator.pop(context);
      Navigator.pop(context);
    }else {
      Fluttertoast.showToast(
          msg: "Please Add Variety",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void createSearchKeywordsList(){
    keyWords.clear();
    String search = '';
    keyWords['food']=widget.foodItem.name.toString();
    keyWords['category']=widget.foodItem.category.toString();
    keyWords['restaurant']=widget.foodItem.restaurantId.toString();
    keyWords['price']=priceList[0].price.toString();
    for(int i = 0; i<widget.foodItem.name!.length; i++){
      search += widget.foodItem.name![i];
      keyWords['name:$i']='${search}';
    }

    widget.foodItem.keyWords = keyWords;
  }
}

class VarietyWidget extends StatefulWidget {
  PriceModel? editVariety;
  final void Function(PriceModel?) onChange;

  VarietyWidget({this.editVariety, required this.onChange});

  @override
  _VarietyWidgetState createState() => _VarietyWidgetState();
}

class _VarietyWidgetState extends State<VarietyWidget> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();

  String _nameError = '',_priceError = '';

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    if(widget.editVariety!=null ){
      print('here');
      _nameController.text = widget.editVariety!.size.toString();
      _priceController.text = widget.editVariety!.price.toString();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Colors.white ,
        child: Column(
          children: [
            TextFormBuilder(
              controller: _nameController,
              hint: "Variety Name",
              keyType: TextInputType.text,
              errorText: _nameError,
            ),
            TextFormBuilder(
              controller: _priceController,
              hint: "Price",
              keyType: TextInputType.number,
              errorText: _priceError,
            ),

            OnClick(
              color: Colors.amberAccent,
              onTap: () {
                _addVariety();
              },
              child: Container(
                  height: Dimensions.getHeight(8),
                  alignment: Alignment.center,
                  child: Text(
                    'SAVE VARIETY',
                    style: MyStyle().blackStyleW600(),
                  )),
            )
          ],
        ),
      ),
    );
  }
  _addVariety() {
    String name = _nameController.text;
    String price = _priceController.text;
    if (name == null || name.isEmpty) {
      setState(() {
        _nameError = "Please enter variety name";
      });
    } else if (price == null || price.isEmpty) {
      clear();
      setState(() {
        _priceError = "Please enter price";
      });
    }else {
      clear();
      widget.onChange(PriceModel(size: name,price: int.parse(price)));
      _nameController.clear();
      _priceController.clear();
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _priceError = "";

    });
  }
}

