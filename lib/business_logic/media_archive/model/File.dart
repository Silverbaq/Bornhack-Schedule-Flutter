class File {
  File(
      this.polymorphic_ctype,
      this.uuid,
      this.owner,
      this.created,
      this.updated,
      this.title,
      this.description,
      this.source,
      this.license,
      this.attribution,
      this.status,
      this.original_filename,
      this.file_size,
      this.thumbnail_url,
      this.basefile_ptr,
      this.original,
      [this.url = '',
      this.filename = '']);

  int polymorphic_ctype;
  String uuid;
  String owner;
  String created;
  String updated;
  String title;
  String description;
  String source;
  String license;
  String attribution;
  String status;
  String original_filename;
  int file_size;
  String thumbnail_url;
  String basefile_ptr;
  String original;
  String url;
  String filename;

  //String tags [],
  //String tagged_items []

  File.fromJson(Map<String, dynamic> json)
      : polymorphic_ctype = json['polymorphic_ctype'] ?? 0,
        uuid = json['uuid']  ?? '',
        owner = json['owner']  ?? '',
        created = json['created']  ?? '',
        updated = json['updated']  ?? '',
        title = json['title']  ?? '',
        description = json['description']  ?? '',
        source = json['source']  ?? '',
        license = json['license']  ?? '',
        attribution = json['attribution']  ?? '',
        status = json['status']  ?? '',
        original_filename = json['original_filename']  ?? '',
        file_size = json['file_size'] ?? 0,
        thumbnail_url = json['thumbnail_url'] ?? '',
        basefile_ptr = json['basefile_ptr'] ?? '',
        original = json['original'] ?? '',
        url = json['url'] ?? '',
        filename = json['filename'] ?? '';
}
