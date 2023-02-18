import 'dart:convert';

import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class Word {
  @HiveField(0)
  String word;
  @HiveField(1)
  String meaning;
  Word({
    required this.word,
    required this.meaning,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'word': word});
    result.addAll({'meaning': meaning});

    return result;
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      meaning: map['meaning'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) => Word.fromMap(json.decode(source));
}
