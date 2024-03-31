class DetailsPhoto {
  String id;
  DateTime createdAt;
  int width;
  int height;
  String? description;
  Urls urls;
  User user;

  DetailsPhoto({
    required this.id,
    required this.createdAt,
    required this.width,
    required this.height,
    required this.description,
    required this.urls,
    required this.user,
  });
}

class User {
  String name;
  ProfileImage profileImage;

  User({
    required this.name,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    profileImage: ProfileImage.fromJson(json["profile_image"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_image": profileImage.toJson(),
  };
}

class ProfileImage {
  String small;
  String medium;
  String large;

  ProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    small: json["small"],
    medium: json["medium"],
    large: json["large"],
  );

  Map<String, dynamic> toJson() => {
    "small": small,
    "medium": medium,
    "large": large,
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
