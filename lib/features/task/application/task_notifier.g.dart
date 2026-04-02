// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskNotifier)
final taskProvider = TaskNotifierProvider._();

final class TaskNotifierProvider
    extends $StreamNotifierProvider<TaskNotifier, List<TaskEntity>> {
  TaskNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskNotifierHash();

  @$internal
  @override
  TaskNotifier create() => TaskNotifier();
}

String _$taskNotifierHash() => r'ebd3c305eca63e364be423b7ba2618dac35176a2';

abstract class _$TaskNotifier extends $StreamNotifier<List<TaskEntity>> {
  Stream<List<TaskEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<TaskEntity>>, List<TaskEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<TaskEntity>>, List<TaskEntity>>,
        AsyncValue<List<TaskEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
