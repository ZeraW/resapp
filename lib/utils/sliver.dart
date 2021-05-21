
import 'package:flutter/material.dart';

class SliverWidget extends StatelessWidget {
  String?image;
  double? imageHeight;
  Widget? title = Text('');
  List<Widget> children;

  SliverWidget({this.title,required this.image,required this.imageHeight,required this.children});

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: new FlexibleSpaceBar(
            title: title,
            background: new Image.network('$image'),
          ),
        ),
        new SliverPadding(
          padding: new EdgeInsets.all(16.0),
          sliver: new SliverList(
            delegate: new SliverChildListDelegate(children),
          ),
        ),
      ],
    );
  }
}
