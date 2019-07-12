import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;


class RecorderWidget extends StatefulWidget {
  final Function setPath;

  RecorderWidget(this.setPath);

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;
  bool _isRecorded = false;
  String _recorderTxt = '00:00';
  String _playerTxt = '00:00';
  double _dbLevel;

  double slider_current_position = 0.0;
  double max_duration = 1.0;

  @override
  void initState() {
    super.initState();

    flutterSound = new FlutterSound();

    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  void startRecorder() async {
    try {
      String path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');
      this.widget.setPath(result);

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        _isRecorded = true;
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void startPlayer() async {
    if (!_isRecorded) return;
    String path = await flutterSound.startPlayer(null);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          this.setState(() {
            this._isPlaying = true;
            this._playerTxt = txt.substring(0, 8);
          });
        }
      }, onDone: () {
        this.setState(() {
          this._isPlaying = false;
          this._playerTxt = "00:00";
        });
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      this.setState(() {
        this._isPlaying = false;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
  }

  void resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSound.seekToPlayer(milliSecs);
    print('seekToPlayer: $result');
  }

  @override
  Widget build(BuildContext context) {
    final cancelWidget = IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        if (_isRecording || _isPlaying) return;

        this.widget.setPath(null);
      },
    );

    final playWidget = IconButton(
      icon: Icon(_isPlaying ? FontAwesomeIcons.stop : FontAwesomeIcons.play),
      onPressed: _isRecording
          ? null
          : () {
              if (!_isRecorded) return;
              if (_isPlaying)
                stopPlayer();
              else
                startPlayer();
            },
    );
    final progressWidget = _isRecording
        ? LinearProgressIndicator(
            value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            backgroundColor: Colors.red,
          )
        : Container();
    final recorderWidget = IconButton(
      icon: Icon(
        _isRecording ? FontAwesomeIcons.stop : FontAwesomeIcons.microphone,
      ),
      onPressed: _isPlaying
          ? null
          : () {
              if (_isRecording)
                stopRecorder();
              else
                startRecorder();
            },
    );
    return Column(
      children: <Widget>[
        Container(child: cancelWidget,alignment: Alignment(1.0, 1.0),),
        Row(
          children: <Widget>[
            playWidget,
            Expanded(
              child: progressWidget,
            ),
            Text(_isPlaying ? this._playerTxt : _recorderTxt),
            recorderWidget,
          ],
        ),
      ],
    );
  }
}
