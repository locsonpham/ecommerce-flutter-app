import 'package:flutter/material.dart';

Widget cartWidget(BuildContext context, int quantity) {
  return Container(
    // color: Colors.blue,
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/cart");
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ))
        ],
      ),
    ),
  );
}
