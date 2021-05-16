import 'package:flutter/material.dart';
import 'package:coalam_app/GlobalParamaters.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: Text("What's cooking?"),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/list',
            );
          },
        ),
      ),
      );
  }
}


