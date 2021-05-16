import 'package:flutter/material.dart';
import 'package:coalam_app/GlobalParamaters.dart';

class RecipesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [for(var i=0; i<=Recettes.length-1; i+=1) RecipeElement(Recettes[i],i)],
      ),
    );
  }
}

class RecipeElement extends StatelessWidget {
  final Map<String, String> Recette;
  final int id;
  RecipeElement(this.Recette, this.id);

  @override
  Widget build(BuildContext context) {

    String title = Recette['title'];
    String cook = Recette['cook'];
    return Container(
      child:
      Center(
        child: TextButton(
          child: Text('View Details stuff for $title'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/details/'+id.toString(),
            );
          },
        ),
      ),
    );
  }
}
