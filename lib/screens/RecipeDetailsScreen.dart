import 'package:flutter/material.dart';
import 'package:coalam_app/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:carousel_slider/carousel_slider.dart';

import 'package:coalam_app/GlobalParameters.dart';
import 'package:coalam_app/models.dart';



class RecipeDetailsScreen extends StatelessWidget {
  String id;

  RecipeDetailsScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {

    List items = [1,2,3];
    final _count = getCountPictures(id);


    return FutureBuilder<List<Recipe>>(
        future: fetchRecipe(id),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                FutureBuilder<int>(
                  future: getCountPictures(id),
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: CarouselSlider(
                            items: [
                              for (var i = 1; i <= snapshot.data; i += 1)
                                ImageCarousel(int.parse(id),i)
                            ],
                            options: CarouselOptions(
                              height: 400,
                            )
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),

                    Container(
                      child: Text('Description: \n' +
                          snapshot.data[0].details['description']
                          ),
                    ),
                    Container(
                      child: Text('You will need the following ingredients: \n' +
                          snapshot.data[0].details['ingredients']),
                    ),
                    Container(
                      child: Text('and those tools: \n' +
                          snapshot.data[0].details['tools']),
                    ),
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
    return Image.network(
      'http://10.0.2.2:5000/get_image/' +
          id.toString() +
          '/' +
          n.toString(),
      height: 100,
      headers: {'connection': 'Keep-Alive'},
    );
  }
}

