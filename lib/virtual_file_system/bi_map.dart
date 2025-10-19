class BiMap<K, V> {
  final Map<K, V> _forwardMap = {};

  final Map<V, K> _reverseMap = {};

  /// 插入 Key-Value 对。
  /// 如果 Key 或 Value 已存在，则抛出异常，以保持双向映射的唯一性。
  void put(K key, V value) {
    if (_forwardMap.containsKey(key)) {
      throw ArgumentError('Key "$key" already exists in the BiMap.');
    }
    if (_reverseMap.containsKey(value)) {
      throw ArgumentError('Value "$value" already exists in the BiMap.');
    }

    _forwardMap[key] = value;
    _reverseMap[value] = key;
  }

  /// 通过 Key 查找 Value。
  V? getValue(K key) {
    return _forwardMap[key];
  }

  /// 通过 Value 查找 Key。
  K? getKey(V value) {
    return _reverseMap[value];
  }

  /// 通过 Key 删除 Key-Value 对。
  V? removeByKey(K key) {
    final value = _forwardMap.remove(key);
    if (value != null) {
      _reverseMap.remove(value);
    }
    return value; // 返回被删除的 Value
  }

  /// 通过 Value 删除 Key-Value 对。
  K? removeByValue(V value) {
    final key = _reverseMap.remove(value);
    if (key != null) {
      _forwardMap.remove(key);
    }
    return key; // 返回被删除的 Key
  }

  int get length => _forwardMap.length;
  bool get isEmpty => _forwardMap.isEmpty;
  bool get isNotEmpty => _forwardMap.isNotEmpty;

  bool containsKey(K key) => _forwardMap.containsKey(key);
  bool containsValue(V value) => _reverseMap.containsKey(value);

  void clear() {
    _forwardMap.clear();
    _reverseMap.clear();
  }

  // 获取反向映射的视图
  Map<V, K> get inverse => Map.unmodifiable(_reverseMap);

  // 允许使用 biMap[key] 语法获取 Value
  V? operator [](K key) => _forwardMap[key];
}
