import 'package:flutter/material.dart';

class FullScreenChart extends StatelessWidget {
  final Widget _widget;

  FullScreenChart(this._widget);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Title(
                color: Colors.white,
                child: Text("this.title"),
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.0),
                topRight: Radius.circular(7.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ],
            ),
            child: ,
          ),
        ),
      ),
    );
  }
}
