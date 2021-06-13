import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coalam_app/models.dart';




class CoalamTextCard extends StatelessWidget {
  final String text;
  CoalamTextCard(this.text);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(padding: EdgeInsets.all(10.0),
          child: Text(text)
        ),
    );}
}
class CoalamCard extends StatelessWidget {
  final Widget w;
  CoalamCard(this.w);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(10.0),
          child: this.w
      ),
    );}
}

class CoalamTextInputField extends StatelessWidget {
  final TextEditingController input;
  final String? hint;
  final double height;
  final int maximumLines;
  final int maximumCharacters;
  final String? initValue;

  CoalamTextInputField(
      this.initValue,
      this.input,
      this.hint,
      this.height,
      this.maximumLines,
      this.maximumCharacters);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: this.height,
        child:
    TextFormField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.multiline,
      maxLines: this.maximumLines,
      maxLength: this.maximumCharacters,
      maxLengthEnforced:  true,
      decoration: InputDecoration(
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

