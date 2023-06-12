class Album {
  Album(this.uuid, this.owner, this.created, this.updated, this.title,
      this.description);

  String uuid;
  String owner;
  DateTime created;
  DateTime updated;
  String title;
  String description;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description
  };

  Album.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        owner = json['owner'],
        created = new DateTime(json['created']),
        updated = new DateTime(json['updated']),
        title = json['title'],
        description = json['description'];
}
