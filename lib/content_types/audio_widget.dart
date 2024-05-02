
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioWidget extends StatefulWidget {
  final String audioAsset;
  const AudioWidget({super.key, required this.audioAsset});
  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final AudioPlayer player1 = AudioPlayer();
  bool isPlaying1 = false;

  @override
  void dispose() {
    super.dispose();
    //releasing resources
    player1.dispose();
  }

  void _toggleAudio1() {
    setState(() {
      if (isPlaying1) {
        player1.pause();
      } else {
        //set it
        player1.setAsset(widget.audioAsset);
        player1.play();
      }
      setState(() {
        isPlaying1 = !isPlaying1; // Toggle play state
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return  IconButton(
      icon: Image.asset(
        "assets/audio.png",
        width: 60,
        height: 60,
      ),
      onPressed: () => _toggleAudio1(),
    );
  }
}
