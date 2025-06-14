class BlogModel {
  String id;
  String category;
  String title;
  String content;
  String author;
  String authorid;
  DateTime date;
  BlogModel(
    this.id,
    this.category,
    this.title,
    this.content,
    this.author,
    this.authorid,
    this.date
  );

   factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      json['id'],
      json['category'],  // Assuming the JSON key is 'category'
      json['title'],     // Assuming the JSON key is 'title'
      json['content'],   // Assuming the JSON key is 'content'
      json['author'],    // Assuming the JSON key is 'author'
      json['authorid'],  // Assuming the JSON key is 'authorid'
      DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
}