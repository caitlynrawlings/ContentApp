import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'toggle_widget.dart';

class AudioWidget extends StatefulWidget {
  final String audioAsset;
  final String transcript;
  const AudioWidget({super.key, required this.audioAsset, required this.transcript});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void toggleAudio() {
    if (isPlaying) {
      player.pause();
    } else {
      player.setAsset(widget.audioAsset);
      player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(FontAwesomeIcons.volumeUp, color: Theme.of(context).colorScheme.onBackground,),
          // icon: Image.asset(
          //   "assets/audio.png",
          //   width: 60,
          //   height: 60,
          // ),
          iconSize: 60,
          onPressed: toggleAudio,
        ),
        ToggleWidget(title: "Show Transcript", body: widget.transcript),
      ],
    );
  }
}
