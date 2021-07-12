import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resapp/utils/dimensions.dart';
import 'package:resapp/utils/utils.dart';

class AdminCard extends StatelessWidget {
  final String title;
  final Widget open;

  AdminCard({required this.title, required this.open});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox.fromSize(
        size: Size(Dimensions.getWidth(100,web: 70), Dimensions.getWidth(25)),
        // button width and height
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.green, // splash color
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => open));
              }, // button pressed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        color: Colors.green,
                        child: Icon(
                          Icons.list,
                          color: MyColors().white,
                          size: Dimensions.getWidth(8),
                        ),
                      )),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimensions.getHeight(0.5)),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          color: MyColors().mainColor,
                          fontSize: Dimensions.getWidth(5,web: 3.5),
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  String? title;
  Function()? edit;
  Key? key;
  CityCard({this.title, this.key, this.edit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox.fromSize(
        size: Size(Dimensions.getWidth(100,web: 70), Dimensions.getWidth(15)),
        child: Center(
          child: Card(
            child: ListTile(
              title: Text(
                '$title',
                style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
              ),
              leading: Icon(Icons.apartment,size: Dimensions.getWidth(8),color: MyColors().mainColor,),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: edit, child: Icon(Icons.edit,color: Colors.green,)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  String? title;
  String image;
  Function()? edit,delete,manage;
  Key? key;
  CategoryCard({this.title,required this.image, this.key,this.manage, this.edit,this.delete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox.fromSize(
        size: Size(Dimensions.getWidth(100,web: 70), Dimensions.getWidth(15)),
        child: Center(
          child: Card(
            child: ListTile(
              onTap: manage,
              title: Text(
                '$title',
                style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
              ),
              leading: Image.network(image,height: Dimensions.getWidth(10),width:Dimensions.getWidth(10)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: edit, child: Icon(Icons.edit,color: Colors.green,)),
                  SizedBox(width: Dimensions.getWidth(2),),
                  GestureDetector(onTap: delete, child: Icon(Icons.delete_outline_outlined,color: Colors.redAccent,)),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  String? title,phone;
  String image;
  Function()? report,edit,delete,manage;
  Key? key;
  RestaurantCard({this.title,required this.image,this.phone, this.report,this.key,this.manage, this.edit,this.delete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Card(
          child: ListTile(
            onTap: manage,
            title: Text(
              '$title',
              style: TextStyle(fontSize: Dimensions.getWidth(4.5),fontWeight: FontWeight.w600),
            ),
            leading: Image.network(image,height: Dimensions.getWidth(10),width:Dimensions.getWidth(10)),
            subtitle: Padding(
              padding:  EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'phone : $phone',
                style: TextStyle(fontSize: Dimensions.getWidth(3.5)),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(onTap: report, child: Icon(Icons.article_outlined,color: Colors.blue,size: Dimensions.getWidth(6),)),
                SizedBox(width: Dimensions.getWidth(3),),
                GestureDetector(onTap: edit, child: Icon(Icons.edit,color: Colors.green,size: Dimensions.getWidth(6),)),
                SizedBox(width: Dimensions.getWidth(3),),
                GestureDetector(onTap: delete, child: Icon(Icons.delete_outline_outlined,color: Colors.redAccent,size: Dimensions.getWidth(6),)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class UsersCard extends StatelessWidget {
  String? name,email,password;
  String image;
  Key? key;
  UsersCard({this.name,this.email,this.password,required this.image, this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Card(
          child: ListTile(

            title: Text(
              '$name',
              style: TextStyle(fontSize: Dimensions.getWidth(4.5),fontWeight: FontWeight.w600),
            ),
            leading: Image.network(image,height: Dimensions.getWidth(10),width:Dimensions.getWidth(10)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(
                  'Mail : $email',
                  style: TextStyle(fontSize: Dimensions.getWidth(3.5)),
                ),
                Text(
                  'Pw : $password',
                  style: TextStyle(fontSize: Dimensions.getWidth(3.5)),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}