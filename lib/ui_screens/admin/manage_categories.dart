import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/admin/home/admin_card.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class ManageCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mList = Provider.of<List<CategoryModel>?>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            'Manage Categories',
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
                        .map((item) => CategoryCard(
                              title: item.name!,
                              image: item.image!,
                              delete: ()async{
                                await DatabaseService().deleteCategory(deleteCategory: item);
                              },
                              edit: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddEditCategoriesScreen(
                                            editCategory: item)));
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
            builder: (_) => AddEditCategoriesScreen()));
  }
}

class AddEditCategoriesScreen extends StatefulWidget {
  final CategoryModel? editCategory;

  AddEditCategoriesScreen({this.editCategory});

  @override
  _AddEditCategoriesScreenState createState() => _AddEditCategoriesScreenState();
}

class _AddEditCategoriesScreenState extends State<AddEditCategoriesScreen> {
  TextEditingController _categoryNameController = new TextEditingController();

  String _categoryNameError = "";
   File? _storedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editCategory != null) {
      _categoryNameController.text = widget.editCategory!.name.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _takePicture() async {
      final imageFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 80);

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
            widget.editCategory == null ? 'Add New Category' : 'Edit Category',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(Dimensions.getWidth(13)),
                  child: Container(
                    height: Dimensions.getWidth(26),
                    width: Dimensions.getWidth(26),
                    color: Colors.grey,
                    child: widget.editCategory == null ?_storedImage != null
                        ? Image.file(_storedImage!)
                        : Icon(
                      Icons.image,
                      size: 70,
                      color: Colors.white,
                    ):Image.network(widget.editCategory!.image!), // replace
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Category Name",
              keyType: TextInputType.text,
              controller: _categoryNameController,
              errorText: _categoryNameError,
            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
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
                  widget.editCategory == null ? 'Add Category' : 'Edit Category',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.getWidth(4.0),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _apiRequest() async {
    String categoryName = _categoryNameController.text;
    if (categoryName == null || categoryName.isEmpty) {
      clear();
      setState(() {
        _categoryNameError = "Please enter Category Name";
      });
    }else if(widget.editCategory == null&&_storedImage==null){
      Fluttertoast.showToast(
          msg: "image is required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      clear();

      //do request
      CategoryModel newCategory = CategoryModel(id: widget.editCategory != null ? widget.editCategory!.id : null, name: categoryName,image:widget.editCategory?.image);
      widget.editCategory == null
          ? await DatabaseService().addCategory(newCategory: newCategory,imageFile: _storedImage!)
          : await DatabaseService().updateCategory(updatedCategory: newCategory,imageFile: _storedImage);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _categoryNameError = "";
    });
  }
}
