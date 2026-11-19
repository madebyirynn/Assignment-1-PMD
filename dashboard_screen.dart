import 'package:material_ui/material_ui.dart';
import '../models/ride.dart';
import '../widgets/bottom_nav_bar.dart';
import 'available_rides_screen.dart';
import 'create_ride_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Ride> rides = [
    const Ride(
      id: '1',
      driverName: 'Aiman',
      from: 'MSU Campus',
      to: 'KL Sentral',
      date: '15 Nov 2026',
      time: '5:30 PM',
      price: 8,
      seats: 3,
      vehicle: 'Perodua Myvi',
      note: 'Pickup near the main entrance.',
    ),
    const Ride(
      id: '2',
      driverName: 'Sarah',
      from: 'MSU Campus',
      to: 'Shah Alam',
      date: '16 Nov 2026',
      time: '10:00 AM',
      price: 5,
      seats: 2,
      vehicle: 'Honda City',
    ),
    const Ride(
      id: '3',
      driverName: 'Daniel',
      from: 'MSU Campus',
      to: 'Subang Jaya',
      date: '16 Nov 2026',
      time: '6:00 PM',
      price: 7,
      seats: 1,
      vehicle: 'Proton Saga',
    ),
  ];

  Future<void> openCreateRide() async {
    final result = await Navigator.push<Ride>(
      context,
      MaterialPageRoute(builder: (_) => const CreateRideScreen()),
    );
    if (result != null) {
      setState(() {
        rides.insert(0, result);
        currentIndex = 1;
      });
    }
  }

  void updateRide(Ride updated) {
    final index = rides.indexWhere((ride) => ride.id == updated.id);
    if (index != -1) setState(() => rides[index] = updated);
  }

  void deleteRide(String id) {
    setState(() => rides.removeWhere((ride) => ride.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      AvailableRidesScreen(
        rides: rides,
        onCreateRide: openCreateRide,
        onRideUpdated: updateRide,
        onRideDeleted: deleteRide,
      ),
      buildProfile(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: IndexedStack(index: currentIndex, children: pages),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAMPUS CARPOOL BOARD',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Hi, User! 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Where are you heading today?',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.person, color: Color(0xFF2563EB), size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share the ride,\nshare the journey.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find a ride or offer a seat to campus friends.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 17),
                FilledButton.icon(
                  onPressed: openCreateRide,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1D4ED8),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Create a ride'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFDBEAFE),
                  child: Icon(Icons.directions_car, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Rides',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${rides.length} rides available',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: quickAction(
                  Icons.search,
                  'Find a ride',
                  'Browse available rides',
                  () => setState(() => currentIndex = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: quickAction(
                  Icons.add_road,
                  'Offer a ride',
                  'Share your journey',
                  openCreateRide,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available rides',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => currentIndex = 1),
                child: const Text('See all'),
              ),
            ],
          ),
          ...rides.take(2).map(miniRideCard),
        ],
      ),
    );
  }

  Widget quickAction(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback action,
  ) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7ECF3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2563EB), size: 27),
            const SizedBox(height: 13),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget miniRideCard(Ride ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFEFF6FF),
            child: Icon(Icons.directions_car, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ride.from} → ${ride.to}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ride.date} • ${ride.time}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'RM ${ride.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Student profile card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFDBEAFE),
                  child: Icon(Icons.person, size: 45, color: Color(0xFF2563EB)),
                ),
                SizedBox(height: 14),
                Text(
                  'Student User',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Management & Science University',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('Student ID'),
                  subtitle: Text('Demo Student ID'),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Email Address'),
                  subtitle: Text('student@msu.edu.my'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Ride navigation
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.directions_car,
                color: Color(0xFF2563EB),
              ),
              title: const Text('Browse Rides'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                setState(() => currentIndex = 1);
              },
            ),
          ),

          const SizedBox(height: 10),

          // Settings
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Campus Carpool Board',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'University mobile application project',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
