import 'package:coalam_app/models/data.dart';
import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:coalam_app/models/images.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'dart:typed_data';

class AccountEditScreen extends StatefulWidget {
  final int? chefId;

  const AccountEditScreen({Key? key, this.chefId}) : super(key: key);

  State createState() => new AccountEditScreenState();
}

class AccountEditScreenState extends State<AccountEditScreen> {
  var chefInputName = TextEditingController();
  var chefInputDescription = TextEditingController();
  int? chefId = 0;
  var recipeId = 0;

  Image? image;
  File? imageFile;
  Uint8List? imageBytes;
  String? imageFilePath;

  String? initialTextChefName = "";
  String? initialTextChefDescription = "";

  final picker = ImagePicker();

  Future getImageFromGallery2() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);

    if(result != null) {
      setState(() {
        PlatformFile file = result.files.first;
        imageFilePath = file.path;
        image = Image.memory(file.bytes!);
        imageBytes = file.bytes;
        imageCache!.clear();
      });

    } else {
      // User canceled the picker
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        image = Image(image: FileImage(imageFile!));
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
    chefId = widget.chefId;
    Image initialImage = imageFetcher('/get_image/' + widget.chefId.toString(), 200);
    return FutureBuilder<Chef>(
        future: fetchChef(widget.chefId),
        builder: (context, AsyncSnapshot<Chef> snapshot) {
          if (snapshot.hasData) {
            if (!["", 0, null].contains(widget.chefId)) {
              initialTextChefName = snapshot.data!.name;
              initialTextChefDescription = snapshot.data!.description;

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
                                  ? initialImage
                                    : image
                                       ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                kIsWeb
                                ? Container()
                                : Padding(
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
                                    onPressed: getImageFromGallery2,
                                    tooltip: 'Pick Image',
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                )
                              ])
                        ]),
                  )),
                ),
                CoalamTextInputField(initialTextChefName, chefInputName,
                    CTransText('input a name').value(), 90, 1, 30),
                CoalamTextInputField(
                    initialTextChefDescription,
                    chefInputDescription,
                    CTransText('description').value(),
                    160,
                    4,
                    200),
                Consumer<GlobalState>(
                  builder: (context, status, child) {
                    var status = context.read<GlobalState>();
                    return Column(children: [
                      ElevatedButton(
                        child: chefId == 0
                            ? CTransText("Create").textWidget()
                            : CTransText("Update").textWidget(),
                        onPressed: () {
                          if (isValidAccount(chefInputName.text,
                              chefInputDescription.text, chefId, image ?? imageFile))
                          {
                            asyncChefAccountUpload(
                                    chefInputName.text,
                                    chefInputDescription.text,
                                    chefId,
                                    imageFile, imageBytes)
                                .then((textResponse) => {
                                      status.setChefId(int.parse(
                                          jsonDecode(textResponse)['chefId'])),
                                      status.logIn(),
                                    });
                            showAlertDialogConfirm(context, "Thank you for joining?","Ready to cook?","Continue");
                          } else {
                            showAlertDialogValidation(context, "Oops something is missing","Make sure all fields are filled and attach a picture", "Go back",);
                          }
                        },
                      ),
                      chefId != 0
                          ? ElevatedButton(
                              child: CTransText("Delete").textWidget(),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                showAlertDialogDelete(context, null,chefId,deleteChef,
                                    "Are you sure you want to delete?",
                                    "There's no turning back!",
                                    "yes delete",
                                    "cancel",
                                    true);
                                status.logOut();
                              },
                            )
                          : Container()
                    ]);
                  },
                )
              ])),
            );
          } else {
            return CoalamProgress();
          }
        });
  }
}



bool isValidAccount(text1, text2, id, image) {
  return (text1 != null) & (text1.length > 2) & (text2 != null)  & (text2.length > 2)
  & (id != null) & (image != null);
}
