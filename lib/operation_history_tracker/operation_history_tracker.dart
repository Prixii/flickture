import 'dart:collection';

import 'package:flickture/operation_history_tracker/operation_record.dart';

class OperationHistoryTracker {
  final Queue<OperationRecord> undoQueue = Queue();
  final Queue<OperationRecord> redoQueue = Queue();
  int stackSizeLimit = 100;
  bool stackSizeLimitEnabled = true;

  OperationHistoryTracker({
    this.stackSizeLimit = 100,
    this.stackSizeLimitEnabled = true,
  });

  Future<void> track(OperationRecord operation) async {
    await operation.onRedo();
    setQueueOnRedo(operation);
  }

  void trackSync(OperationRecord operation) {
    if (operation is SyncOperationRecord) {
      operation.redoSync();
      setQueueOnRedo(operation);
    } else {
      throw Exception('Unsupported operation type');
    }
  }

  Future<void> undo() async {
    if (undoQueue.isEmpty) {
      return;
    }

    final operation = undoQueue.removeLast();
    await operation.onUndo();
    setQueueOnUndo(operation);
  }

  void undoSync() {
    if (undoQueue.isEmpty) {
      return;
    }
    final lastOperation = undoQueue.last;
    if (lastOperation is SyncOperationRecord) {
      lastOperation.undoSync();
      setQueueOnUndo(lastOperation);
    } else {
      throw Exception('Unsupported operation type');
    }
  }

  Future<void> redo() async {
    if (redoQueue.isEmpty) {
      return;
    }

    final operation = redoQueue.removeLast();
    setQueueOnRedo(operation);
    await operation.onRedo();
  }

  void redoSync() {
    if (redoQueue.isEmpty) {
      return;
    }
    final lastOperation = redoQueue.last;
    if (lastOperation is SyncOperationRecord) {
      lastOperation.redoSync();
      setQueueOnRedo(lastOperation);
    } else {
      throw Exception('Unsupported operation type');
    }
  }

  void clear() {
    undoQueue.clear();
    redoQueue.clear();
  }

  void setQueueOnRedo(OperationRecord operation) {
    if (undoQueueFull) {
      undoQueue.removeFirst();
    }
    undoQueue.add(operation);
    redoQueue.clear();
  }

  void setQueueOnUndo(OperationRecord operation) {
    if (redoQueueFull) {
      redoQueue.removeFirst();
    }
    redoQueue.add(operation);
    undoQueue.clear();
  }

  bool get undoQueueFull => undoQueue.length >= stackSizeLimit;
  bool get redoQueueFull => redoQueue.length >= stackSizeLimit;
}
