import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resapp/utils/dimensions.dart';

import 'error_widget.dart';

class TextFormBuilder extends StatefulWidget {
  final String? hint;
  final TextInputType? keyType;
  final bool? isPassword, enabled;
  final TextEditingController? controller;
   String? errorText;

  TextFormBuilder({
    this.hint,
    this.keyType,
    this.isPassword,
    this.controller,
    this.errorText,
    this.enabled = true,
  });

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getHeight(1.5),
            horizontal: Dimensions.getWidth(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${widget.hint}',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: Dimensions.getWidth(3.5),
                      fontWeight: FontWeight.w500)),
            ),
            TextFormField(
                style: TextStyle(
                    color: Colors.black, fontSize: Dimensions.getWidth(3.5)),
                // maxLength: maxLength,
                controller: widget.controller,
                onChanged: (val){
                  setState(() {
                    widget.errorText = '';

                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter a valid text";
                  }
                  return null;
                },
                enabled: widget.enabled,
                //controller: _controller,
                maxLines: 1,
                //onChanged: onChange,
                keyboardType: widget.keyType != null ? widget.keyType : TextInputType.text,
                obscureText: widget.isPassword != null ? widget.isPassword! : false,
                decoration: InputDecoration(
                  hintText: "Enter ${widget.hint}",
                  hintStyle: TextStyle(
                      color: Colors.black, fontSize: Dimensions.getWidth(3.5)),
                  errorStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500),
                  fillColor: Colors.black,
                )),
            widget.errorText != null
                ? GetErrorWidget(isValid: widget.errorText != "", errorText: widget.errorText)
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
