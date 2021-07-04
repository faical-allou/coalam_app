import 'package:flutter/material.dart';
import 'package:coalam_app/main.dart';
import 'package:coalam_app/models/data.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:coalam_app/screens/AccountEditScreen.dart';
import 'package:coalam_app/screens/RecipeEditScreen.dart';
import 'package:coalam_app/screens/HomeScreen.dart';

import 'package:coalam_app/models/images.dart';

class RecipesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
                appBar: AppBar(
                    title: Center(
                        child: CTransText('All the good stuff').textWidget())),
                body: Container(
                alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaper.png"),
            fit: BoxFit.cover,
          ),
        ),      child:
                FutureBuilder<List<Recipe>>(
                    future: fetchAllRecipes(),
                    builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
                    if (snapshot.hasData) {
                    return Align(
                  child: ListView(
                    children: [
                      for (var i = 0; i <= snapshot.data!.length - 1; i += 1)
                        RecipeElement(snapshot.data![i]),
                    ],
                  ),
                );
                    } else {
                    return CoalamProgress();}}),),
                bottomNavigationBar: BottomAppBar(
                  child:
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<GlobalState>(
                          builder: (context, status, child) {
                            var status = context.read<GlobalState>();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ((status.isLoggedIn) & (status.chefId != 0))
                                    ? Column(children: [
                                        IconButton(
                                            icon: Icon(Icons.add_box),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RecipeEditScreen(
                                                              recipe: Recipe(
                                                                  id: 0,
                                                                  chefName: status.chefName,
                                                                  chefId: status
                                                                      .chefId,
                                                                  name: null,
                                                                  details:
                                                                      null),
                                                              imageInput:
                                                                  null)));
                                            }),
                                        CTransText('add Recipe').textWidget(),
                                      ])
                                    : Container()
                              ],
                            );
                          },
                        ),
                        Consumer<GlobalState>(
                            builder: (context, status, child) {
                          var status = context.read<GlobalState>();
                          return status.isLoggedIn
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                      IconButton(
                                          icon: Icon(Icons.account_box),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AccountEditScreen(
                                                            chefId: status.chefId)));
                                          }),
                                      CTransText('Account').textWidget()
                                    ])
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      IconButton(
                                          icon: Icon(Icons.account_box),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen()));
                                          }),
                                      CTransText('log in with google').textWidget()
                                    ]);
                        })
                      ]),
                      Container(height:10.0),
                      ])
                ));
  }
}

class RecipeElement extends StatelessWidget {
  final Recipe recipe;

  RecipeElement(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          CoalamCard(
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              imageFetcher('/get_image/' + recipe.id.toString() + '/1', 100, 100),
        Expanded(
          child: TextButton(
            child:
                CTransText('View details for ' + recipe.details!['recipename'])
                    .textWidget(),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/details/' + recipe.details!['recipeid'].toString(),
              );
            },
          ),
        ),
      ])),
    );
  }
}
