import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../services/tts_service.dart'; // Import the new service
import 'prayer_creation_screen.dart'; // So you can navigate to it
import 'package:soulai_app/api_config.dart';

class AIPrayerScreen extends StatefulWidget {
  const AIPrayerScreen({super.key});
  final apiKey = myApiKey;

  @override
  State<AIPrayerScreen> createState() => _AIPrayerScreenState();
}

class _AIPrayerScreenState extends State<AIPrayerScreen> {
  final _promptController = TextEditingController();
  final _ttsService = TextToSpeechService(); // Create an instance of the service
  bool _isLoading = false;
  String _generatedPrayer = '';

  @override
  void dispose() {
    _promptController.dispose();
    _ttsService.stop(); // Stop speaking when the screen is closed
    super.dispose();
  }

  Future<void> _getAIPrayer() async {
    if (_promptController.text.isEmpty) {
      return;
    }
    await _ttsService.stop(); // Stop any previous speech
    setState(() {
      _isLoading = true;
      _generatedPrayer = '';
    });

    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('generatePrayer');

    try {
      final fullPrompt =
          "Generate a short, reflective prayer about: ${_promptController.text}";
      final response =
          await callable.call<Map<String, dynamic>>({'prompt': fullPrompt});
      setState(() {
        _generatedPrayer =
            response.data['prayerText'] ?? 'Failed to generate prayer.';
      });
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _generatedPrayer = 'An error occurred: ${e.message}';
      });
      print('Firebase Functions Exception: ${e.code} ${e.message}');
    } catch (e) {
      setState(() {
        _generatedPrayer = 'An unexpected error occurred.';
      });
      print('Generic Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Prayer with AI'),
        actions: [
          // Add a button to navigate to the manual prayer creation screen
          IconButton(
            icon: const Icon(Icons.add_comment),
            tooltip: 'Write your own',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrayerCreationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... (Text and TextField widgets remain the same)
            const Text(
              'What shall we pray for today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'e.g., my family\'s health, a difficult decision...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getAIPrayer,
              child: const Text('Generate Prayer'),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_generatedPrayer.isNotEmpty)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Adjusted padding
                  child: Row(
                    // Use a Row to place the button
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _generatedPrayer,
                            style: const TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      // The "Read Aloud" button
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _ttsService.speak(_generatedPrayer),
                        tooltip: 'Read Aloud',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
