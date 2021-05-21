import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/appbar_search.dart';
import 'package:resapp/ui_widget/user/home/resturant_near.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class SearchRestaurant extends StatelessWidget {
  final List<RestaurantModel>? restaurantList;

  final List<CityModel>? mCityList;

  SearchRestaurant({this.restaurantList, this.mCityList});

  @override
  Widget build(BuildContext context) {
    List<RestaurantModel>? resList = restaurantList == null
        ? Provider.of<List<RestaurantModel>?>(context)
        : [];

    if (restaurantList != null) resList!.addAll(restaurantList!);
    return SafeArea(
      child: resList != null
          ? Responsive(
              mobile: StreamProvider<List<CategoryModel>?>.value(
                  initialData: null,
                  value: DatabaseService().getLiveCategories,
                  child: UserMobSearch(resList, mCityList!)),
              tablet: UserWebSearch(),
              desktop: UserWebSearch())
          : SizedBox(),
    );
  }
}

class UserWebSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

class UserMobSearch extends StatefulWidget {
  final List<RestaurantModel> restaurantList;

  final List<CityModel> mCityList;

  UserMobSearch(this.restaurantList, this.mCityList);

  @override
  _UserMobSearchState createState() => _UserMobSearchState();
}

class _UserMobSearchState extends State<UserMobSearch> {
  String searchText = '';
  final List<RestaurantModel> searchList = [];

  @override
  void initState() {
    super.initState();
    searchList.addAll(widget.restaurantList);
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<List<CategoryModel>?>(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSearchBar(
          label: "RESTAURANT",
          labelStyle: TextStyle(fontSize: 16),
          centerLabel: true,
          searchStyle: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          searchDecoration: InputDecoration(
            hintText: "Search",
            alignLabelWithHint: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchText = value;
              searchList.clear();
              widget.restaurantList.forEach((res) {
                if (res.name!.toLowerCase().contains(searchText.toLowerCase()))
                  searchList.add(res);
              });
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Filter',
        onPressed: () {
          if (categoryList != null) _modalBottomSheetMenu(categoryList);
        },
        elevation: 0.0,
        child: Icon(
          Icons.filter_alt_outlined,
          size: 30,
          color: MyColors().mainColor,
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: RestaurantList(
          restaurantList: searchList, mCityList: widget.mCityList, count: 0),
    );
  }

  void doFilter(String filter){
    setState(() {
      searchList.clear();
      widget.restaurantList.forEach((res) {
        if (res.categoryList!.contains(filter))
          searchList.add(res);
      });
    });
  }

  void _modalBottomSheetMenu(List<CategoryModel> categoryList) {
    String selectedCategory = '';
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setStatex) {
            return new Container(
              height: 350.0,
              color: Colors.white60, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      'Filter by',
                      style: MyStyle().bigBold(),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: ListView(
                      children: [
                        Text(
                          'Category',
                          style: MyStyle().blackStyleW600(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: categoryList
                              .map((item) => GestureDetector(
                                    onTap: () {
                                      selectedCategory = item.id!;
                                      setStatex(() {});
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: selectedCategory == item.id ? Colors.green:Colors.amber),
                                        child: Text(item.name!,style: selectedCategory == item.id ? MyStyle().whiteStyleW600() :MyStyle().blackStyleW600() ,)),
                                  ))
                              .toList()
                              .cast<Widget>(),
                        )
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        doFilter(selectedCategory);
                      },
                      child: Text(
                        'Filter',
                        style: MyStyle().whiteStyleW600(),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MyColors.materialColor(MyColors().mainColor)),
                    ))
                  ],
                ),
              ),
            );
          });
        });
  }
}
