import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_widget/admin/home/admin_card.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class ManageCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mList = Provider.of<List<CityModel>?>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            'Manage Cities',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null
          ? /*ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth(2),
                  vertical: Dimensions.getHeight(1.5)),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return CityCard(
                  title: mList[index].name,
                  edit: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditCitiesScreen(editCity: mList[index])));
                  },
                );
              },
              itemCount: mList.length,
            )*/ListView(
              children: [
                Center(
                  child: Wrap(
        children: mList.map((item) => CityCard(
          title: item.name,
          edit: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AddEditCitiesScreen(editCity: item)));
          },
        )).toList().cast<Widget>(),
      ),
                ),
              ],
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(context: context,nextId: mList!=null ? mList.length+1:0),
        tooltip: 'Increment',
        backgroundColor: Colors.green.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment({required BuildContext context,required int nextId}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddEditCitiesScreen(nextId: nextId.toString(),)));
  }
}
class AddEditCitiesScreen extends StatefulWidget {
  final CityModel? editCity;
  final String? nextId;
  AddEditCitiesScreen({this.editCity,this.nextId});

  @override
  _AddEditCitiesScreenState createState() => _AddEditCitiesScreenState();
}
class _AddEditCitiesScreenState extends State<AddEditCitiesScreen> {
  TextEditingController _cityNameController = new TextEditingController();

  String _cityNameError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editCity != null) {
      _cityNameController.text = widget.editCity!.name.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().mainColor,
          title: Text(
            widget.editCity == null ? 'Add New City' : 'Edit City',
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
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
    
            TextFormBuilder(
              hint: "City Name",
              keyType: TextInputType.text,
              controller: _cityNameController,
              errorText: _cityNameError,

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
                style:ButtonStyle(backgroundColor: MyColors.materialColor(Colors.green)),
                child: Text(
                  widget.editCity == null ? 'Add City' : 'Edit City',
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
    String cityName = _cityNameController.text;
    if (cityName == null || cityName.isEmpty) {
      clear();
      setState(() {
        _cityNameError = "Please enter City Name";
      });
    } else {
      clear();
      //do request
      CityModel newCity = CityModel(id: widget.editCity != null? widget.editCity!.id:widget.nextId,name: cityName);
      widget.editCity == null
          ? await DatabaseService().addCity(newCity: newCity)
          : await DatabaseService().updateCity(updatedCity: newCity);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}
