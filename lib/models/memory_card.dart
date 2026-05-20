class MemoryCard {
  final int id;
  final String value;
  bool isFaceUp;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.value,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
