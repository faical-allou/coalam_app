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
                                      viewportFraction: 0.2,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      reverse: false,
                                      enlargeCenterPage: true,
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
                                            .format(DateTime.parse(
                                                    snapshot2.data![i]['start']
                                                        ['dateTime'])
                                                .toLocal())
                                            .toString())),
                                    Expanded(
                                        child: Text(snapshot2.data![i]
                                                ['description'] ??
                                            "")),
                                    TextButton(
                                      child: Text('check it'),
                                      onPressed: () => {
                                        launch(
                                            snapshot2.data![i]['hangoutLink'])
                                      },
                                    ),
                                    _getDeleteLink(snapshot2.data![i]['id'], setState)

                                  ])),
                              ]);
                            } else {
                              return Text('fetching events');
                            }
                          }),
                      Consumer<GlobalState>(builder: (context, status, child) {
                        var status = context.read<GlobalState>();
                        if (!status.isLoggedIn || snapshot.data!.chefId != status.chefId) {
                          return Container();
                        } else {
                          return CoalamCard(
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    child: TextButton(
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
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: CoalamTextInputField(
                                          "",
                                          descriptionInput,
                                          Text('Title').data,
                                          60,
                                          1,
                                          30)),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text('+ add event'),
                                    onPressed: () {
                                      var start =
                                          DateFormat("yyyy-MM-ddTHH:mm:ss")
                                              .format(selectedDateTime.toUtc());
                                      var end =
                                          DateFormat("yyyy-MM-ddTHH:mm:ss")
                                              .format(selectedDateTime
                                                  .toUtc()
                                                  .add(new Duration(hours: 1)));

                                      isValidEvent(
                                              snapshot.data!.chefId,
                                              int.parse(widget.id!),
                                              start,
                                              end,
                                              descriptionInput.text)
                                          ? () {
                                              createEvent(
                                                  snapshot.data!.chefId,
                                                  int.parse(widget.id!),
                                                  start,
                                                  end,
                                                  descriptionInput.text,
                                                  setState);
                                              showAlertDialogValidation(context,
                                                  Text("Nice !!").data ?? "",
                                                  Text("Your event will be live in a moment").data ?? "",
                                                  Text("Go Back").data ?? "");
                                            }()
                                          : showAlertDialogValidation(context,
                                        Text("Oops something is missing").data ?? "",
                                        Text("Make sure you have a description").data ?? "",
                                        Text("Go Back").data ?? "");
                                    },
                                  ),
                                ]),
                          );
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
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endTop,
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
    if (!status.isLoggedIn || inputRecipe!.chefId != status.chefId) {
      return Container();
    } else {
      return FloatingActionButton(
          backgroundColor: Colors.green,
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
Widget _getDeleteLink(id, function) {
  return Consumer<GlobalState>(builder: (context, status, child) {
    var status = context.read<GlobalState>();
    if (!status.isLoggedIn) {
      return Container();
    } else { return
      TextButton.icon(
        style: TextButton.styleFrom(
          primary: Colors.red,
        ),
        icon:Icon(Icons.delete),
        label: Text(''),
        onPressed: () =>
        { showAlertDialogDelete(context, id, function),
        },
      );
  }
  });}

bool isValidEvent(
    int? int1, int? int2, String? text1, String? text2, String? text3) {
  print(text3);
  print(text3?.length);
  bool test = (int1 != null) &
      (int2 != null) &
      (text1 != null) &
      (text2 != null) &
      (text3 != null) &
      (text3!.length >= 3);
  return test;
}

showAlertDialogValidation(BuildContext context, String text1, String text2, String text3) {
  Widget cancelButton = TextButton(
    child: Text(text3),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(text1),
    content: Text(text2),
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

showAlertDialogDelete(BuildContext context, eventId, function) {

  Widget continueButton = TextButton(
    child: Text("yes, delete"),
    onPressed:  () {
      deleteEvent(eventId, function);
      Navigator.pop(context);
    },
  );

  Widget cancelButton = TextButton(
    child: Text("cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Are you sure you want to delete?"),
    content: Text("There's no turning back!"),
    actions: [
      cancelButton,
      continueButton,
    ],

  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}