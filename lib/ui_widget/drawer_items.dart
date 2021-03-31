import 'package:flutter/material.dart';
import 'package:resapp/utils/dimensions.dart';

class DrawerItem extends StatelessWidget {
  final String image; final String title;final Function() onTap;

  DrawerItem(this.image, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 70,
            height: 70,
          ),
          SizedBox(
            height: Dimensions.getHeight(2),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: Dimensions.getWidth(4)),
          )
        ],
      ),
    );
  }
}
