// Author Class
class Author {
  final int id;
  final String name;
  final String urlAvatar;
  final String description;

  String get getName => name;
  String get getUrlAvatar => urlAvatar;
  String get getDescription => description;

  Author({this.id, this.name, this.urlAvatar, this.description});

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      id: json["id"],
      name: json["name"],
      urlAvatar: json["avatar_urls"]["96"],
      description: json["description"],
    );
  }
}