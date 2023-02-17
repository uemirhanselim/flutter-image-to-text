import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUp(
    () {
      Hive.init("database");
    },
  );

  test('Read and Write Test', () async {
    final box = await Hive.openBox<String>("words");

    await box.add("elegant");

    expect(box.values.first, "elegant");
    print("The word: ${box.values.first}");
  });

  test('Write a Map and update and read Test', () async {
    final box = await Hive.openBox<Map<String, String>>("Dictionary");

    Map<String, String> wordsAndMeanings = {
      "Cat": "Kedi",
      "Dog": "Köpek",
      "Mouse": "Fare",
    };

    await box.put("wAm", wordsAndMeanings);

    Map<String, String>? response = box.get("wAm");

    expect(response!.keys.length, 3);
  });
}
