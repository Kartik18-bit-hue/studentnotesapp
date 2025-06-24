import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Health Tracker'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('💧 Water Intake'),
            _buildWaterTracker(),
            const SizedBox(height: 20),
            _buildSectionTitle('🛌 Sleep Log'),
            _buildSleepCard(),
            const SizedBox(height: 20),
            _buildSectionTitle('🏃 Exercise Reminder'),
            _buildExerciseCard(),
            const SizedBox(height: 20),
            _buildSectionTitle('🧘 Mental Health Tip'),
            _buildTipCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildWaterTracker() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_drink, size: 40, color: Colors.teal),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You drank 5 of 8 cups today',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: 5 / 8,
                  backgroundColor: Colors.white,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.bedtime, size: 40, color: Colors.indigo),
          SizedBox(width: 20),
          Expanded(
            child: Text('Last night you slept 7 hours. Keep it up!',
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.fitness_center, size: 40, color: Colors.orange),
          SizedBox(width: 20),
          Expanded(
            child: Text('Time for a quick 10-minute stretch!',
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.self_improvement, size: 40, color: Colors.purple),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              '"Take deep breaths before exams to reduce stress."',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
