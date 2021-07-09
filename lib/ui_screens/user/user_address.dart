import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resapp/models/db_model.dart';
import 'package:resapp/server/database_api.dart';
import 'package:resapp/ui_screens/user/payment_method.dart';
import 'package:resapp/ui_widget/show_cart.dart';
import 'package:resapp/ui_widget/textfield_widget.dart';
import 'package:resapp/utils/responsive.dart';
import 'package:resapp/utils/utils.dart';

class UserAddress extends StatefulWidget {
  OrderModel newOrder;

  UserAddress(this.newOrder);

  @override
  _UserAddressState createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        BotToast.removeAll('address');
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SELECT DELIVERY ADDRESS'),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: Responsive.height(context, 13)),
          child: ListView(
            children: [
              MultiProvider(
                providers: [
                  StreamProvider<List<AddressModel>?>.value(
                      initialData: null,
                      value: DatabaseService().getLiveAddress),
                ],
                child: AddressList(widget.newOrder),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isDesktop()?250:20),
                child: ListTile(
                  tileColor: MyColors().mainColor.withBlue(65),
                  onTap: () {
                    addNewAddress();
                  },
                  title: Text(
                    'ADD New Address',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.add_circle,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
              SizedBox(height: Responsive.height(context, 1))
            ],
          ),
        ),
      ),
    );
  }

  void addNewAddress() {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _addressController = new TextEditingController();
    TextEditingController _phoneController = new TextEditingController();

    String _titleError = "";
    String _addressError = "";
    String _phoneError = "";
    void clear() {
      setState(() {
        _phoneError = "";
        _titleError = '';
        _addressError = '';
      });
    }

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setStatex) {
              return AlertDialog(
                title: Text('Add New Address'),
                content: SizedBox.fromSize(
                  size: Size(Responsive.width(context, 100),
                      Responsive.height(context, 45)),
                  child: ListView(
                    children: [
                      TextFormBuilder(
                        hint: "Address Title",
                        controller: _titleController,
                        errorText: _titleError,
                      ),
                      TextFormBuilder(
                        hint: "Address",
                        controller: _addressController,
                        errorText: _addressError,
                      ),
                      TextFormBuilder(
                        hint: "Phone Number",
                        controller: _phoneController,
                        keyType: TextInputType.phone,
                        errorText: _phoneError,
                      ),
                      OnClick(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                                child: Text(
                              'Add New Address',
                              style: TextStyle(
                                  color: MyColors().textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            )),
                          ),
                          color: Colors.amberAccent,
                          onTap: () {
                            String title = _titleController.text;
                            String address = _addressController.text;
                            String phone = _phoneController.text;

                            if (title.isEmpty) {
                              _titleError = "Please enter address Title";
                              setStatex(() {});
                            } else if (address.isEmpty) {
                              clear();
                              _addressError = "Please enter address";
                              setStatex(() {});
                            } else if (phone.isEmpty) {
                              clear();
                              _phoneError = "Please enter phone number";
                              setStatex(() {});
                            } else {
                              clear();
                              DatabaseService().addAddress(
                                  newAddress: AddressModel(
                                      phone: phone,
                                      address: address,
                                      addressTitle: title));
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                ),
              );
            }));
  }
}

class AddressList extends StatefulWidget {
  OrderModel newOrder;

  AddressList(this.newOrder);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  List<FoodModel> holderList = [];
  AddressModel? selectedAddress;

  @override
  Widget build(BuildContext context) {
    final addressList = Provider.of<List<AddressModel>?>(context);
    ShowCart(context).showPaymentDialog(key: 'address',onTap: () {
      // BotToast.removeAll('payment');
      // Navigator.push(context, MaterialPageRoute(builder: (_) => UserAddress()));
      // placeOrder(mCart);

      if(selectedAddress==null){
        BotToast.showText(text: 'Choose Delivery Address',contentColor: Colors.redAccent);
      }else{
        widget.newOrder.address = selectedAddress;
        Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentMethods(widget.newOrder)));
      }

    });
    return addressList != null
        ? ListView.builder(
            itemCount: addressList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  selectedAddress = addressList[index];
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: Responsive.isDesktop()?250:0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: MyColors().mainColor.withBlue(60),
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(10) ,topRight:Radius.circular(10) )
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${addressList[index].addressTitle}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Spacer(),
                            selectedAddress != null &&
                                    selectedAddress!.id == addressList[index].id
                                ? Icon(
                                    Icons.radio_button_checked_outlined,
                                    color: Colors.amberAccent,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.white70,
                                  )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${addressList[index].address}',
                                style: TextStyle(
                                    color: MyColors().textColor, fontSize: 16)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${addressList[index].phone}',
                                style: TextStyle(
                                    color: MyColors().textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
        : SizedBox();
  }
}
