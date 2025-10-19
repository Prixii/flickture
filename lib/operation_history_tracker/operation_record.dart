abstract class OperationRecord<T> {
  final T data;
  final String name;
  OperationRecord(this.data, {this.name = ''});

  Future<void> onUndo();

  Future<void> onRedo();
}

abstract class SyncOperationRecord<T> extends OperationRecord<T> {
  SyncOperationRecord(super.data, {super.name});

  @override
  Future<void> onRedo() async => redo();

  @override
  Future<void> onUndo() async => undo();

  void redoSync() => redo();

  void undoSync() => undo();

  void redo();
  void undo();
}
