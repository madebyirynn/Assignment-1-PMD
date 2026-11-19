import 'package:material_ui/material_ui.dart';
import '../models/ride.dart';
import 'edit_ride_screen.dart';

class RideDetailsResult {
  final Ride? updatedRide;
  final bool deleted;
  const RideDetailsResult({this.updatedRide, this.deleted = false});
}

class RideDetailsScreen extends StatelessWidget {
  final Ride ride;
  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: const Color(0xFFF5F7FB),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updated = await Navigator.push<Ride>(
                context, MaterialPageRoute(builder: (_) => EditRideScreen(ride: ride)));
              if (updated != null && context.mounted) {
                Navigator.pop(context, RideDetailsResult(updatedRide: updated));
              }
            },
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(22)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.directions_car, color: Colors.white, size: 35),
            const SizedBox(height: 18),
            Text('${ride.from} → ${ride.to}',
              style: const TextStyle(color: Colors.white, fontSize: 22,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('RM ${ride.price.toStringAsFixed(2)} per passenger',
              style: const TextStyle(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 20),
        detail(Icons.person_outline, 'Driver', ride.driverName),
        detail(Icons.calendar_today_outlined, 'Date', ride.date),
        detail(Icons.access_time, 'Departure time', ride.time),
        detail(Icons.event_seat_outlined, 'Available seats', '${ride.seats} seats'),
        detail(Icons.directions_car_outlined, 'Vehicle', ride.vehicle),
        detail(Icons.notes_outlined, 'Additional note',
          ride.note.isEmpty ? 'No additional note' : ride.note),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context,
            const RideDetailsResult(deleted: true)),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete this ride'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        ),
        const SizedBox(height: 10),
        SizedBox(height: 50, child: FilledButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Demo only: no booking is saved.'))),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
          child: const Text('Request to Join (Demo)'),
        )),
      ]),
    );
  }

  Widget detail(IconData icon, String title, String value) {
    return Card(
      elevation: 0, color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2563EB)),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        subtitle: Text(value, style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
      ),
    );
  }
}
