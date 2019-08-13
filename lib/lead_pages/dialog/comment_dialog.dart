import 'package:flutter/material.dart';

class CommentDailog extends StatefulWidget {
  @override
  _CommentDailogState createState() => new _CommentDailogState();
}

class _CommentDailogState extends State<CommentDailog> {
  final _controller = new TextEditingController();

  String validateText() {
    if (_controller.text.isEmpty) {
      return "Comments can't be empty";
    }
    return null;
  }

  Widget dialogContent(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
              errorText: validateText(), labelText: "Comments goes here"),
        ),
      ),
      RaisedButton(
        onPressed: () {
          Navigator.pop(context, _controller.text);
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
