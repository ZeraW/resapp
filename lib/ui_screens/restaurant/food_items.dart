import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/restaurant/restaurant_items.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

import 'add_new_item.dart';
import 'edit_item.dart';

class FoodItemsScreen extends StatefulWidget {
  String restaurantId;

  FoodItemsScreen(this.restaurantId);

  @override
  _FoodItemsScreenState createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  late RestaurantModel restaurant;
  CategoryModel? selectedCategory;
  List<CategoryModel> myCategory = [];

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<List<CategoryModel>?>(context);
    final snapshot = Provider.of<DocumentSnapshot?>(context);

    if (snapshot != null && categoryList != null) {
      restaurant = RestaurantModel.fromJson(snapshot.data()!);
      if (selectedCategory == null)
        selectedCategory = categoryList
            .firstWhere((element) => element.id == restaurant.categoryList![0]);
    }

    return snapshot != null && categoryList != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: selectOrderType(categoryList)),
              Flexible(
                  flex: 15,
                  fit: FlexFit.tight,
                  child: StreamProvider<List<FoodModel>?>.value(
                      initialData: null,
                      value: DatabaseService().queryLiveFood(
                          category: selectedCategory!.id!,
                          restaurant: restaurant.id!),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: FoodListWidget(
                          myCategory: myCategory,
                        ),
                      ))),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: OnClick(
                    color: Colors.amberAccent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  AddNewItem(widget.restaurantId, myCategory)));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'ADD NEW ITEM',
                          style: MyStyle().bigBold(),
                        )),
                  ))
            ],
          )
        : SizedBox();
  }

  Widget selectOrderType(List<CategoryModel> categoryList) {
    if (myCategory.isEmpty) {
      for (String item in restaurant.categoryList!) {
        //get my category
        myCategory
            .add(categoryList.firstWhere((element) => element.id == item));
      }
    }
    return selectedCategory != null
        ? Material(
            elevation: 2.0,
            color: MyColors().mainColor,
            child: Center(
              child: ListView.builder(
                  itemCount: restaurant.categoryList!.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (ctx, index) {
                    return CategoryItem(
                        image: myCategory[index].image!,
                        title: myCategory[index].name!,
                        selected: selectedCategory,
                        id: myCategory[index].id!,
                        onTap: () {
                          setState(() {
                            selectedCategory = myCategory[index];
                          });
                        });
                  }),
            ),
          )
        : SizedBox();
  }
}

class CategoryItem extends StatelessWidget {
  final String image, id;
  final String title;
  final Function() onTap;
  final CategoryModel? selected;

  CategoryItem({
    required this.image,
    required this.title,
    required this.id,
    required this.onTap,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  selected != null && selected!.id == id ? 30 : 25),
              child: CachedNetworkImage(
                imageUrl: image,
                width: selected != null && selected!.id == id ? 60 : 50,
                height: selected != null && selected!.id == id ? 60 : 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: Dimensions.getHeight(1),
            ),
            Text(
              title,
              style: TextStyle(
                  color: selected != null && selected!.id == id
                      ? Colors.redAccent
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.getWidth(3.7)),
            )
          ],
        ),
      ),
    );
  }
}

class FoodListWidget extends StatelessWidget {
  List<CategoryModel> myCategory;

  FoodListWidget({required this.myCategory});

  @override
  Widget build(BuildContext context) {
    final foodList = Provider.of<List<FoodModel>?>(context);

    return foodList != null
        ? ListView.builder(
            itemCount: foodList.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (ctx, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: Dimensions.getHeight(2)),
                child: new RestaurantFoodItem(
                    title: '${foodList[index].name!}',
                    subTitle: '${foodList[index].details!}',
                    priceList: foodList[index].price!,
                    image: foodList[index].image!,
                    onEditTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditItem(
                                    foodItem: foodList[index],
                                    categoryList: myCategory,
                                  )));
                    },
                    onDeleteTap: () async {
                      BotToast.showLoading();
                      await DatabaseService()
                          .deleteFood(deleteFood: foodList[index]);
                      BotToast.cleanAll();

                    },
                    currentPrice: (price) {
                      print(price!.price);
                    }),
              );
            })
        : SizedBox();
  }
}
