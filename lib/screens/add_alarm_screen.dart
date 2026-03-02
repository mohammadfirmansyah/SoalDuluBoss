import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<String> _selectedCategories = [];
  String _selectedDifficulty = 'medium';
  bool _vibrate = true;
  final TextEditingController _labelController = TextEditingController();

  final List<String> _categories = ['math', 'physics', 'chemistry'];
  final Map<String, String> _categoryNames = {
    'math': 'Matematika',
    'physics': 'Fisika',
    'chemistry': 'Kimia',
  };
  final Map<String, IconData> _categoryIcons = {
    'math': Icons.calculate,
    'physics': Icons.science,
    'chemistry': Icons.biotech,
  };

  final List<String> _difficulties = ['easy', 'medium', 'hard'];
  final Map<String, String> _difficultyNames = {
    'easy': 'Mudah',
    'medium': 'Sedang',
    'hard': 'Sulit',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Alarm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Picker
              _buildTimePicker(),
              const SizedBox(height: 32),

              // Label
              _buildLabelInput(),
              const SizedBox(height: 24),

              // Categories
              _buildCategorySection(),
              const SizedBox(height: 24),

              // Difficulty
              _buildDifficultySection(),
              const SizedBox(height: 24),

              // Vibrate Option
              _buildVibrateOption(),
              const SizedBox(height: 40),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Pilih Waktu',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _selectTime,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Label Alarm',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _labelController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Contoh: Bangun Pagi',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.label, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Soal',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pilih minimal 1 kategori',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCategories.remove(category);
                    } else {
                      _selectedCategories.add(category);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.red
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _categoryIcons[category],
                        color: isSelected ? Colors.white : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _categoryNames[category]!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '⚠️ Wajib pilih minimal 1 kategori',
                style: TextStyle(
                  color: Colors.orange[300],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tingkat Kesulitan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: _difficulties.map((difficulty) {
              final isSelected = _selectedDifficulty == difficulty;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getDifficultyColor(difficulty)
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? _getDifficultyColor(difficulty)
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _difficultyNames[difficulty]!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDifficultyStars(difficulty, isSelected),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildDifficultyStars(String difficulty, bool isSelected) {
    int starCount = difficulty == 'easy' ? 1 : (difficulty == 'medium' ? 2 : 3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < starCount ? Icons.star : Icons.star_border,
          color: isSelected ? Colors.white : Colors.grey,
          size: 12,
        );
      }),
    );
  }

  Widget _buildVibrateOption() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.vibration,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Getar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Alarm akan bergetar',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _vibrate,
            onChanged: (value) {
              setState(() {
                _vibrate = value;
              });
            },
            activeThumbColor: Colors.red, // Perbaikan: Ganti activeColor dengan activeThumbColor
            activeTrackColor: Colors.red.withValues(alpha: 0.5), // Tambahkan track color
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.redAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _selectedCategories.isEmpty ? null : _saveAlarm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'SIMPAN ALARM',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              onPrimary: Colors.white,
              surface: Color(0xFF16213e),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAlarm() async {
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 kategori soal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final alarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      categories: List.from(_selectedCategories),
      difficulty: _selectedDifficulty,
      vibrate: _vibrate,
      label: _labelController.text.isEmpty ? 'Alarm' : _labelController.text,
    );

    final success = await AlarmService().scheduleAlarm(alarm);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alarm berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan alarm'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }
}