import 'package:coalam_app/models.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class RecipeEditScreen extends StatefulWidget {
  final Recipe recipe;
  final Image imageInput;
  const RecipeEditScreen ({ Key key, this.recipe, this.imageInput }): super(key: key);

  State createState() => new RecipeEditScreenState();
}
class RecipeEditScreenState extends State<RecipeEditScreen> {

  var recipeInputName = TextEditingController();
  var recipeInputDescription = TextEditingController();
  var recipeInputIngredients = TextEditingController();
  var recipeInputTools = TextEditingController();
  var chefId = 0;
  var recipeId = 0;

  Image image;
  File imageFile;

  var initialTextRecipeName = "";
  var initialTextRecipeDescription = "";
  var initialTextIngredients = "";
  var initialTextTools = "";

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
    if ( widget.recipe.id != 0  ) {
      initialTextRecipeName = widget.recipe.details['recipeName'];
      initialTextRecipeDescription = widget.recipe.details['description'];
      initialTextIngredients = widget.recipe.details['ingredients'];
      initialTextTools = widget.recipe.details['tools'];

      recipeInputName = TextEditingController(text:initialTextRecipeName);
      recipeInputDescription = TextEditingController(text: initialTextRecipeDescription);
      recipeInputIngredients = TextEditingController(text: initialTextIngredients);
      recipeInputTools = TextEditingController(text: initialTextTools);

      var initialImage = widget.imageInput;
      recipeId = widget.recipe.details['recipeId'];
      image = initialImage;
    }
    chefId = widget.recipe.chefId;

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
            CoalamTextInputField(
                initialTextRecipeName,
                recipeInputName,
                Text('input a name').data, 90, 1, 30),
            CoalamTextInputField(
                initialTextRecipeDescription,
                recipeInputDescription,
                Text('description').data, 160, 4, 200),
            CoalamTextInputField(
                initialTextIngredients,
                recipeInputIngredients,
                Text('ingredients').data, 120, 10, 200),
            CoalamTextInputField(
                initialTextTools,
                recipeInputTools,
                Text("tools").data, 120, 10, 200),

            ElevatedButton(
          child: Text("Send"),
          onPressed: () {

            asyncRecipeUpload(
                recipeId,
                recipeInputName.text,
                recipeInputDescription.text,
                recipeInputIngredients.text,
                recipeInputTools.text,
                chefId,
                imageFile );
            showAlertDialog(context);
          },
        ),
            ElevatedButton(
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,),
              onPressed: () {
                showAlertDialogDelete(context, recipeId);
              },
            ),

      ])),
    );
  }
}

showAlertDialog(BuildContext context) {

  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thank you for your submission"),
    content: Text("Now you're cooking"),
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

showAlertDialogDelete(BuildContext context, recipeId) {

  Widget continueButton = TextButton(
    child: Text("yes, delete"),
    onPressed:  () {
      deleteRecipe(recipeId);
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 4);
    },
  );

  Widget cancelButton = TextButton(
    child: Text("cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure you want to delete?"),
    content: Text("There's no turning back!"),
    actions: [
      cancelButton,
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