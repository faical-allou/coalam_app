import 'package:coalam_app/screens/RecipeEditScreen.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:coalam_app/models.dart';
import 'package:coalam_app/main.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String id;

  RecipeDetailsScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    var mainImage = Image.network(
      'http://10.0.2.2:5000/get_image/' + id.toString() + '/1',
      height: 100,
      headers: {'connection': 'Keep-Alive'},
    );
    return FutureBuilder<Recipe>(
        future: fetchRecipe(id),
        builder: (context, AsyncSnapshot<Recipe> snapshot) {
          if (snapshot.hasData) {
            final chefId = snapshot.data.chefId;
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                child: ListView(
                  children: [
                    FutureBuilder<int>(
                        future: getCountPictures(id),
                        builder: (context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              child: CarouselSlider(
                                  items: [
                                    for (var i = 1; i <= snapshot.data; i += 1)
                                      ImageCarousel(int.parse(id), i)
                                  ],
                                  options: CarouselOptions(
                                    height: 200,
                                  )),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    CoalamTextCard(
                      'Chef: \n' +
                          snapshot.data.details['chefName']
                    ),
                    CoalamTextCard(
                      'Name: \n' +
                          snapshot.data.details['recipeName'],
                    ),
                    CoalamTextCard(
                     'Description: \n' +
                          snapshot.data.details['description'],
                    ),
                    CoalamTextCard(
                          'You will need the following ingredients: \n' +
                              snapshot.data.details['ingredients'],
                    ),
                    CoalamTextCard(
                      'and those tools: \n' +
                          snapshot.data.details['tools']
                    ),

                    Center(
                      child:
                    Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text('COOKING LESSONS WITH THE CHEF')),),
                    FutureBuilder<List<dynamic>>(
                        future: getNextEvents(chefId, id),
                        builder:
                            (context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              for (var i = 0;
                                  i <= snapshot.data.length - 1;
                                  i += 1)
                                CoalamCard(
                                    Row(children: [
                                      Expanded(child:Text(DateFormat('d-MMM-y HH:mm').format(DateTime.parse(snapshot.data[i]['start']['dateTime'])).toString())),
                                      Expanded(child:Text(snapshot.data[i]['description'])),
                                  TextButton(
                                    child:
                                        Text('check it'),
                                    onPressed: () => {
                                      launch(snapshot.data[i]['hangoutLink'])
                                    },
                                  )
                                ])),
                            ]);
                          } else {
                            return Text('Preparing the link');
                          }
                        }),
                    TextButton(
                      child: Text('back!'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: _getFAB(snapshot.data, mainImage)

            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class ImageCarousel extends StatelessWidget {
  final int id; // id of the recipe
  final int n; // id of the picture of the recipe

  ImageCarousel(this.id, this.n);

  @override
  Widget build(BuildContext context) {
    var picture = Image.network(
      'http://10.0.2.2:5000/get_image/' + id.toString() + '/' + n.toString(),
      height: 100,
      headers: {'connection': 'Keep-Alive'},
    );
    return picture;
  }
}

Widget _getFAB(Recipe inputRecipe, Image inputImage) {
    return   Consumer<GlobalState>(
        builder: (context, status, child) {
          var status = context.read<GlobalState>();
          if (!status.isLoggedIn) {
           return Container();
          } else {
            return FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RecipeEditScreen(recipe: inputRecipe, imageInput: inputImage)
                      )
                  );
                }
            );
          }}
  );
}
