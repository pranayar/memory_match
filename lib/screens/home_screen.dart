import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memory Match"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Difficulty",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            _difficultyButton(context, "Easy (3x4)", 3, 4),
            const SizedBox(height: 16),

            _difficultyButton(context, "Medium (4x4)", 4, 4),
            const SizedBox(height: 16),

            _difficultyButton(context, "Hard (5x6)", 5, 6),
          ],
        ),
      ),
    );
  }

  Widget _difficultyButton(
      BuildContext context, String label, int rows, int cols) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameScreen(
              rows: rows,
              cols: cols,
            ),
          ),
        );
      },
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
