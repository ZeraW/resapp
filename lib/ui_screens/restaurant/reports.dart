import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/utils/dimensions.dart';
import '../../models/db_model.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final report = Provider.of<ReportModel?>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Report',
      )),
      body: report != null && report.report != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Total Orders : ",
                        style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${report.report!['countTotal']}",
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Total Profit : ",
                        style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${report.report!['priceTotal']} L.E",
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "More info : ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getWidth(2),
                          vertical: Dimensions.getHeight(0)),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        String key = report.report!.keys.elementAt(index);
                        return key != 'countTotal' && key != 'priceTotal'
                            ? ListTile(
                                title: Row(
                                  children: [
                                    Text("$key : "),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${report.report![key]}",
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox();
                      },
                      itemCount: report.report!.length,
                    ),
                  ),
                ),
              ],
            )
          : Center(child: Text('No reports Found',style: TextStyle(color: Colors.white,fontSize: 18),)),
    );
  }
}
