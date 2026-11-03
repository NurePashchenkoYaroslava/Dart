import 'package:lab1/eq_man.dart';

void main() {
  print('Етап 1: розбір та валідація');

  final validEquipments = <Equipment>[];
  var processedLines = 0;
  void logProcessed() {
    processedLines++;
  }
  for (final line in rawData) {
    logProcessed();
    final parsed = parseLine(line);

    if (parsed != null) {
      final violations = validateEquipment(parsed);
      if (violations.isEmpty) {
        validEquipments.add(parsed);
      } else {
        print('Помилка валідації в $line: $violations');
      }
    } else {
      print('Помилка розбору формату: $line');
    }
  }

  print(
    'Оброблено рядків: $processedLines. Успішно додано: ${validEquipments.length}\n',
  );

}
