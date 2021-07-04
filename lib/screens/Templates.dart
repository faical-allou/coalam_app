import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoalamTextCard extends StatelessWidget {
  final String text;
  CoalamTextCard(this.text);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom:10),
      child: Padding(padding: EdgeInsets.all(10.0), child: Text(text)),
    );
  }
}

class CoalamFitTitleTextCard extends StatelessWidget {
  final String text;
  CoalamFitTitleTextCard(this.text);
  @override
  Widget build(BuildContext context) {
    return
      Row(children:[
      Card(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5),
      child: Padding(padding: EdgeInsets.all(5.0),
          child: CTransText(text, TextStyle(fontWeight: FontWeight.bold)).textWidget()),
    )]);
  }
}


class CoalamCard extends StatelessWidget {
  final Widget w;
  CoalamCard(this.w);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom:5),
      child: Padding(padding: EdgeInsets.all(10.0), child: this.w),
    );
  }
}

class CoalamTextInputField extends StatelessWidget {
  final TextEditingController input;
  final String? hint;
  final double height;
  final int maximumLines;
  final int maximumCharacters;
  final String? initValue;

  CoalamTextInputField(this.initValue, this.input, this.hint, this.height,
      this.maximumLines, this.maximumCharacters);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: TextFormField(
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.multiline,
          maxLines: this.maximumLines,
          maxLength: this.maximumCharacters,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            hintText: this.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.amber,
                style: BorderStyle.solid,
              ),
            ),
          ),
          controller: this.input,
        ));
  }
}

class CoalamProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CTransText {
  final String text;
  final TextStyle? style;
  CTransText(this.text, [this.style]);

  String value() {
    return this.text;
  }
  Widget textWidget() {
    return Text(this.text, style: style ?? null);
  }

}


showAlertDialogValidation(BuildContext context, String text1, String text2, String text3) {
  Widget cancelButton = TextButton(
    child: CTransText(text3).textWidget(),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: CTransText(text1).textWidget(),
    content: CTransText(text2).textWidget(),
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

showAlertDialogConfirm(BuildContext context, text1, text2, text3) {

  Widget continueButton = TextButton(
    child: CTransText(text3).textWidget(),
    onPressed:  () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    },
  );

  AlertDialog alert = AlertDialog(
    title: CTransText(text1).textWidget(),
    content: CTransText(text2).textWidget(),
    actions: [
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
showAlertDialogDelete(BuildContext context, updateScreen, id,function, titleText, contentText, goText,cancelText, backHome ) {

  Widget continueButton = TextButton(
    child: CTransText(goText).textWidget(),
    onPressed:  () {
      function(id,updateScreen);
      backHome
      ? Navigator.of(context).popUntil((route) => route.isFirst)
      : Navigator.pop(context)
      ;
    },
  );

  Widget cancelButton = TextButton(
    child: CTransText(cancelText).textWidget(),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: CTransText(titleText).textWidget(),
    content: CTransText(contentText).textWidget(),
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
