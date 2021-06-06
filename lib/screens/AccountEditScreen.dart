import 'package:coalam_app/models.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';

class AccountEditScreen extends StatefulWidget {
  final int chefId;

  const AccountEditScreen({Key key, this.chefId}) : super(key: key);

  State createState() => new AccountEditScreenState();
}

class AccountEditScreenState extends State<AccountEditScreen> {
  var chefInputName = TextEditingController();
  var chefInputDescription = TextEditingController();
  var chefId = 0;
  var recipeId = 0;

  Image image;
  File imageFile;

  var initialTextChefName = "";
  var initialTextChefDescription = "";

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        image = Image.file(File(pickedFile.path));
        imageCache.clear();
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        image = Image(image: FileImage(imageFile));
        imageCache.clear();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      chefId = widget.chefId;
      image = Image.network(
        'http://10.0.2.2:5000/get_image/'+widget.chefId.toString(),
        height: 100,
        headers: {'connection': 'Keep-Alive'},
      );


    return FutureBuilder<Chef>(
        future: fetchChef(widget.chefId),
        builder: (context, AsyncSnapshot<Chef> snapshot) {
          if (snapshot.hasData) {
              print(snapshot.data);
              if (!["", 0, null].contains(widget.chefId)) {
                initialTextChefName = snapshot.data.name;
                initialTextChefDescription = snapshot.data.description;

                chefInputName = TextEditingController(text: initialTextChefName);
                chefInputDescription =
                TextEditingController(text: initialTextChefDescription);
              }
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                  child: ListView(children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                      child: SizedBox(
                    width: 300.0,
                    height: 200.0,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (300.0 - 76.0),
                            height: 200.0,
                            child: Center(
                                child: image == null
                                    ? Text('Choose the main image')
                                    : imageFile == null
                                        ? image
                                        : Image(image: FileImage(imageFile))),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FloatingActionButton(
                                    heroTag: "camera",
                                    onPressed: getImageFromCamera,
                                    tooltip: 'Pick Image',
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FloatingActionButton(
                                    heroTag: "gallery",
                                    onPressed: getImageFromGallery,
                                    tooltip: 'Pick Image',
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                )
                              ])
                        ]),
                  )),
                ),
                CoalamTextInputField(initialTextChefName, chefInputName,
                    Text('input a name').data, 90, 1, 30),
                CoalamTextInputField(
                    initialTextChefDescription,
                    chefInputDescription,
                    Text('description').data,
                    160,
                    4,
                    200),
                Consumer<GlobalState>(builder: (context, status, child) {
                  var status = context.read<GlobalState>();
                  return ElevatedButton(
                    child: Text("Send"),
                    onPressed: () {
                      asyncChefAccountUpload(chefInputName.text,
                              chefInputDescription.text, chefId, imageFile)
                          .then((textResponse) => {
                                status.setChefId(int.parse(
                                    jsonDecode(textResponse)['chefId'])),
                                status.logIn(),
                              });
                      showAlertDialog(context);
                    },
                  );
                })
              ])),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

showAlertDialog(BuildContext context) {
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.pushReplacementNamed(context, '/list');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thank you for joining?"),
    content: Text("Ready to cook?"),
    actions: [
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
