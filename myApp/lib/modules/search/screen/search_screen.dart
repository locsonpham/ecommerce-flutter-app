import 'package:flutter/material.dart';
import 'package:http_request/modules/product/model/product_model.dart';
import 'package:http_request/modules/search/bloc/search_bloc.dart';
import 'package:http_request/modules/search/model/search_model.dart';
import 'package:http_request/modules/search/screen/search_result.dart';
import 'package:http_request/networking/response.dart';
import 'package:http_request/pages/loading_screen.dart';
import 'package:http_request/pages/product_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc _bloc;
  TextEditingController searchInputController;
  var _recentSearch = List<String>(5);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = new SearchBloc();

    searchInputController = TextEditingController();
    _bloc.getSearchKeyList().then((result) {
      setState(() {
        _recentSearch = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tìm kiếm"),
      ),
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        children: <Widget>[
          _searchInput(context),
          _recentSearchKey(context),
          // _searchResult(context)
        ],
      )),
    );
  }

  Widget _searchInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: TextFormField(
          controller: searchInputController,
          onChanged: (value) {},
          onEditingComplete: () {
            _bloc.addSearchKeyList(searchInputController.value.text);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResultScreen(
                        searchInputController.value.text, 1)));
          },
          onFieldSubmitted: (value) {},
        ),
      ),
    );
  }

  Widget _recentSearchKey(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Tìm kiếm gần đây",
            style: TextStyle(color: Colors.grey),
          ),
          _listOfRecentSearch(context),
        ],
      ),
    );
  }

  Widget _listOfRecentSearch(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recentSearch.length,
          itemBuilder: (BuildContext context, int index) {
            if (_recentSearch[index] == null) return Container();

            return InkWell(
              onTap: () {
                searchInputController.text = _recentSearch[index];
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey)),
                child: Center(child: Text(_recentSearch[index])),
              ),
            );
          }),
    );
  }

  Widget _searchResult(BuildContext context) {
    return Container(
      child: StreamBuilder<Response<SearchResponse>>(
        stream: _bloc.searchDataStream,
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
    num _countValue = 2;
    num _aspectWidth = 2;
    num _aspectHeight = 1.5;

    List<ProductModel> _products =
        List<ProductModel>.from(snapshot.data.data.data["products"].map((x) {
      return ProductModel.fromJson(x);
    }));

    // print(_products);

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
