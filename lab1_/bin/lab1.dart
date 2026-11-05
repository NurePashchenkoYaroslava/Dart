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
   print('Етап 2: конвеєри обробки');
  final isPc = makeTypeFilter('PC');
  final totalPcAgeDays = validEquipments
      .where(isPc)
      .map((eq) => DateTime.now().difference(eq.purchaseDate).inDays)
      .fold<int>(0, (sum, days) => sum + days);
  print('1. Загальний час експлуатації всіх ПК: $totalPcAgeDays днів');

  final targetRoom = 301;
  final newestInRoom = validEquipments
      .where((eq) => eq.room == targetRoom)
      .fold<Equipment?>(null, (newest, eq) {
        if (newest == null) return eq;
        return eq.purchaseDate.isAfter(newest.purchaseDate) ? eq : newest;
      });
  print(
    '2. Найновіше обладнання в ауд. $targetRoom: ${newestInRoom?.invNumber ?? "Немає"}',
  );

  final isMonitor = makeTypeFilter('Monitor');
  final monitorAges = validEquipments
      .where(isMonitor)
      .map((eq) => DateTime.now().difference(eq.purchaseDate).inDays);

  final averageMonitorAge = monitorAges.isEmpty
      ? 0.0
      : monitorAges.fold<int>(0, (sum, age) => sum + age) / monitorAges.length;
  print(
    '3. Середній вік моніторів: ${averageMonitorAge.toStringAsFixed(1)} днів\n',
  );

  print('Етап 3: групування');
  final groupedByType = <String, List<Equipment>>{};
  for (final eq in validEquipments) {
    groupedByType.putIfAbsent(eq.type, () => []).add(eq);
  }
  for (final entry in groupedByType.entries) {
    print('Тип "${entry.key}": ${entry.value.length} одиниць');
  }
  print('');
}
