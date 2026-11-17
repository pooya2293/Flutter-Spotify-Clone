import 'package:client/features/home/models/song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;

  bool get isPlaying => audioPlayer?.playing ?? false;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer?.dispose();

    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));

    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
      }
    });

    state = song;

    audioPlayer!.play();
  }

  void playPause() {
    if (audioPlayer == null) return;

    if (audioPlayer!.playing) {
      audioPlayer!.pause();
    } else {
      audioPlayer!.play();
    }
  }
}
