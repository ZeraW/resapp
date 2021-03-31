import 'package:flutter/material.dart';
import 'package:resapp/utils/dimensions.dart';

class _MyCard extends StatelessWidget {
  String title;
  Widget child;
  Function() addItem;

  _MyCard({required this.title, required this.child, required this.addItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          top: 2,left: Dimensions.getWidth(3),right:Dimensions.getWidth(3) ,bottom: Dimensions.getHeight(1.5),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${title}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: Dimensions.getWidth(3.5),
                        fontWeight: FontWeight.w500)),
                Spacer(),
                SizedBox.fromSize(
                  size: Size(40, 40),
                  child: FloatingActionButton(
                    onPressed: addItem,
                    tooltip: 'Increment',
                    backgroundColor: Colors.green.withOpacity(0.9),
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                )
              ],
            ),
            Align(alignment: Alignment.topLeft, child: child)
          ],
        ),
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  final String tag;
  final Function() onTap;

  _TagItem({required this.tag, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Material(
          color: Colors.green,
          child: InkWell(
            splashColor: Colors.grey,
            onTap: onTap,
            child: IntrinsicWidth(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                  child: Row(
                    children: [
                      Flexible(
                          child: Text(
                        '$tag',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.cancel_sharp,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic> initialSelectedValues;
  final String title;

  MultiSelectDialog(
      {Key? key, required this.items, required this.initialSelectedValues,required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<dynamic> _selectedValues = [];

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(dynamic itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select ${widget.title}'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context, _selectedValues),
        )
      ],
    );
  }

  Widget _buildItem(dynamic item) {
    final checked = _selectedValues.contains(item);
    return CheckboxListTile(
      value: checked,
      title: Text(item.name),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item, checked!),
    );
  }
}

class TagsWidget extends StatefulWidget {
  List<String> initList = [];
  List<dynamic> fullList = [];
  ValueChanged<List<String>> onChanged;
  String title;

  TagsWidget(
      {required this.fullList,
      required this.initList,
      required this.onChanged,
      required this.title});

  @override
  _TagsWidgetState createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  List<dynamic> selectedList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (String item in widget.initList) {
      selectedList.add(widget.fullList.firstWhere((element) => element.id == item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _MyCard(
      addItem: () {
        _showMultiSelect(context, widget.fullList);
      },
      title: widget.title,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: selectedList
              .map((item) =>
                _TagItem( //todo solve the name problem ( find a way to pass it )
                    tag: item.name,
                    onTap: () {
                      setState(() {
                        selectedList           //todo solve the id problem ( find a way to pass it )
                            .removeWhere((element) => element.id == item.id);
                        List<String> oo = selectedList
                            .map((e) => e.id)  //todo solve the id problem ( find a way to pass it )
                            .cast<String>()
                            .toList();
                        widget.onChanged(oo);
                      });
                    })
              )
              .toList()
              .cast<Widget>(),
        ),
      ),
    );
  }

  void _showMultiSelect(
      BuildContext context, var fullList) async {
    final selectedValues = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: widget.title,
          items: fullList,
          initialSelectedValues: selectedList,
        );
      },
    );                                        //todo solve the id problem ( find a way to pass it )
    List<String> oo = selectedValues.map((e) => e.id).cast<String>().toList();
    widget.onChanged(oo);

    setState(() {
      selectedList = selectedValues;
    });
  }
}
