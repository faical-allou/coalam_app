import 'package:coalam_app/screens/RecipeEditScreen.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:coalam_app/models.dart';
import 'package:coalam_app/main.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String? id;

  State createState() => new RecipeDetailsScreenState();

  RecipeDetailsScreen({
    this.id,
  });
}

class RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  DateTime selectedDateTime = DateTime.now();
  var descriptionInput = TextEditingController();
  var description = "New event from the app";

  @override
  Widget build(BuildContext context) {
    var mainImage =
        imageFetcher('/get_image/' + widget.id.toString() + '/1', 200);
    return FutureBuilder<Recipe>(
        future: fetchRecipe(widget.id),
        builder: (context, AsyncSnapshot<Recipe> snapshot) {
          if (snapshot.hasData) {
            final chefId = snapshot.data!.chefId;
            return Scaffold(
                appBar: AppBar(),
                body: Container(
                  child: ListView(
                    children: [
                      FutureBuilder<int?>(
                          future: getCountPictures(widget.id),
                          builder: (context, AsyncSnapshot<int?> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: CarouselSlider(
                                    items: [
                                      for (var i = 1;
                                          i <= snapshot.data!;
                                          i += 1)
                                        ImageCarousel(int.parse(widget.id!), i)
                                    ],
                                    options: CarouselOptions(
                                      height: 200,
                                    )),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      CoalamCard(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Text('Chef: \n' +
                                    snapshot.data!.details!['chefName']),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: imageFetcher(
                                    '/get_image/' +
                                        snapshot.data!.details!['chefId']
                                            .toString(),
                                    50),
                              )
                            ]),
                      ),
                      CoalamTextCard(
                        'Name: \n' + snapshot.data!.details!['recipeName'],
                      ),
                      CoalamTextCard(
                        'Description: \n' +
                            snapshot.data!.details!['description'],
                      ),
                      CoalamTextCard(
                        'You will need the following ingredients: \n' +
                            snapshot.data!.details!['ingredients'],
                      ),
                      CoalamTextCard('and those tools: \n' +
                          snapshot.data!.details!['tools']),
                      Center(
                        child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text('COOKING LESSONS WITH THE CHEF')),
                      ),
                      FutureBuilder<List<dynamic>?>(
                          future: getNextEvents(chefId, widget.id),
                          builder: (context,
                              AsyncSnapshot<List<dynamic>?> snapshot2) {
                            if (snapshot2.hasData) {
                              return Column(children: [
                                for (var i = 0;
                                    i <= snapshot2.data!.length - 1;
                                    i += 1)
                                  CoalamCard(Row(children: [
                                    Expanded(
                                        child: Text(DateFormat('d-MMM-y HH:mm')
                                            .format(DateTime.parse(snapshot2
                                                .data![i]['start']['dateTime']).toLocal())
                                            .toString())),
                                    Expanded(
                                        child: Text(
                                            snapshot2.data![i]['description'] ?? "")),
                                    TextButton(
                                      child: Text('check it'),
                                      onPressed: () => {
                                        launch(
                                            snapshot2.data![i]['hangoutLink'])
                                      },
                                    ),
                                    TextButton(
                                      child: Text('delete it'),
                                      onPressed: () => {

                                        deleteEvent(
                                            snapshot2.data![i]['id'], setState ),
                                      },
                                    ),
                                  ])),
                              ]);
                            } else {
                              return Text('fetching events');
                            }
                          }),

              CoalamCard(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            TextButton(
                              child: Text(
                                DateFormat("d-MMM-y @ HH:mm")
                                    .format(selectedDateTime)
                                    .toString(),
                              ),
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2019, 6, 7),
                                    onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  setState(() {
                                    selectedDateTime = date;
                                  });
                                },
                                    currentTime: selectedDateTime,
                                    locale: LocaleType.en);
                              },
                            ),
                            Container(width: MediaQuery.of(context).size.width * 0.30,
                                child: CoalamTextInputField(
                                "",  descriptionInput,
                                Text('add a description').data, 80, 1, 30)),

                      ElevatedButton(
                        child: Text('+ add event'),
                        onPressed: () {
                          var start = DateFormat("yyyy-MM-ddTHH:mm:ss")
                              .format(selectedDateTime.toUtc());
                          var end = DateFormat("yyyy-MM-ddTHH:mm:ss")
                              .format(selectedDateTime.toUtc()
                              .add(new Duration(hours: 1)));

                          isValidEvent(snapshot.data!.chefId,
                              int.parse(widget.id!),
                              start,
                              end,
                              descriptionInput.text)
                          ? () {createEvent(
                              snapshot.data!.chefId,
                              int.parse(widget.id!),
                              start,
                              end,
                              descriptionInput.text,
                              setState
                          );
                          }()
                          : showAlertDialogValidation(context);
                        },
                      ),]),),
                      TextButton(
                        child: Text('back!'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                floatingActionButton: _getFAB(snapshot.data, mainImage));
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
    var picture =
        imageFetcher('/get_image/' + id.toString() + '/' + n.toString(), 100);
    return picture;
  }
}

Widget _getFAB(Recipe? inputRecipe, Image inputImage) {
  return Consumer<GlobalState>(builder: (context, status, child) {
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
                    builder: (context) => RecipeEditScreen(
                        recipe: inputRecipe, imageInput: inputImage)));
          });
    }
  });
}

bool isValidEvent(int? int1, int? int2, String? text1, String? text2, String? text3){
  print(text3);
  print(text3?.length);
  bool test = (int1 != null) & (int2 != null) & (text1 != null) & (text2 != null)
                & (text3 != null) & (text3!.length >= 3);
  return test;
}

showAlertDialogValidation(BuildContext context) {

  Widget cancelButton = TextButton(
    child: Text("Go back"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Oops something is missing"),
    content: Text("Make sure you have a description"),
    actions: [
      cancelButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}