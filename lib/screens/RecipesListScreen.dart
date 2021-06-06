import 'package:flutter/material.dart';
import 'package:coalam_app/main.dart';
import 'package:coalam_app/models.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:coalam_app/screens/AccountEditScreen.dart';
import 'package:coalam_app/screens/RecipeEditScreen.dart';

class RecipesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: fetchAllRecipes(),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(),
                body: Align(
                  child: ListView(
                    children: [
                      for (var i = 0; i <= snapshot.data.length - 1; i += 1)
                        RecipeElement(snapshot.data[i], i + 1),
                      Consumer<GlobalState>(builder: (context, status, child) {
                        var status = context.read<GlobalState>();
                        return TextButton(
                          child: Text("Are logged-in?: " +
                              status.isLoggedIn.toString() +
                              "\n and your id is: " +
                              status.chefId.toString()),
                          onPressed: () {
                            status.setChefId(0);
                            status.toggleLogIn();
                          },
                        );
                      })
                    ],
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<GlobalState>(
                          builder: (context, status, child) {
                            var status = context.read<GlobalState>();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_box),
                                    tooltip: 'add Recipe',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipeEditScreen(
                                                      recipe:
                                                          Recipe(id:0, chefId: status.chefId, name: null, details: null),
                                                      imageInput: null)));
                                    }),
                                Text('add Recipe'),
                              ],
                            );
                          },
                        ),
                        Consumer<GlobalState>(
                            builder: (context, status, child) {
                          var status = context.read<GlobalState>();
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.account_box),
                                    tooltip: 'Manage Account',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountEditScreen(
                                                      chefId: status.chefId)));
                                    }),
                                status.isLoggedIn
                                    ? Text('Account')
                                    : Text('Log in')
                              ]);
                        })
                      ]),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class RecipeElement extends StatelessWidget {
  final Recipe recipe;
  final int id;

  RecipeElement(this.recipe, this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          CoalamCard(Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Image.network(
          'http://10.0.2.2:5000/get_image/' + id.toString() + '/1',
          height: 100,
          headers: {'connection': 'Keep-Alive'},
        ),
        Expanded(
          child: TextButton(
            child:
                Text('View Details stuff for ' + recipe.details['recipeName']),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/details/' + recipe.details['recipeId'].toString(),
              );
            },
          ),
        ),
      ])),
    );
  }
}
