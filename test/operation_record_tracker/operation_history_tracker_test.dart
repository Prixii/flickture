import 'package:flickture/operation_history_tracker/operation_history_tracker.dart';
import 'package:flickture/operation_history_tracker/operation_record.dart';
import 'package:flutter_test/flutter_test.dart';

class SyncCounterRecord extends SyncOperationRecord {
  SyncCounterRecord(int super.data, this.applyChange, {super.name});
  final void Function(int) applyChange;
  @override
  void redo() {
    applyChange(data);
  }

  @override
  void undo() {
    applyChange(-data);
  }
}

class CounterRecord extends OperationRecord {
  CounterRecord(int super.data, this.applyChange, {super.name});
  final void Function(int) applyChange;

  @override
  Future<void> onRedo() async {
    await Future.delayed(Duration(seconds: 1));
    applyChange(data);
  }

  @override
  Future<void> onUndo() async {
    await Future.delayed(Duration(seconds: 1));
    applyChange(-data);
  }
}

void main() {
  group('Operation History Tracker basic behavior', () {
    test('test sync', () {
      final manager = OperationHistoryTracker();

      int counter = 0;
      void apply(int delta) => counter += delta;

      manager.trackSync(SyncCounterRecord(1, apply));
      expect(counter, 1);

      manager.trackSync(SyncCounterRecord(2, apply));
      expect(counter, 3);

      manager.trackSync(SyncCounterRecord(3, apply));
      expect(counter, 6);

      manager.undoSync();
      expect(counter, 3);

      manager.redoSync();
      expect(counter, 6);
    });
    test('test async', () async {
      final manager = OperationHistoryTracker();

      int counter = 0;
      void apply(int delta) => counter += delta;

      await manager.track(CounterRecord(1, apply));
      expect(counter, 1);

      await manager.track(CounterRecord(2, apply));
      expect(counter, 3);

      await manager.track(CounterRecord(3, apply));
      expect(counter, 6);

      await manager.undo();
      expect(counter, 3);

      await manager.redo();
      expect(counter, 6);
    });
  });
}
