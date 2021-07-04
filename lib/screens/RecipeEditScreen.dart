import 'package:coalam_app/models/data.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class RecipeEditScreen extends StatefulWidget {
  final Recipe? recipe;
  final Image? imageInput;
  const RecipeEditScreen ({ Key? key, this.recipe, this.imageInput }): super(key: key);

  State createState() => new RecipeEditScreenState();
}
class RecipeEditScreenState extends State<RecipeEditScreen> {

  var recipeInputName = TextEditingController();
  var recipeInputDescription = TextEditingController();
  var recipeInputIngredients = TextEditingController();
  var recipeInputTools = TextEditingController();
  int? chefId = 0;
  int? recipeId = 0;
  String? chefName = "";

  Image? image;
  String? imageFilePath;
  Uint8List? imageBytes;

  String? initialTextRecipeName = "";
  String? initialTextRecipeDescription = "";
  String? initialTextIngredients = "";
  String? initialTextTools = "";

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    imageCache!.clear();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFilePath = pickedFile.path;
        image = Image.file(File(pickedFile.path));
        var _imageFile = File(pickedFile.path);
        imageBytes = _imageFile.readAsBytesSync();
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery2() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
    if(result != null) {
      imageCache!.clear();
      setState(() {
        PlatformFile file = result.files.first;
        imageFilePath = file.path;
        image = Image.memory(file.bytes!);
        imageBytes = file.bytes;
      }
    );
    } else {
      // User canceled the picker
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    imageCache!.clear();
    setState(() {
      if (pickedFile != null) {
          imageFilePath = pickedFile.path;
          image = Image.file(File(pickedFile.path));
          var _imageFile = File(pickedFile.path);
          imageBytes = _imageFile.readAsBytesSync();
          imageCache!.clear();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if ( widget.recipe!.id != 0  ) {
      initialTextRecipeName = widget.recipe!.details!['recipename'];
      initialTextRecipeDescription = widget.recipe!.details!['description'];
      initialTextIngredients = widget.recipe!.details!['ingredients'];
      initialTextTools = widget.recipe!.details!['tools'];

      recipeInputName = TextEditingController(text:initialTextRecipeName);
      recipeInputDescription = TextEditingController(text: initialTextRecipeDescription);
      recipeInputIngredients = TextEditingController(text: initialTextIngredients);
      recipeInputTools = TextEditingController(text: initialTextTools);


      recipeId = widget.recipe!.details!['recipeid'];
    }
    chefId = widget.recipe!.chefId;
    chefName = widget.recipe!.chefName;

    return Scaffold(
      appBar: AppBar(title: Center(child:CTransText('Edit your recipe').textWidget())),
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
                      ? widget.imageInput == null
                        ? CTransText('Choose the main image').textWidget()
                        : widget.imageInput
                      : image
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                kIsWeb
                ? Container()
                : Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    heroTag: "camera",
                    onPressed: getImageFromCamera,
                    tooltip: CTransText('Pick Image').value(),
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    heroTag: "gallery",
                    onPressed: getImageFromGallery2,
                    tooltip: CTransText('Pick Image').value(),
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
                CTransText('input a name').value(), 90, 1, 30),
            CoalamTextInputField(
                initialTextRecipeDescription,
                recipeInputDescription,
                CTransText('description').value(), 160, 4, 200),
            CoalamTextInputField(
                initialTextIngredients,
                recipeInputIngredients,
                CTransText('ingredients').value(), 120, 10, 200),
            CoalamTextInputField(
                initialTextTools,
                recipeInputTools,
                CTransText("tools").value(), 120, 10, 200),

            Column(children: [
              ElevatedButton(
          child: recipeId == 0
              ? CTransText("Create").textWidget()
              : CTransText("Update").textWidget(),
          onPressed: () {
            isValidRecipe(recipeId, recipeInputName.text, recipeInputDescription.text,
                recipeInputIngredients.text, recipeInputTools.text,
                chefId, image ?? imageBytes )
            ? () {
              imageCache!.clear();
              asyncRecipeUpload(
                recipeId, recipeInputName.text, recipeInputDescription.text,
                recipeInputIngredients.text, recipeInputTools.text,
                chefId, chefName, imageFilePath,imageBytes );
              showAlertDialogConfirm(context,"Thank you for your submission","Now you're cooking","Continue",);
          }()
          : showAlertDialogValidation(context,"Oops something is missing","Make sure all fields are filled and attach a picture", "Go back", );
          },
        ), recipeId != 0
           ? ElevatedButton(
              child: CTransText("Delete").textWidget(),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,),
              onPressed: () {
                showAlertDialogDelete(context, null,recipeId,deleteRecipe,
                    "Are you sure you want to delete?",
                    "There's no turning back!",
                    "yes delete",
                    "cancel",
                     true);
              },
            )
            : Container(),
            ])
      ])),
    );
  }
}



bool isValidRecipe(id1, text1, text2,
text3, text4, id2, image) {

  return (text1 != null) & (text2 != null) & (text3 != null) & (text4 != null)
      & (id1 != null) & (id2 != null);
}