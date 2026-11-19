import 'package:material_ui/material_ui.dart';
import '../models/ride.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverController = TextEditingController(text: 'Aniq');
  final _fromController = TextEditingController(text: 'MSU Campus');
  final _toController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _priceController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _noteController = TextEditingController();

  int _seats = 1;
  bool _isSaving = false;

  @override
  void dispose() {
    _driverController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _vehicleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );

    if (selected != null) {
      setState(() {
        _dateController.text =
            '${selected.day.toString().padLeft(2, '0')}/'
            '${selected.month.toString().padLeft(2, '0')}/'
            '${selected.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selected != null && mounted) {
      setState(() {
        _timeController.text = selected.format(context);
      });
    }
  }

  Future<void> _saveRide() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final ride = Ride(
        id: 'ride_${DateTime.now().microsecondsSinceEpoch}',
        driverName: _driverController.text.trim(),
        from: _fromController.text.trim(),
        to: _toController.text.trim(),
        date: _dateController.text,
        time: _timeController.text,
        price: double.parse(_priceController.text.trim()),
        seats: _seats,
        vehicle: _vehicleController.text.trim(),
        note: _noteController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, ride);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to publish this ride. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Create a Ride'),
        backgroundColor: const Color(0xFFF5F7FB),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Ride information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Share your trip details with other students.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _field(
              'Driver name',
              _driverController,
              icon: Icons.person,
              validator: _requiredText,
            ),
            _field(
              'Pickup location',
              _fromController,
              icon: Icons.trip_origin,
              validator: _requiredText,
            ),
            _field(
              'Destination',
              _toController,
              icon: Icons.location_on,
              validator: _requiredText,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _field(
                    'Date',
                    _dateController,
                    icon: Icons.calendar_today,
                    validator: _requiredText,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    'Time',
                    _timeController,
                    icon: Icons.access_time,
                    validator: _requiredText,
                    readOnly: true,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            _field(
              'Price per passenger (RM)',
              _priceController,
              icon: Icons.payments_outlined,
              keyboard: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }

                final price = double.tryParse(value.trim());
                if (price == null || price < 0) {
                  return 'Enter a valid amount';
                }
                if (price > 999) return 'Amount is too large';
                return null;
              },
            ),
            _field(
              'Vehicle',
              _vehicleController,
              icon: Icons.directions_car,
              validator: _requiredText,
            ),
            const SizedBox(height: 8),
            const Text(
              'Available seats',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Decrease seats',
                    onPressed: _seats > 1
                        ? () => setState(() => _seats--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: Text(
                      '$_seats seat${_seats == 1 ? '' : 's'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Increase seats',
                    onPressed: _seats < 7
                        ? () => setState(() => _seats++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _field(
              'Additional note (optional)',
              _noteController,
              icon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _isSaving ? null : _saveRide,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Publish Ride',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    IconData? icon,
    TextInputType? keyboard,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboard,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        textInputAction:
            maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1.5,
            ),
          ),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}