import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/restaurant/food_items.dart';
import 'package:resapp/ui_screens/user/restaurant_search.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class SelectOrderType extends StatelessWidget {
  String cityId;
  List<CityModel> mCityList;
  SelectOrderType(this.cityId,this.mCityList);

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<List<CategoryModel>?>(context);

    return Material(
      elevation: 6.0,
      color: MyColors().mainColor,
      child: categoryList!=null ?ListView.builder(
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(5)),
          itemBuilder: (ctx, index) {
            return IntrinsicHeight(
              child: CategoryItem(
                  image: categoryList[index].image!,
                  title: categoryList[index].name!,
                  id: categoryList[index].id!,
                  onTap: () {
                     Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: 'SearchRestaurant',),

                              builder: (_) => StreamProvider<List<RestaurantModel>?>.value(
                                  initialData: null,
                                  value: DatabaseService().getLiveRestaurantByCityAndCategory(cityId,categoryList[index].id!),
                                  child: SearchRestaurant(mCityList: mCityList,))));
                  }),
            );
          }):SizedBox(),
    );
  }


}
