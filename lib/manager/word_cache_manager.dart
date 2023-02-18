import 'package:hive_flutter/hive_flutter.dart';

import '../model/word_model.dart';

abstract class ICacheManager<T> {
  final String key;
  Box<List<Word>>? _box;

  ICacheManager(this.key);
  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  void registerAdapters();

  Future<void> clearAll() async {
    await _box?.clear();
  }

  Future<void> addItems(List<T> items);
  List<T>? getValues();
}

class WordCacheManager extends ICacheManager<Word> {
  WordCacheManager(super.key);

  @override
  Future<void> addItems(List<Word> items) async {
    await _box?.add(items);
  }

  @override
  List<Word>? getValues() {
    return _box?.values.first;
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WordAdapter());
    }
  }
}
