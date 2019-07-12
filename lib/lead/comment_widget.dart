import 'package:crm_app/lead/recorder_widget.dart';
import 'package:crm_app/model/lead_comment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentWidget extends StatefulWidget {
  final Function updateComments;

  CommentWidget(this.updateComments);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _controller = new TextEditingController();
  String _path;
  bool _isAudio = false;

  String validateText() {
    if (_controller.text.isEmpty) {
      return "Comments can't be empty";
    }
    return null;
  }

  get path {
    return _path;
  }

  setPath(String path) {
    if (path == null)
      setState(() {
        _isAudio = false;
      });
    _path = path;
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        _isAudio
            ? RecorderWidget(setPath)
            : Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          errorText: validateText(),
                          labelText: "Comments goes here"),
                    ),
                  ),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.microphone),
                      onPressed: () {
                        setState(() {
                          _isAudio = true;
                        });
                      })
                ],
              ),
        RaisedButton(
          child: Text("Update Comments"),
          onPressed: () {
            LeadComment leadComment;
            if (_isAudio) {
              leadComment = new LeadComment(type: "audio", comment: path);
            } else {
              leadComment =
                  new LeadComment(type: "text", comment: _controller.text);
            }
            this.widget.updateComments(leadComment);
          },
        )
      ],
    ));
  }
}
