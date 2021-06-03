import 'package:coalam_app/models.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class RecipeEditScreen extends StatefulWidget {
  final Recipe recipe;
  final Image imageInput;
  const RecipeEditScreen ({ Key key, this.recipe, this.imageInput }): super(key: key);

  State createState() => new RecipeEditScreenState();
}
class RecipeEditScreenState extends State<RecipeEditScreen> {

  final recipeInputName = TextEditingController();
  final recipeInputDescription = TextEditingController();
  final recipeInputIngredients = TextEditingController();
  final recipeInputTools = TextEditingController();
  var chefId = 1;
  var recipeId = 0;

  Image image;
  File imageFile;

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

    var initialTextRecipeName = 'input a name';
    var initialTextRecipeDescription = 'description';
    var initialTextIngredients = 'Ingredients needed (10 max, 1 per row)';
    var initialTextTools = 'Tools Required (10 max, 1 per row)';


    if ( !["", null].contains(widget.recipe) ) {
      initialTextRecipeName = widget.recipe.details['recipeName'];
      initialTextRecipeDescription = widget.recipe.details['description'];
      initialTextIngredients = widget.recipe.details['ingredients'];
      initialTextTools = widget.recipe.details['tools'];
      recipeId = widget.recipe.details['recipeId'];
      chefId = widget.recipe.details['chefId'];
      var initialImage = widget.imageInput;
      image = initialImage;
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
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                width: (300.0 - 76.0),
                height: 200.0,
                child: Center(
                  child: image == null
                      ? Text('Choose the main image')
                      : imageFile == null
                        ? image
                        : Image(image: FileImage(imageFile))
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
        CoalamTextField(
            recipeInputName, Text(initialTextRecipeName).data, 90, 1, 30),
        CoalamTextField(
            recipeInputDescription, Text(initialTextRecipeDescription).data, 160, 4, 200),
        CoalamTextField(recipeInputIngredients,
            Text(initialTextIngredients).data, 120, 10, 200),
        CoalamTextField(recipeInputTools,
            Text(initialTextTools).data, 120, 10, 200),
        ElevatedButton(
          child: Text("Create Recipe"),
          onPressed: () {
            print(recipeId);
            asyncFileUpload(recipeId, recipeInputName.text, recipeInputDescription.text,
                recipeInputIngredients.text, recipeInputTools.text, chefId, imageFile );
          },
        )
      ])),
    );
  }
}

