import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    debugPrint('STEP 1: Upload button reached');

    state = const AsyncValue.loading();

    final currentUser = ref.read(currentUserProvider);
    debugPrint('STEP 2: Current user = $currentUser');

    if (currentUser == null || currentUser.token.isEmpty) {
      debugPrint('STOP: User or token is missing');

      state = AsyncValue.error(
        Exception('User or token is missing'),
        StackTrace.current,
      );
      return;
    }

    debugPrint('STEP 3: Calling repository');

    try {
      final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedThumbnail: selectedThumbnail,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
        token: currentUser.token,
      );

      debugPrint('STEP 4: Repository returned: $res');

      state = switch (res) {
        Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => AsyncValue.data(r),
      };
    } catch (e, st) {
      debugPrint('UPLOAD EXCEPTION: $e');

      state = AsyncValue.error(e, st);
    }
  }
}
