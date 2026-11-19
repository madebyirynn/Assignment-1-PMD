class Ride {
  final String id;
  final String driverName;
  final String from;
  final String to;
  final String date;
  final String time;
  final double price;
  final int seats;
  final String vehicle;
  final String note;

  const Ride({
    required this.id,
    required this.driverName,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.price,
    required this.seats,
    required this.vehicle,
    this.note = '',
  });

  Ride copyWith({
    String? driverName,
    String? from,
    String? to,
    String? date,
    String? time,
    double? price,
    int? seats,
    String? vehicle,
    String? note,
  }) {
    return Ride(
      id: id,
      driverName: driverName ?? this.driverName,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      seats: seats ?? this.seats,
      vehicle: vehicle ?? this.vehicle,
      note: note ?? this.note,
    );
  }
}
