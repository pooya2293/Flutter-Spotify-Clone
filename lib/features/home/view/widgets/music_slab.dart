import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const MusicPlayer();
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hex_code),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Palette.whiteColor,
                          ),
                        ),
                        Text(
                          currentSong.artist,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Palette.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.heart),
                    ),
                    StreamBuilder<PlayerState>(
                      stream: songNotifier.audioPlayer?.playerStateStream,
                      builder: (context, snapshot) {
                        final isPlaying = snapshot.data?.playing ?? false;

                        return IconButton(
                          onPressed: songNotifier.playPause,
                          icon: Icon(
                            isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: Palette.whiteColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final position = asyncSnapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              double sliderValue = 0.0;
              if (position != null && duration != null) {
                sliderValue = position.inMilliseconds / duration.inMilliseconds;
              }

              return Positioned(
                bottom: 0,
                left: 3,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 20),
                  decoration: BoxDecoration(
                    color: Palette.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 3,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Palette.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
