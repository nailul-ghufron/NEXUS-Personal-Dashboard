// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Schedule)
final scheduleProvider = ScheduleProvider._();

final class ScheduleProvider
    extends $AsyncNotifierProvider<Schedule, List<ScheduleItem>> {
  ScheduleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleHash();

  @$internal
  @override
  Schedule create() => Schedule();
}

String _$scheduleHash() => r'c5b9ee02dc0fecf7a78f27106866978d066a3e47';

abstract class _$Schedule extends $AsyncNotifier<List<ScheduleItem>> {
  FutureOr<List<ScheduleItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ScheduleItem>>, List<ScheduleItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ScheduleItem>>, List<ScheduleItem>>,
              AsyncValue<List<ScheduleItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
