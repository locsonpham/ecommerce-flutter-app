import 'package:flutter/material.dart';
import 'package:http_request/modules/product/bloc/product_bloc.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/product_detail/screen/product_detail_screen.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';

import '../../../networking/response.dart';
import '../../../utils/number_format.dart';

class ProductsScreen extends StatefulWidget {
  int category_id;
  String name;

  ProductsScreen(this.category_id, this.name);
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc _productBloc;
  String dropdownValue;

  int _sortIndex = 0;
  List<SortProductList> _sortCommands = [
    SortProductList(key: "price_desc", title: "Giá giảm dần"),
    SortProductList(key: "price_asc", title: "Giá tăng dần"),
    SortProductList(key: "newest", title: "Sản phẩm mới")
  ];

  @override
  initState() {
    super.initState();
    _productBloc = new ProductBloc();
    _productBloc.fetchProductsByCategoryId(widget.category_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
      ),
      body: _bodyBuilder(context),
      endDrawer: _drawerBuilder(context),
    );
  }

  var _txtMinPrice = new TextEditingController(text: "0");
  var _txtMaxPrice = new TextEditingController(text: "0");

  Widget _drawerBuilder(BuildContext context) {
    return Drawer(
      child: Container(
          // color: Colors.blue,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.5)),
                  ),
                  child: ListTile(
                    title: Text(
                      "Bộ lọc sản phẩm",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    trailing: Icon(Icons.close),
                  )),
              Container(
                padding:
                    EdgeInsets.only(top: 15, left: 10, bottom: 15, right: 10),
                decoration: BoxDecoration(
                    // color: Colors.red,
                    border: Border(bottom: BorderSide(width: 0.5))),
                child: Text("Khoảng giá"),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.5))),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 30,
                        child: TextFormField(
                          controller: _txtMinPrice,
                          decoration: InputDecoration(
                            labelText: "Nhỏ nhất (đ)",
                            labelStyle: TextStyle(fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text("-"),
                    ),
                    Container(
                        width: 100,
                        height: 30,
                        child: TextFormField(
                          controller: _txtMaxPrice,
                          decoration: InputDecoration(
                            labelText: "Lớn nhất (đ)",
                            labelStyle: TextStyle(fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.white,
                            textColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text("Hủy"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              getFilteredProductsByPrice(
                                  context,
                                  int.parse(_txtMinPrice.value.text),
                                  int.parse(_txtMaxPrice.value.text),
                                  _sortCommands[_sortIndex].key);
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text(
                              "Áp dụng",
                            ),
                          ),
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }

  void getFilteredProductsByPrice(
      BuildContext context, int low_price, int high_price, String order) {
    if ((low_price == null) || (high_price == null)) {
      return;
    }
    if ((low_price > high_price)) {
      return;
    }

    var params = Map<String, dynamic>();
    params["order"] = order;
    params["price"] = low_price.toString() + "%2C" + high_price.toString();
    _productBloc.fetchProductsByCategoryIdParams(widget.category_id, params);
    Navigator.pop(context);
  }

  Widget _bodyBuilder(BuildContext context) {
    return Container(
      child: StreamBuilder<Response<List<ProductModel>>>(
        stream: _productBloc.productDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return loadingScreen2();
              case Status.COMPLETED:
                return _productsScreen(context, snapshot);
              case Status.ERROR:
                return Container(
                  child: Text('error'),
                );
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _productsScreen(BuildContext context, AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Container(
          child: Center(
              child: Column(
        children: <Widget>[
          _sortBar(context, snapshot),
          SizedBox(
            height: 10,
          ),
          _productList(context, snapshot),
        ],
      ))),
    );
  }

  Widget _sortBar(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 8,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      child: Icon(
                        Icons.swap_vert,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  _sortDropdownSelect(),
                ],
              )),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                // print('filter');
                Scaffold.of(context).openEndDrawer();
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      child: Icon(Icons.tune),
                    ),
                  ),
                  Text("Bộ lọc")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortDropdownSelect() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: InkWell(
            onTap: () {
              _modalBottomSheetSort(context);
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_drop_down),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    _sortCommands[_sortIndex].title,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _modalBottomSheetSort(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(left: 10, top: 5, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Sắp xếp theo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.clear),
                    ],
                  ),
                ),
                _listOfSort(context),
              ],
            ),
          );
        });
  }

  Widget _listOfSort(BuildContext context) {
    return Container(
      height: 300, // need to check again
      margin: EdgeInsets.only(left: 20),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _sortCommands.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _sortIndex = index;
                  var _params = Map<String, dynamic>();
                  _params["order"] = _sortCommands[index].key;

                  _productBloc.fetchProductsByCategoryIdParams(
                      widget.category_id, _params);
                  Navigator.pop(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border(
                  top: (index == 0) ? BorderSide(width: 1.0) : BorderSide.none,
                  bottom: BorderSide(width: 0.3),
                )),
                child: ListTile(
                  title: Text(_sortCommands[index].title),
                  trailing: Icon(Icons.chevron_right),
                ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(
                //       _sortCommands[index].title,
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //     Icon(Icons.chevron_right),
                //   ],
                // ),
              ),
            );
          }),
    );
  }

  Widget _productList(BuildContext context, AsyncSnapshot snapshot) {
    num _countValue = 2;
    num _aspectWidth = 2;
    num _aspectHeight = 1.5;

    List<ProductModel> _products = snapshot.data.data;

    return Container(
      child: Container(
          // height: 1000,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: (_aspectHeight / _aspectWidth),
                crossAxisCount: _countValue,
                children: List.generate(
                  _products.length,
                  (index) => productWidget(context, _products[index]),
                ),
              )
            ],
          )),
    );
  }
}
