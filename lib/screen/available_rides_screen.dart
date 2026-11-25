import 'package:flutter/material.dart';

import '../models/ride.dart';
import 'ride_details_screen.dart';

class AvailableRidesScreen extends StatefulWidget {
  final List<Ride> rides;
  final VoidCallback onCreateRide;
  final ValueChanged<Ride> onRideUpdated;
  final ValueChanged<String> onRideDeleted;

  const AvailableRidesScreen({
    super.key,
    required this.rides,
    required this.onCreateRide,
    required this.onRideUpdated,
    required this.onRideDeleted,
  });

  @override
  State<AvailableRidesScreen> createState() => _AvailableRidesScreenState();
}

class _AvailableRidesScreenState extends State<AvailableRidesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _sortBy = 'Soonest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ride> get _filteredRides {
    final query = _query.toLowerCase();

    final matches = widget.rides.where((ride) {
      if (query.isEmpty) return true;
      return ride.from.toLowerCase().contains(query) ||
          ride.to.toLowerCase().contains(query) ||
          ride.driverName.toLowerCase().contains(query) ||
          ride.vehicle.toLowerCase().contains(query);
    }).toList();

    if (_sortBy == 'Lowest price') {
      matches.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Most seats') {
      matches.sort((a, b) => b.seats.compareTo(a.seats));
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    final rides = _filteredRides;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Available Rides',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F7FB),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _sortBy = value),
            icon: const Icon(Icons.sort),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Soonest', child: Text('Soonest')),
              PopupMenuItem(value: 'Lowest price', child: Text('Lowest price')),
              PopupMenuItem(value: 'Most seats', child: Text('Most seats')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: InputDecoration(
                hintText: 'Search location, driver or vehicle',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: rides.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
                    itemCount: rides.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 13),
                    itemBuilder: (context, index) =>
                        _rideCard(context, rides[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onCreateRide,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Ride'),
      ),
    );
  }

  Widget _emptyState() {
    final isSearching = _query.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.directions_car_outlined,
              size: 68,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'No matching rides found'
                  : 'No rides available yet',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try a different pickup, destination or driver name.'
                  : 'Be the first student to share a ride.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            if (!isSearching) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: widget.onCreateRide,
                icon: const Icon(Icons.add),
                label: const Text('Create a ride'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _rideCard(BuildContext context, Ride ride) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final result = await Navigator.push<RideDetailsResult>(
            context,
            MaterialPageRoute(builder: (_) => RideDetailsScreen(ride: ride)),
          );

          if (!mounted || result == null) return;

          if (result.deleted) {
            widget.onRideDeleted(ride.id);
          } else if (result.updatedRide != null) {
            widget.onRideUpdated(result.updatedRide!);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8EDF5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 21,
                    backgroundColor: Color(0xFFEFF6FF),
                    child: Icon(Icons.person, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.driverName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ride.vehicle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'RM ${ride.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              _locationRow(Icons.trip_origin, ride.from),
              const Padding(
                padding: EdgeInsets.only(left: 9),
                child: SizedBox(
                  height: 14,
                  child: VerticalDivider(
                    color: Color(0xFFCBD5E1),
                    thickness: 1.5,
                  ),
                ),
              ),
              _locationRow(Icons.location_on, ride.to),
              const Divider(height: 24),
              Wrap(
                spacing: 15,
                runSpacing: 8,
                children: [
                  _info(Icons.calendar_today_outlined, ride.date),
                  _info(Icons.access_time, ride.time),
                  _info(
                    Icons.event_seat_outlined,
                    '${ride.seats} seat${ride.seats == 1 ? '' : 's'}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View details →',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.black54),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
