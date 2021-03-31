import 'package:flutter/material.dart';

class GetErrorWidget extends StatelessWidget {
  final bool? isValid;
  final String? errorText;

  GetErrorWidget({this.isValid, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isValid!,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.only(top: 5),
        alignment: Alignment.centerLeft,
        child: Text(
          '$errorText',
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
