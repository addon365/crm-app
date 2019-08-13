import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

class PlayerWidget extends StatefulWidget {
  final String filePath;

  PlayerWidget(this.filePath);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool _isPlaying = false;


  StreamSubscription _playerSubscription;

  FlutterSound flutterSound;

  String _playerTxt = '00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  @override
  void initState() {
    super.initState();

    flutterSound = new FlutterSound();

    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  void startPlayer() async {
    String path = await flutterSound.startPlayer(this.widget.filePath);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          sliderCurrentPosition = e.currentPosition;
          maxDuration = e.duration;

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
    final playWidget = IconButton(
      icon: Icon(_isPlaying ? FontAwesomeIcons.stop : FontAwesomeIcons.play),
      onPressed: () {
        if (_isPlaying)
          stopPlayer();
        else
          startPlayer();
      },
    );
    final progressWidget = LinearProgressIndicator(
      value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      backgroundColor: Colors.red,
    );

    return Row(
      children: <Widget>[
        playWidget,
        Expanded(
          child: progressWidget,
        ),
        Text(_playerTxt)
      ],
    );
  }
}
