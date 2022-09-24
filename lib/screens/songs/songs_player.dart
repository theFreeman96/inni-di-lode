import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '/theme/constants.dart';

class SongsPlayer extends StatefulWidget {
  const SongsPlayer({Key? key}) : super(key: key);

  @override
  State<SongsPlayer> createState() => SongsPlayerState();
}

class SongsPlayerState extends State<SongsPlayer> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setAudio();

    // Listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    // Load audio from url
    audioPlayer.setSourceUrl(
        'https://api.whatda.fit/sample-audios/MP%20Clapping%20Crunches%2045.mp3');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding / 5),
          child: Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
              await audioPlayer.resume();
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(position)),
              Text(formatTime(duration - position))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: kDefaultPadding,
                child: IconButton(
                  icon: const Icon(Icons.replay_10),
                  iconSize: kDefaultPadding,
                  onPressed: () async {
                    await audioPlayer
                        .seek(Duration(seconds: position.inSeconds - 10));
                    await audioPlayer.resume();
                    setState(() {});
                  },
                ),
              ),
              CircleAvatar(
                radius: kDefaultPadding * 1.5,
                child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: kDefaultPadding * 1.5,
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                    setState(() {});
                  },
                ),
              ),
              CircleAvatar(
                radius: kDefaultPadding,
                child: IconButton(
                  icon: const Icon(Icons.forward_10),
                  iconSize: kDefaultPadding,
                  onPressed: () async {
                    if (position.inSeconds < duration.inSeconds - 10) {
                      audioPlayer
                          .seek(Duration(seconds: position.inSeconds + 10));
                      await audioPlayer.resume();
                    } else {
                      await audioPlayer.resume();
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          title: const Center(
            child: Text('Chiudi'),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
