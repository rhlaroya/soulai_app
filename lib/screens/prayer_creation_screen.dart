import 'package:flutter/material.dart';
import '../services/database_service.dart'; // Adjust path if needed

class PrayerCreationScreen extends StatefulWidget {
  const PrayerCreationScreen({super.key});

  @override
  State<PrayerCreationScreen> createState() => _PrayerCreationScreenState();
}

class _PrayerCreationScreenState extends State<PrayerCreationScreen> {
  final _prayerController = TextEditingController();
  final _dbService = DatabaseService();
  bool _isPublic = false;
  bool _isLoading = false;

  Future<void> _savePrayer() async {
    if (_prayerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prayer.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _dbService.addPrayer(_prayerController.text, _isPublic);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your prayer has been saved!')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Prayer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _prayerController,
              decoration: const InputDecoration(
                labelText: 'Write your prayer here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Share with friends?'),
              value: _isPublic,
              onChanged: (bool value) {
                setState(() {
                  _isPublic = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _savePrayer,
                    child: const Text('Save Prayer'),
                  ),
          ],
        ),
      ),
    );
  }
}
