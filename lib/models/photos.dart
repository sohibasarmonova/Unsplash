// To parse this JSON data, do
//
//     final photosListRes = photosListResFromJson(jsonString);

import 'dart:convert';

import 'details_photo.dart';

List<Photo> photosListResFromJson(String str) => List<Photo>.from(json.decode(str).map((x) => Photo.fromJson(x)));

String photosListResToJson(List<Photo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Photo {
  String id;
  DateTime createdAt;
  int width;
  int height;
  String? description;
  Urls urls;
  User user;

  Photo({
    required this.id,
    required this.createdAt,
    required this.width,
    required this.height,
    this.description,
    required this.urls,
    required this.user,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    width: json["width"],
    height: json["height"],
    description: json["description"],
    urls: Urls.fromJson(json["urls"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "width": width,
    "height": height,
    "description": description,
    "urls": urls.toJson(),
    "user": user.toJson(),
  };
}

// class User {
//   String name;
//   ProfileImage profileImage;
//
//   User({
//     required this.name,
//     required this.profileImage,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     name: json["name"],
//     profileImage: ProfileImage.fromJson(json["profile_image"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "profile_image": profileImage.toJson(),
//   };
// }
//
// class ProfileImage {
//   String small;
//   String medium;
//   String large;
//
//   ProfileImage({
//     required this.small,
//     required this.medium,
//     required this.large,
//   });
//
//   factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
//     small: json["small"],
//     medium: json["medium"],
//     large: json["large"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "small": small,
//     "medium": medium,
//     "large": large,
//   };
// }


// class Urls {
//   String raw;
//   String full;
//   String regular;
//   String small;
//   String thumb;
//   String smallS3;
//
//   Urls({
//     required this.raw,
//     required this.full,
//     required this.regular,
//     required this.small,
//     required this.thumb,
//     required this.smallS3,
//   });
//
//   factory Urls.fromJson(Map<String, dynamic> json) => Urls(
//     raw: json["raw"],
//     full: json["full"],
//     regular: json["regular"],
//     small: json["small"],
//     thumb: json["thumb"],
//     smallS3: json["small_s3"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "raw": raw,
//     "full": full,
//     "regular": regular,
//     "small": small,
//     "thumb": thumb,
//     "small_s3": smallS3,
//   };
// }
