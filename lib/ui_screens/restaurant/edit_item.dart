import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/ui_widget/drop_down.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

import 'continue_edit_item.dart';

class EditItem extends StatefulWidget {
  final FoodModel foodItem;
  final List<CategoryModel> categoryList;

  EditItem({required this.foodItem,required this.categoryList});

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _detailsController = new TextEditingController();
  CategoryModel? selectedCategory;
  String _nameError = "";
  String _detailsError = "";
  String _selectedCategoryError = "";

  File? _storedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.foodItem.name!;
    _detailsController.text = widget.foodItem.details!;
    selectedCategory = widget.categoryList.firstWhere((element) => element.id ==
        widget.foodItem.category);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _takePicture() async {
      final imageFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 80);

      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
        print('_storedImage');

        print(_storedImage);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit NEW ITEM')),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getHeight(2),
            horizontal: Dimensions.getWidth(4)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.getWidth(3)),
                    child: Container(
                      height: Dimensions.getWidth(26),
                      width: Dimensions.getWidth(26),
                      color: Colors.grey,
                      child: _storedImage != null
                          ? Image.file(_storedImage!)
                          : Image.network(widget.foodItem.image!), // replace
                    ),
                  ),
                  IntrinsicWidth(
                    child: ListTile(
                      onTap: _takePicture,
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          color: MyColors().mainColor,
                        ),
                        backgroundColor: MyColors().accentColor,
                      ),
                      title: Text(
                        'Add Item Picture',
                        style: MyStyle().whiteStyleW600(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.getHeight(2),
              ),
              TextFormBuilder(
                hint: "Item Title",
                controller: _nameController,
                errorText: _nameError,
              ),
              SizedBox(
                height: Dimensions.getHeight(1.5),
              ),
              TextFormBuilder(
                hint: "Details",
                controller: _detailsController,
                errorText: _detailsError,
              ),
              DropDownCategoryList(
                  mList: widget.categoryList,
                  hint: 'Select Item Category',
                  selectedItem: selectedCategory,
                  errorText: _selectedCategoryError,
                  onChange: (CategoryModel? value) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      selectedCategory = value;
                      _selectedCategoryError = '';
                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.amberAccent)),
                  onPressed: () {
                    _addItem(context);
                  },
                  child: Text(
                    "CONTINUE",
                    style: MyStyle().bigBold(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addItem(BuildContext context) async {
    String name = _nameController.text;
    String details = _detailsController.text;

    if (name.isEmpty) {
      setState(() {
        _nameError = "Please enter item name";
      });
    } else if (details.isEmpty) {
      clear();
      setState(() {
        _detailsError = "Please enter item details";
      });
    } else if (selectedCategory == null) {
      clear();
      setState(() {
        _selectedCategoryError = "Please select Category";
      });
    } else {
      clear();
      FoodModel newFoodItem = FoodModel(
          name: name,
          details: details,
          restaurantId: widget.foodItem.restaurantId,
          category: selectedCategory!.id,
          price: widget.foodItem.price,
          id: widget.foodItem.id,
          keyWords: widget.foodItem.keyWords,
          image: _storedImage == null ? widget.foodItem.image:null);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ContinueEditItem(
                    image: _storedImage,
                    foodItem: newFoodItem,
                  )));
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _detailsError = "";
      _selectedCategoryError = "";
    });
  }
}
