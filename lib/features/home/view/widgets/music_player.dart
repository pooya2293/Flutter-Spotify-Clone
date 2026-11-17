import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [hexToColor(currentSong!.hex_code), const Color(0xff121212)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Palette.transparentColor,
        appBar: AppBar(
          backgroundColor: Palette.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Palette.transparentColor,
              focusColor: Palette.transparentColor,
              splashColor: Palette.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Palette.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong!.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Palette.subtitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTickMarkColor: Palette.whiteColor,
                          inactiveTrackColor: Palette.whiteColor.withValues(
                            alpha: 0.117,
                          ),
                          thumbColor: Palette.whiteColor,
                          trackHeight: 4,
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(value: 0.5, onChanged: (val) {}),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        '0:05',
                        style: TextStyle(
                          color: Palette.subtitleText,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '0:30',
                        style: TextStyle(
                          color: Palette.subtitleText,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.play_circle_fill),
                        iconSize: 80,
                        color: Palette.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
