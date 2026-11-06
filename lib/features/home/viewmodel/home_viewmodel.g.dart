// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllSongs)
final getAllSongsProvider = GetAllSongsProvider._();

final class GetAllSongsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongModel>>,
          List<SongModel>,
          FutureOr<List<SongModel>>
        >
    with $FutureModifier<List<SongModel>>, $FutureProvider<List<SongModel>> {
  GetAllSongsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllSongsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllSongsHash();

  @$internal
  @override
  $FutureProviderElement<List<SongModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongModel>> create(Ref ref) {
    return getAllSongs(ref);
  }
}

String _$getAllSongsHash() => r'36bd4bb2847e69abae543b24d4e86a9baf96e4d6';

@ProviderFor(HomeViewModel)
final homeViewModelProvider = HomeViewModelProvider._();

final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, AsyncValue<dynamic>?> {
  HomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<dynamic>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<dynamic>?>(value),
    );
  }
}

String _$homeViewModelHash() => r'986254d1ba19ae7583ba7ec2b7c83f6854eb8ada';

abstract class _$HomeViewModel extends $Notifier<AsyncValue<dynamic>?> {
  AsyncValue<dynamic>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>?, AsyncValue<dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>?, AsyncValue<dynamic>?>,
              AsyncValue<dynamic>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
