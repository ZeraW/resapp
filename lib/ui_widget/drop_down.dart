import 'package:flutter/material.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

import 'error_widget.dart';

class DropDownStringList extends StatelessWidget {
  final List<String>? mList;
  final Function? onChange;
  final String? errorText, hint, selectedItem;
  final bool enableBorder;

  DropDownStringList(
      {this.selectedItem,
      this.mList,
      this.hint,
      this.onChange,
      this.errorText,
      this.enableBorder = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: enableBorder ? null : Dimensions.getHeight(3.5),
          padding: enableBorder
              ? EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2))
              : null,
          decoration: BoxDecoration(
            border: enableBorder
                ? Border.all(color: Colors.black54, style: BorderStyle.solid)
                : null,
            borderRadius: enableBorder ? BorderRadius.circular(4) : null,
          ),
          child: new DropdownButton<String>(
              items: mList!.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text('$hint: $value'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: MyColors().mainColor,
              ),
              hint: Center(
                child: Text(
                  selectedItem != null
                      ? '$hint: $selectedItem'
                      : 'Choose $hint',
                  style: TextStyle(
                      color: MyColors().mainColor, fontSize: Dimensions.getWidth(4)),
                ),
              ),
              onChanged: onChange as void Function(String?)?),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}

class DropDownCityList extends StatelessWidget {
  final CityModel? selectedItem;
  final List<CityModel> mList;
  final void Function(CityModel?)? onChange;
  final String? hint;
  final String? errorText;

  DropDownCityList(
      {this.selectedItem,
      required this.mList,
      this.hint,
      this.onChange,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getWidth(5),
          vertical: Dimensions.getHeight(1.5)),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(1),vertical: Dimensions.getHeight(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('$hint',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: Dimensions.getWidth(3.5),
                    fontWeight: FontWeight.w500)),
          ),
          new DropdownButton<CityModel>(
              items: mList.map((CityModel value) {
                return new DropdownMenuItem<CityModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '${selectedItem!.name}'
                    : 'Choose $hint',
                style: TextStyle(
                    color: MyColors().mainColor, fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
          errorText != null
              ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
              : SizedBox()
        ],
      ),
    );
  }
}

class DropDownCategoryList extends StatelessWidget {
  final CategoryModel? selectedItem;
  final List<CategoryModel> mList;
  final void Function(CategoryModel?)? onChange;
  final String? hint;
  final String? errorText;

  DropDownCategoryList(
      {this.selectedItem,
        required this.mList,
        this.hint,
        this.onChange,
        this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getWidth(5),
          vertical: Dimensions.getHeight(1.5)),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(1),vertical: Dimensions.getHeight(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('$hint',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: Dimensions.getWidth(3.5),
                    fontWeight: FontWeight.w500)),
          ),
          new DropdownButton<CategoryModel>(
              items: mList.map((CategoryModel value) {
                return new DropdownMenuItem<CategoryModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '${selectedItem!.name}'
                    : '$hint',
                style: TextStyle(
                    color: MyColors().mainColor, fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
          errorText != null
              ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
              : SizedBox()
        ],
      ),
    );
  }
}

class DropDownPriceList extends StatelessWidget {
  final List<PriceModel> mList;
  void Function(PriceModel?)? onChange;
  PriceModel? selectedItem;
  final String? hint;

  DropDownPriceList(
      {required this.mList,
        this.hint,
        this.selectedItem,
        this.onChange,});


  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
        child: new DropdownButton<PriceModel>(
            items: mList.map((PriceModel value) {
              return new DropdownMenuItem<PriceModel>(
                value: value,
                child: new Text('${value.size}',style: TextStyle(color: Colors.black45),),
              );
            }).toList(),
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down,color: Colors.lightBlueAccent,),
            hint: Text('${selectedItem!.size}',
              style: TextStyle(
                  color: Colors.lightBlueAccent, fontSize: Dimensions.getWidth(4)),
            ),
            onChanged: onChange),
      ),
    );
  }
}


/*

class DropDownCityList extends StatelessWidget {
  final PriceModel? selectedItem;
  final List<CityModel>? mList;
  final Function? onChange;
  final String? hint;
  final String? errorText;

  DropDownCityList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<CityModel>(
              items: mList!.map((CityModel value) {
                return new DropdownMenuItem<CityModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '$hint: ${selectedItem!.name}'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  Uti().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange as void Function(CityModel?)?),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}

class DropDownTrainList extends StatelessWidget {
  final TrainModel? selectedItem;
  final List<TrainModel>? mList;
  final Function? onChange;
  final String? errorText;

  DropDownTrainList(
      {this.selectedItem, this.mList, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<TrainModel>(
              items: mList!.map((TrainModel value) {
                return new DropdownMenuItem<TrainModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? 'Train: ${selectedItem!.name}'
                    : 'Choose Train',
                style: TextStyle(
                    color:  Uti().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange as void Function(TrainModel?)?),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}
*/
