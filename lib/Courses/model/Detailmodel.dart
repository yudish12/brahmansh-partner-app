// To parse this JSON data, do

// ignore_for_file: file_names

class ChapterDetailmodel {
  int? id;
  String? name;
  String? description;
  String? image;
  int? coursePrice;
  int? courseCategoryId;
  String? courseBadge;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? courseOrderStatus;
  Category? category;
  List<Chapter>? chapters;

  ChapterDetailmodel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.coursePrice,
    this.courseCategoryId,
    this.courseBadge,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.courseOrderStatus,
    this.category,
    this.chapters,
  });

  factory ChapterDetailmodel.fromJson(Map<String, dynamic> json) =>
      ChapterDetailmodel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        coursePrice: json["course_price"],
        courseCategoryId: json["course_category_id"],
        courseBadge: json["course_badge"],
        isActive: json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        courseOrderStatus: json["courseOrderStatus"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        chapters: json["chapters"] == null
            ? []
            : List<Chapter>.from(
                json["chapters"]!.map((x) => Chapter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "course_price": coursePrice,
        "course_category_id": courseCategoryId,
        "course_badge": courseBadge,
        "isActive": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "courseOrderStatus": courseOrderStatus,
        "category": category?.toJson(),
        "chapters": chapters == null
            ? []
            : List<dynamic>.from(chapters!.map((x) => x.toJson())),
      };
}

class Category {
  int? id;
  String? name;
  String? image;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.image,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        isActive: json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "isActive": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Chapter {
  int? id;
  int? courseId;
  String? chapterName;
  String? chapterDescription;
  List<String>? chapterImages;
  String? youtubeLink;
  String? chapterDocument;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Chapter({
    this.id,
    this.courseId,
    this.chapterName,
    this.chapterDescription,
    this.chapterImages,
    this.youtubeLink,
    this.chapterDocument,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        courseId: json["course_id"],
        chapterName: json["chapter_name"],
        chapterDescription: json["chapter_description"],
        chapterImages: json["chapter_images"] == null
            ? []
            : List<String>.from(json["chapter_images"]!.map((x) => x)),
        youtubeLink: json["youtube_link"],
        chapterDocument: json["chapter_document"],
        isActive: json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "chapter_name": chapterName,
        "chapter_description": chapterDescription,
        "chapter_images": chapterImages == null
            ? []
            : List<dynamic>.from(chapterImages!.map((x) => x)),
        "youtube_link": youtubeLink,
        "chapter_document": chapterDocument,
        "isActive": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
