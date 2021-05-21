import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/admin/home/admin_card.dart';
import 'package:resapp/ui_widget/drop_down.dart';
import 'package:resapp/ui_widget/my_card.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

import 'manage_accounts.dart';

class ManageRestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mList = Provider.of<List<RestaurantModel>?>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            'Manage Restaurant',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null
          ? ListView(
              children: [
                Center(
                  child: Wrap(
                    children: mList
                        .map((item) => RestaurantCard(
                              manage: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => StreamProvider<
                                                List<UserModel>?>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .getLiveUsers(item.id!),
                                              child: ManageAccountsScreen(
                                                id: item.id!,
                                                image: item.image!,
                                              ),
                                            )));
                              },phone: item.phone!,
                              title: item.name!,
                              image: item.image!,
                              delete: () async {
                                await DatabaseService()
                                    .deleteRestaurant(deleteRestaurant: item);
                              },
                              edit: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MultiProvider(
                                                providers: [
                                                  StreamProvider<
                                                      List<CityModel>?>.value(
                                                    initialData: null,
                                                    value: DatabaseService()
                                                        .getLiveCities,
                                                  ),
                                                  StreamProvider<
                                                      List<
                                                          CategoryModel>?>.value(
                                                    initialData: null,
                                                    value: DatabaseService()
                                                        .getLiveCategories,
                                                  ),
                                                ],
                                                child: AddEditRestaurantScreen(
                                                  editRestaurant: item,
                                                ))));
                              },
                            ))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ],
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addResturant',
        onPressed: () => _increment(
            context: context, nextId: mList != null ? mList.length + 1 : 0),
        tooltip: 'Increment',
        backgroundColor: Colors.green.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment({required BuildContext context, required int nextId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  StreamProvider<List<CityModel>?>.value(
                    initialData: null,
                    value: DatabaseService().getLiveCities,
                  ),
                  StreamProvider<List<CategoryModel>?>.value(
                    initialData: null,
                    value: DatabaseService().getLiveCategories,
                  ),
                ], child: AddEditRestaurantScreen())));
  }
}

class AddEditRestaurantScreen extends StatefulWidget {
  final RestaurantModel? editRestaurant;

  AddEditRestaurantScreen({this.editRestaurant});

  @override
  _AddEditRestaurantScreenState createState() =>
      _AddEditRestaurantScreenState();
}

class _AddEditRestaurantScreenState extends State<AddEditRestaurantScreen> {
  TextEditingController _restaurantNameController = new TextEditingController();
  TextEditingController _restaurantPhoneController =
      new TextEditingController();
  TextEditingController _restaurantAddressController =
      new TextEditingController();

  String _restaurantNameError = "";
  String _restaurantPhoneError = "";
  String _restaurantAddressError = "";
  Map<String,String> keyWords={};

  String _selectedCityError = "";
  List<String> _categoryList = [];

  File? _storedImage;
  CityModel? selectedCity;

