import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CTransText('Hello Friend come in!').textWidget()),
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
                child: CTransText("What's cooking ? ").textWidget(),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/list',
                  );
                },
              ),
/*              Consumer<GlobalState>(
                  builder: (context, status, child) {
                  var status = context.read<GlobalState>();
                return TextButton(
                 child:
                      CTransText("Are logged-in?: " + status.isLoggedIn.toString() +
                          "\n and your id is: " +status.chefId.toString() ).textWidget(),
                  onPressed: () {
                    status.toggleLogIn();
                  },
              );
              }) */
            ]),
      ),
    );
  }
}
