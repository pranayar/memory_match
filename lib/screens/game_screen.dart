import 'dart:async';
import 'package:flutter/material.dart';
import '../models/memory_card.dart';
import '../widgets/memory_card_widget.dart';

class GameScreen extends StatefulWidget {
  final int rows;
  final int cols;

  const GameScreen({
    super.key,
    required this.rows,
    required this.cols,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<MemoryCard> cards = [];
  MemoryCard? firstCard;
  MemoryCard? secondCard;
  int moves = 0;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  void _generateCards() {
    final int totalCards = widget.rows * widget.cols;

    if (totalCards % 2 != 0) {
      throw Exception("Grid must contain an even number of cards.");
    }

    // Enough unique values for all difficulties
    List<String> values = [
      "🍎", "🍌", "🍇", "🍓", "🍒", "🍉",
      "🥝", "🍍", "🥥", "🍑", "🍋", "🍊",
      "🍈", "🍐", "🍏"
    ];

    cards = [];
    int id = 0;

    // Take as many pairs as needed
    final neededPairs = totalCards ~/ 2;
    final selected = values.take(neededPairs).toList();

    for (var v in selected) {
      cards.add(MemoryCard(id: id++, value: v));
      cards.add(MemoryCard(id: id++, value: v));
    }

    cards.shuffle();
    moves = 0;
    firstCard = null;
    secondCard = null;

    setState(() {});
  }

  void _onCardTap(int index) {
    if (waiting) return;
    if (cards[index].isFaceUp || cards[index].isMatched) return;

    setState(() {
      cards[index].isFaceUp = true;
    });

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      moves++;

      if (firstCard!.value == secondCard!.value) {
        setState(() {
          firstCard!.isMatched = true;
          secondCard!.isMatched = true;
        });
        firstCard = null;
        secondCard = null;
        _checkWin();
      } else {
        waiting = true;
        Timer(const Duration(seconds: 1), () {
          setState(() {
            firstCard!.isFaceUp = false;
            secondCard!.isFaceUp = false;
          });
          firstCard = null;
          secondCard = null;
          waiting = false;
        });
      }
    }
  }

  void _checkWin() {
    final allMatched = cards.every((c) => c.isMatched);
    if (allMatched) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("You Win!"),
          content: Text("You finished in $moves moves."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _generateCards();
              },
              child: const Text("Play Again"),
            )
          ],
        ),
      );
    }
  }

  void restartGame() {
    _generateCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: restartGame,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Find all matching pairs!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Moves: $moves',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cols,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return MemoryCardWidget(
                  card: card,
                  onTap: () => _onCardTap(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
