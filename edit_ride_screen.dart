import 'package:material_ui/material_ui.dart';
import '../models/ride.dart';

class EditRideScreen extends StatefulWidget {
  final Ride ride;

  const EditRideScreen({
    super.key,
    required this.ride,
  });

  @override
  State<EditRideScreen> createState() => _EditRideScreenState();
}

class _EditRideScreenState extends State<EditRideScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _driver;
  late final TextEditingController _from;
  late final TextEditingController _to;
  late final TextEditingController _date;
  late final TextEditingController _time;
  late final TextEditingController _price;
  late final TextEditingController _vehicle;
  late final TextEditingController _note;

  late int _seats;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final ride = widget.ride;
    _driver = TextEditingController(text: ride.driverName);
    _from = TextEditingController(text: ride.from);
    _to = TextEditingController(text: ride.to);
    _date = TextEditingController(text: ride.date);
    _time = TextEditingController(text: ride.time);
    _price = TextEditingController(
      text: ride.price.toStringAsFixed(2),
    );
    _vehicle = TextEditingController(text: ride.vehicle);
    _note = TextEditingController(text: ride.note);
    _seats = ride.seats;
  }

  @override
  void dispose() {
    _driver.dispose();
    _from.dispose();
    _to.dispose();
    _date.dispose();
    _time.dispose();
    _price.dispose();
    _vehicle.dispose();
    _note.dispose();
    super.dispose();
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        _date.text =
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
        _time.text = selected.format(context);
      });
    }
  }

  Future<bool> _confirmCancel() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'Are you sure you want to discard the changes you made?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = widget.ride.copyWith(
      driverName: _driver.text.trim(),
      from: _from.text.trim(),
      to: _to.text.trim(),
      date: _date.text.trim(),
      time: _time.text.trim(),
      price: double.parse(_price.text.trim()),
      seats: _seats,
      vehicle: _vehicle.text.trim(),
      note: _note.text.trim(),
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmCancel()) {
          if (mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text('Edit Ride'),
          backgroundColor: const Color(0xFFF5F7FB),
          leading: IconButton(
            tooltip: 'Close',
            onPressed: () async {
              if (await _confirmCancel()) {
                if (mounted) Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Update your ride details.',
                        style: TextStyle(
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _field(
                'Driver name',
                _driver,
                icon: Icons.person,
                validator: _requiredText,
              ),
              _field(
                'Pickup location',
                _from,
                icon: Icons.trip_origin,
                validator: _requiredText,
              ),
              _field(
                'Destination',
                _to,
                icon: Icons.location_on,
                validator: _requiredText,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                      'Date',
                      _date,
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _pickDate,
                      validator: _requiredText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      'Time',
                      _time,
                      icon: Icons.access_time,
                      readOnly: true,
                      onTap: _pickTime,
                      validator: _requiredText,
                    ),
                  ),
                ],
              ),
              _field(
                'Price per passenger (RM)',
                _price,
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
                'Vehicle',
                _vehicle,
                icon: Icons.directions_car,
                validator: _requiredText,
              ),
              _field(
                'Additional note',
                _note,
                icon: Icons.notes,
                maxLines: 3,
                required: false,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveChanges,
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
                          'Save Changes',
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
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType? keyboard,
    int maxLines = 1,
    bool required = true,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        validator:
            validator ?? (required ? _requiredText : null),
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
        ),
      ),
    );
  }
}