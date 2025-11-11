import 'package:flutter/material.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  DateTime? _selectedDateTime;
  String _selectedType = 'Vitamin'; // Default value yang sesuai dengan daftar

  // Daftar tipe obat yang lengkap dan konsisten
  final List<String> _medicationTypes = [
    'Vitamin',
    'Antibiotik',
    'Obat Resep',
    'Suplemen',
    'Herbal',
    'Lainnya',
  ];

  // Fungsi untuk memilih tanggal dan waktu
  Future<void> _pickDateTime() async {
    DateTime initialDate = _selectedDateTime ?? DateTime.now();

    // Pilih tanggal
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pilih waktu
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveMedication() {
    final name = _nameController.text.trim();
    final dose = _doseController.text.trim();
    final time = _selectedDateTime;
    final type = _selectedType;

    // Validasi input
    if (name.isEmpty || dose.isEmpty || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua kolom harus diisi dan waktu dipilih'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Format data untuk dikembalikan
    final newMedication = {
      'name': name,
      'dose': dose,
      'time': time,
      'type': type,
      'formattedTime':
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
    };

    Navigator.pop(context, newMedication);
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Vitamin':
        return Colors.orange;
      case 'Antibiotik':
        return Colors.red;
      case 'Obat Resep':
        return Colors.purple;
      case 'Suplemen':
        return Colors.teal;
      case 'Herbal':
        return Colors.green;
      case 'Lainnya':
        return Colors.grey;
      default:
        return const Color.fromARGB(255, 58, 183, 108);
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeText = _selectedDateTime != null
        ? "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} • ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}"
        : "Pilih tanggal dan waktu";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Obat Baru'),
        backgroundColor: const Color.fromARGB(255, 58, 183, 108),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header informasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 58, 183, 108).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.medication_liquid,
                    color: const Color.fromARGB(255, 58, 183, 108),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Isi informasi obat dengan lengkap untuk pengingat yang lebih baik',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Obat
                    _buildSectionLabel('Nama Obat'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        hintText: 'Contoh: Paracetamol, Vitamin C, dll.',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    // Dosis Obat
                    _buildSectionLabel('Dosis'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _doseController,
                      decoration: _buildInputDecoration(
                        hintText: 'Contoh: 1 Tablet 500mg, 2 Kapsul, dll.',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    // Tipe Obat
                    _buildSectionLabel('Tipe Obat'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                          items: _medicationTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(type),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    type,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Waktu Minum Obat
                    _buildSectionLabel('Waktu Minum Obat'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDateTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedDateTime != null
                                ? const Color.fromARGB(255, 58, 183, 108)
                                : Colors.grey.shade300,
                            width: _selectedDateTime != null ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedDateTime != null
                              ? const Color.fromARGB(
                                  255,
                                  58,
                                  183,
                                  108,
                                ).withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: _selectedDateTime != null
                                  ? const Color.fromARGB(255, 58, 183, 108)
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                timeText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDateTime != null
                                      ? Colors.black87
                                      : Colors.grey.shade500,
                                  fontWeight: _selectedDateTime != null
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: _selectedDateTime != null
                                  ? const Color.fromARGB(255, 58, 183, 108)
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Info tambahan tentang pemilihan waktu
                    if (_selectedDateTime != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Obat akan diingatkan pada waktu yang dipilih',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveMedication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 58, 183, 108),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Simpan Obat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk label section
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  // Helper method untuk input decoration
  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 58, 183, 108),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }
}
