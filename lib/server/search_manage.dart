import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchManage extends ChangeNotifier {
  Query? queryRef;
   String? source, destination, date, trainType, carClass;
   bool? foodDrink;

  SearchManage(
      {this.source,
        this.destination,
        required this.date,
        this.trainType,
        this.carClass,
        this.foodDrink});

  void updateQuery() {

    if (trainType != null) {
      if (trainType == 'Super Fast') {
        queryRef = FirebaseFirestore.instance
            .collection('Trips')
            .where('keyWords.date', isEqualTo: date)
            .where('keyWords.trainType', isEqualTo: 'Super Fast');
        if (source != null && destination == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityfrom', isEqualTo: source);
        } else if (destination != null && source == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityto', isEqualTo: source);
        } else {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityfrom', isEqualTo: source)
              .where('keyWords.cityto', isEqualTo: destination);
        }
      } else if (trainType == 'Express') {
        queryRef = FirebaseFirestore.instance
            .collection('Trips')
            .where('keyWords.date', isEqualTo: date)
            .where('keyWords.trainType', isEqualTo: 'Express');
        if (source != null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Express')
              .where('keyWords.city$source', isEqualTo: 'true');
        }
      }
    }

    notifyListeners();
  }

  void updateSource(String newSource){
    source = newSource;
    updateQuery();
  }

  void updateDestination(String newDestination){
    destination = newDestination;
    updateQuery();
  }


  void swapSourceWithDestination(){
    String? holder;
    holder = source;
    source = destination;
    destination = holder;
    updateQuery();
  }

}
