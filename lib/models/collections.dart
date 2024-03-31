import 'dart:convert';

List<Collections> collectionsResFromJson(String str) =>
    List<Collections>.from(
        json.decode(str).map((x) => Collections.fromJson(x)));

String collectionsResToJson(List<Collections> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Collections {
  String id;
  String title;
  int totalPhotos;
  CollectionsReCoverPhoto coverPhoto;

  Collections({
    required this.id,
    required this.title,
    required this.totalPhotos,
    required this.coverPhoto,
  });

  factory Collections.fromJson(Map<String, dynamic> json) => Collections(
    id: json["id"],
    title: json["title"],
    totalPhotos: json["total_photos"],
    coverPhoto: CollectionsReCoverPhoto.fromJson(json["cover_photo"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "total_photos": totalPhotos,
    "cover_photo": coverPhoto.toJson(),
  };
}

class CollectionsReCoverPhoto {
  String id;
  Urls urls;

  CollectionsReCoverPhoto({
    required this.id,
    required this.urls,
  });

  factory CollectionsReCoverPhoto.fromJson(Map<String, dynamic> json) =>
      CollectionsReCoverPhoto(
        id: json["id"],
        urls: Urls.fromJson(json["urls"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "urls": urls.toJson(),
  };
}

class Urls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;
  String smallS3;

  Urls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    raw: json["raw"],
    full: json["full"],
    regular: json["regular"],
    small: json["small"],
    thumb: json["thumb"],
    smallS3: json["small_s3"],
  );

  Map<String, dynamic> toJson() => {
    "raw": raw,
    "full": full,
    "regular": regular,
    "small": small,
    "thumb": thumb,
    "small_s3": smallS3,
  };
}