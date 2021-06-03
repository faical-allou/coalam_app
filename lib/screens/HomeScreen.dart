import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/kitchen.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("What's cooking ? "),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/list',
                  );
                },
              ),
              Consumer<GlobalState>(
                  builder: (context, status, child) {
                  var status = context.read<GlobalState>();
                return TextButton(
                  child:
                      Text("Toggle current status: " + status.isLoggedIn.toString()),
                  onPressed: () {
                    status.toggleLogIn();
                  },
                );
              })
            ]),
      ),
    );
  }
}
