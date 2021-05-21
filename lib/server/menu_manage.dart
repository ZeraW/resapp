import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/ui_screens/choose_login_type.dart';
import 'package:resapp/ui_screens/login.dart';
import 'package:resapp/ui_screens/register.dart';

import 'database_api.dart';


class MenuManage extends ChangeNotifier {
  List<FoodModel> searchList = [] ,foodList = [];
  CategoryModel? selectedCategory;
  List<CategoryModel>? allCategory , myCategory=[];
  RestaurantModel? restaurant;
  String _oldSearch = '';
  MenuManage({required this.allCategory,required this.restaurant}){
    for (String item in restaurant!.categoryList!) {
      //get my category
      myCategory!.add(allCategory!.firstWhere((element) => element.id == item));
    }

    if (selectedCategory == null && myCategory!=null && myCategory!.isNotEmpty){
      selectedCategory = myCategory![0];
    }
  }

  void selectCategory(CategoryModel cat){
    selectedCategory = cat;
    _oldSearch='';
    notifyListeners();
  }

  void search(String searchText){
    if(searchText.isNotEmpty ){
      if(searchText !=_oldSearch){
        searchList.clear();
        foodList.forEach((res) {
          if (res.name!.toLowerCase().contains(searchText.toLowerCase())) searchList.add(res);
        });
        _oldSearch=searchText;
        notifyListeners();
      }
    }else{
      resetSearch();
    }
  }

  void clear(){
    searchList.clear();
    foodList.clear();
  }

  void saveFood(List<FoodModel> food ) {
   clear();
    foodList.addAll(food);
   searchList.addAll(food);
    notifyListeners();
  }

  void resetSearch(){
    searchList.clear();
    searchList.addAll(foodList);
    notifyListeners();
  }

  Future addItemToCart(FoodModel food,CartModel? cart , PriceModel selectedPrice)async{
    if (cart!=null) {
      CartItemModel item = cart.cart!.firstWhere((element) => element.id == food.id , orElse: ()=>CartItemModel(id: 'null'));
      if (item.id!='null'){
        //if item exist in my cart
        CartModel updatedCart = cart;
        PriceModel cartPrice = item.price!.firstWhere((element) => element.size == selectedPrice.size,orElse: ()=>PriceModel(size: 'null552'));
        if(cartPrice.size!='null552'){
          //size price already there
          cartPrice.count = cartPrice.count! +1;
          await DatabaseService().updateCart(updatedCart: updatedCart);
        }else {
          //add new size
          selectedPrice.count = 1 ;
         int itemPosition =  updatedCart.cart!.indexOf(item);
          item.price!.add(selectedPrice);
          updatedCart.cart![itemPosition] = item ;
          await DatabaseService().updateCart(updatedCart: updatedCart);

        }





      }else {
        //if item do not exist in my cart
        selectedPrice.count=1;
        CartItemModel newItem = CartItemModel(id: food.id,restaurantId: food.restaurantId,price: [selectedPrice]);
        CartModel newCart = cart;
        newCart.cart!.add(newItem);
        await DatabaseService().updateCart(updatedCart: newCart);
      }
    }else {
      selectedPrice.count = 1;
     CartModel newCart =  CartModel(cart: [CartItemModel(restaurantId: food.restaurantId,id: food.id,price: [selectedPrice])]);
      await DatabaseService().addCart(newCart: newCart);
    }
  }

  void removeFromCart(FoodModel food,CartModel? cart , PriceModel selectedPrice)async{
    if (cart!=null) {
      CartItemModel item = cart.cart!.firstWhere((element) => element.id == food.id , orElse: ()=>CartItemModel(id: 'null'));
      if (item.id!='null'){
        //if item exist in my cart
        CartModel updatedCart = cart;
        PriceModel cartPrice = item.price!.firstWhere((element) => element.size == selectedPrice.size,orElse: ()=>PriceModel(size: 'null552'));
        if(cartPrice.size!='null552'){
          //size price already there
          if(cartPrice.count! >1){
            //reduce the item count by 1
            cartPrice.count = cartPrice.count! -1;
            await DatabaseService().updateCart(updatedCart: updatedCart);
          }else if (cartPrice.count! == 1 && item.price!.length>1) {
            // remove the item
            int itemPosition = item.price!.indexOf(cartPrice);
            item.price!.removeAt(itemPosition);
            await DatabaseService().updateCart(updatedCart: updatedCart);
          } else if (cartPrice.count! == 1 && item.price!.length==1) {
            // remove the item
            int itemPosition = updatedCart.cart!.indexOf(item);
            updatedCart.cart!.removeAt(itemPosition);
            await DatabaseService().updateCart(updatedCart: updatedCart);
          }
        }
      }
    }
  }


}