  @override
  void initState() {
    super.initState();
    if (widget.editRestaurant != null) {
      _restaurantNameController.text = widget.editRestaurant!.name.toString();
      _restaurantPhoneController.text = widget.editRestaurant!.phone.toString();
      _restaurantAddressController.text =
          widget.editRestaurant!.address.toString();

      print('hlepp ${widget.editRestaurant!.categoryList}');
      _categoryList = widget.editRestaurant!.categoryList ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final citiesList = Provider.of<List<CityModel>?>(context);
    final categoryList = Provider.of<List<CategoryModel>?>(context);

    widget.editRestaurant != null && citiesList != null && selectedCity == null
        ? selectedCity = citiesList
            .firstWhere((element) => element.id == widget.editRestaurant!.city)
        : '';
    Future<void> _takePicture() async {
      final imageFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 80);

      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
        print(_storedImage);
      });
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            widget.editRestaurant == null
                ? 'Add New Restaurant'
                : 'Edit Restaurant',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(5)),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.getWidth(13)),
                  child: Container(
                    height: Dimensions.getWidth(26),
                    width: Dimensions.getWidth(26),
                    color: Colors.grey,
                    child: widget.editRestaurant == null
                        ? _storedImage != null
                            ? Image.file(_storedImage!)
                            : Icon(
                                Icons.image,
                                size: 70,
                                color: Colors.white,
                              )
                        : Image.network(
                            widget.editRestaurant!.image!), // replace
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getHeight(2.0),
            ),
            TextFormBuilder(
              hint: "Restaurant Name",
              keyType: TextInputType.text,
              controller: _restaurantNameController,
              errorText: _restaurantNameError,
            ),
            SizedBox(
              height: Dimensions.getHeight(2.0),
            ),
            TextFormBuilder(
              hint: "Phone Number",
              keyType: TextInputType.phone,
              controller: _restaurantPhoneController,
              errorText: _restaurantPhoneError,
            ),
            citiesList != null
                ? DropDownCityList(
                    mList: citiesList,
                    hint: 'City',
                    selectedItem: selectedCity,
                    errorText: _selectedCityError,
                    onChange: (CityModel? value) {
                      setState(() {
                        selectedCity = value;
                        _selectedCityError = '';
                      });
                    })
                : SizedBox(),
            TextFormBuilder(
              hint: "Address",
              keyType: TextInputType.streetAddress,
              controller: _restaurantAddressController,
              errorText: _restaurantAddressError,
            ),
            SizedBox(
              height: Dimensions.getHeight(2.0),
            ),
            categoryList != null
                ? TagsWidget(
                    title: 'Category',
                    initList: widget.editRestaurant == null
                        ? []
                        : widget.editRestaurant!.categoryList!,
                    fullList: categoryList,
                    onChanged: (list) {
                      setState(() {
                        _categoryList = list;
                      });
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: Dimensions.getHeight(2.0),
            ),
            SizedBox(
              height: Dimensions.getHeight(7.0),
              child: ElevatedButton(
                onPressed: () {
                  _apiRequest();
                },
                style: ButtonStyle(
                    backgroundColor: MyColors.materialColor(Colors.green)),
                child: Text(
                  widget.editRestaurant == null
                      ? 'Add Restaurant'
                      : 'Edit Restaurant',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.getWidth(4.0),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getHeight(2.0),
            ),
          ],
        ),
      ),
    );
  }

  void _apiRequest() async {
    String restaurantName = _restaurantNameController.text;
    String restaurantPhone = _restaurantPhoneController.text;
    String restaurantAddress = _restaurantAddressController.text;

    if (restaurantName == null || restaurantName.isEmpty) {
      clear();
      setState(() {
        _restaurantNameError = "Please enter Restaurant Name";
      });
    }
    else if (restaurantPhone == null || restaurantPhone.isEmpty) {
      clear();
      setState(() {
        _restaurantPhoneError = "Please enter Restaurant Phone";
      });
    }
    else if (restaurantAddress == null || restaurantAddress.isEmpty) {
      clear();
      setState(() {
        _restaurantAddressError = "Please enter Restaurant Address";
      });
    }
    else if (widget.editRestaurant == null && _storedImage == null) {
      Fluttertoast.showToast(
          msg: "image is required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else if (_categoryList.isEmpty) {
      Fluttertoast.showToast(
          msg: "select category",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else if (selectedCity == null) {
      setState(() {
        _selectedCityError = "Please select City";
      });
    }
    else {
      clear();
      BotToast.showLoading();
      //create search keywords
      createSearchKeywordsList();
      //do request
      RestaurantModel newRestaurant = RestaurantModel(
          id: widget.editRestaurant != null ? widget.editRestaurant!.id : null,
          name: restaurantName,
          phone: restaurantPhone,
          image: widget.editRestaurant?.image,
          categoryList: _categoryList,
          keyWords: keyWords,
          address: restaurantAddress,
          rate: {},
          city: selectedCity!.id);
      widget.editRestaurant == null
          ? await DatabaseService().addRestaurant(
              newRestaurant: newRestaurant, imageFile: _storedImage!)
          : await DatabaseService().updateRestaurant(
              updatedRestaurant: newRestaurant, imageFile: _storedImage);
      BotToast.cleanAll();
      Navigator.pop(context);
    }
  }

  void createSearchKeywordsList(){
    keyWords.clear();
    keyWords['city']=selectedCity!.id.toString();
    keyWords['name']=_restaurantNameController.text.toString();

    keyWords['phone']=_restaurantPhoneController.text.toString();
    for(String item in _categoryList){
      keyWords['$item']='true';
    }

    print(keyWords.toString());
  }
  void clear() {
    setState(() {
      _restaurantNameError = "";
    });
  }
}
