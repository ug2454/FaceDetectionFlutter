import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Voice extends StatefulWidget {
  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  SpeechToText _speechToText;
  bool _isListening = false;

  String tooltip = 'Press the button to speak';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AvatarGlow(
        animate: true, //_isListening,
        endRadius: 75.0,
        glowColor: Theme.of(context).primaryColor,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SafeArea(child: Container()),
    );
  }
}
