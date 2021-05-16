
import 'package:flutter/material.dart';
import 'package:coalam_app/GlobalParamaters.dart';


class RecipeDetailsScreen extends StatelessWidget {
  String id;

  RecipeDetailsScreen({
    this.id,
  });


  @override
  Widget build(BuildContext context) {
    Map<String, String> _test = Recettes[int.parse(id)];
    String title = _test['title'];
    String cook = _test['cook'];

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Viewing details for $title by $cook'),
            TextButton(
              child: Text('back!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
