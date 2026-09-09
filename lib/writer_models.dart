class StoryItem {
  final String id;
  final String authorId;

  String title;
  String genre;      // Adventure/Mystery/…
  String level;      // A/B/C
  int minutes;
  double price;
  String description;
  String content;    // (optional preview text)

  // NEW:
  String? coverPath; // local file path to the cover image
  String? pdfPath;   // local file path to the PDF

  StoryItem({
    required this.id,
    required this.authorId,
    required this.title,
    required this.genre,
    required this.level,
    required this.minutes,
    required this.price,
    required this.description,
    required this.content,
    this.coverPath,
    this.pdfPath,
  });
}
