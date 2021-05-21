
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/utils/responsive.dart';

class DoRate {

  rate(BuildContext context,RestaurantModel restaurant){
    double rate =0.0;
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setStatex) {
          return AlertDialog(
            title: Text('Rate ${restaurant.name}'),
            content: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rating) {
                rate = rating;
                setStatex((){});
              },
            ),
            actions: [Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              TextButton(onPressed: (){
                print('$rate');
                _rateTheRestaurant(context,restaurant,rate.round());
              }, child: Text('Rate',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600))),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel',style: TextStyle(color: Colors.grey),))
            ],)],
          );
        }));
  }


  _rateTheRestaurant(BuildContext context,RestaurantModel restaurant,int rate)async{

    await DatabaseService().rateRestaurant(rateRes: restaurant,ratting: rate);

    Navigator.pop(context);

  }



}