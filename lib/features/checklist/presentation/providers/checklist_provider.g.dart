// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Checklist)
final checklistProvider = ChecklistProvider._();

final class ChecklistProvider
    extends $AsyncNotifierProvider<Checklist, List<ChecklistItem>> {
  ChecklistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checklistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checklistHash();

  @$internal
  @override
  Checklist create() => Checklist();
}

String _$checklistHash() => r'c171187528a0d2a1324806b7eb8143e18b0a77c6';

abstract class _$Checklist extends $AsyncNotifier<List<ChecklistItem>> {
  FutureOr<List<ChecklistItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ChecklistItem>>, List<ChecklistItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ChecklistItem>>, List<ChecklistItem>>,
              AsyncValue<List<ChecklistItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
