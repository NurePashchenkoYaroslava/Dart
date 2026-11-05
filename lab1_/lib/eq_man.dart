typedef Equipment = ({
  String invNumber,
  String type,
  String model,
  int room,
  DateTime purchaseDate,
  String condition,
});
const Set<String> allowedConditions = {
  'Excellent',
  'Good',
  'Needs Repair',
  'Broken',
  'Old',
};

const int expectedCsvFields = 6;
final RegExp invRegex = RegExp(r'^(?<prefix>[A-Z]{3})-(?<number>\d{4})$');
const List<String> rawData = [
  'INV-1001,PC,Dell Optiplex 7090,301,2022-09-01,Good',
  'INV-1002,Monitor,Dell UltraSharp,301,2022-09-01,Good',
  'INV-1003,PC,HP EliteDesk,302,2021-05-15,Needs Repair',
  'INV-1004,Projector,Epson EB-X05,301,2020-11-10,Good',
  'INV-1005,Printer,HP LaserJet Pro,305,2023-01-20,Excellent',
  'INV-1006,PC,Dell Optiplex 7090,302,2022-09-01,Good',
  'INV-1007,Router,Cisco Catalyst,305,2019-04-12,Old',
  'INV-1008,Monitor,LG 27UP850,303,2023-08-14,Excellent',
  'INV-1009,PC,Lenovo ThinkCentre,303,2021-12-01,Good',
  'INV-1010,PC,Dell Optiplex 7090,301,2022-09-01,Broken',
  'INV-1011,Switch,MikroTik CRS,305,2023-02-28,Good',
  'INV-1012,Monitor,Dell UltraSharp,302,2022-09-01,Good',
  'INV-1016,Laptop,Asus ROG,1050,2050-01-01,UnknownState',
  'INV-1013,PC,Dell Optiplex,abc,2022-09-01,Good',
  'INV-1014,Printer,Epson L3150,301,202-99-99,Good',
  'INV-1015,Monitor,Samsung',
  'BAD-FORMAT,Laptop,MacBook,301,2024-01-01,Good',
];

Equipment? parseLine(String line) {
  final parts = line.split(',');
  if (parts.length != expectedCsvFields) {
    return null;
  }
  final invNumber = parts[0].trim();
  if (!invRegex.hasMatch(invNumber)) {
    return null;
  }
  final type = parts[1].trim();
  final model = parts[2].trim();
  final room = int.tryParse(parts[3].trim());
  if (room == null) {
    return null;
  }
  final purchaseDate = DateTime.tryParse(parts[4].trim());
  if (purchaseDate == null) {
    return null;
  }
  final condition = parts[5].trim();
  return (
    invNumber: invNumber,
    type: type,
    model: model,
    room: room,
    purchaseDate: purchaseDate,
    condition: condition,
  );
}

List<String> validateEquipment(Equipment item) {
  final violations = <String>[];
  final currentDate = DateTime.now();

  if (item.room <= 0 || item.room > 999) {
    violations.add(
      'Номер аудиторії (${item.room}) поза допустимим діапазоном.',
    );
  }
  if (item.purchaseDate.isAfter(currentDate)) {
    violations.add('Дата придбання не може бути в майбутньому.');
  }
  if (item.purchaseDate.year < 1990) {
    violations.add(
      'Підозріло стара дата придбання: ${item.purchaseDate.year} рік.',
    );
  }
  if (!allowedConditions.contains(item.condition)) {
    violations.add(
      'Невідомий стан обладнання: "${item.condition}". '
      'Очікується одне з: $allowedConditions',
    );
  }

  return violations;
}

bool Function(Equipment) makeTypeFilter(String targetType) {
  return (Equipment eq) => eq.type.toLowerCase() == targetType.toLowerCase();
}
