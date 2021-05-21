import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/utils/responsive.dart';

class SliderAds extends StatelessWidget {
  List<FoodModel> listToShow = [];
  Widget build(BuildContext context) {
    final imgList = Provider.of<List<FoodModel>?>(context);
    if(imgList!=null)updateDataInList(imgList);
    return Container(
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            disableCenter: true,
            aspectRatio:2.5,
            initialPage: 2,
            autoPlay: false,
          ),
          items: listToShow.map((item) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.image!, fit: BoxFit.cover, width: 1000),
                        Positioned(
                          top: 0.0,
                          bottom: 0.0,
                          right: 0.0,
                          left: Responsive.width(context, 40),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  PhysicalModel(
                                    color: Colors.transparent,
                                    shadowColor: Colors.black12,
                                    elevation: 10.0,
                                    child: Text(
                                      '${item.name}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        letterSpacing: 2.0,
                                        color: Colors.white,
                                        fontSize: Responsive.isMobile(context) ? 20 : Responsive.width(context, 3.5),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  PhysicalModel(
                                    color: Colors.transparent,
                                    shadowColor: Colors.black12,
                                    elevation: 10.0,
                                    child: Text(
                                      'GET THE DEAL',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: Responsive.isMobile(context) ? 15 : Responsive.width(context, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ))
              .toList(),
        ));
  }
  void updateDataInList(List<FoodModel> data) {
    final _random = new Random();
    listToShow = new List.generate(3, (_) => data[_random.nextInt(data.length)]);
  }
}

