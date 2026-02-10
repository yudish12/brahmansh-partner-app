// To parse this JSON data, do
//
//     final courseModel = courseModelFromJson(jsonString);

class CourseModel {
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
  String? categoryName;
  Category? category;

  CourseModel({
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
    this.categoryName,
    this.category,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
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
        categoryName: json["category_name"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
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
        "category_name": categoryName,
        "category": category?.toJson(),
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
