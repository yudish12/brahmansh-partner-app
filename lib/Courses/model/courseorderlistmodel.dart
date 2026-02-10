// To parse this JSON data, do
//
//     final courseOrderModel = courseOrderModelFromJson(jsonString);

class CourseOrderModel {
  int? id;
  int? astrologerId;
  int? courseId;
  dynamic coursePrice;
  dynamic courseGstAmount;
  dynamic courseTotalPrice;
  String? paymentType;
  String? courseOrderStatus;
  String? courseCompletionStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Course? course;
  List<CourseChapter>? courseChapters;

  CourseOrderModel({
    this.id,
    this.astrologerId,
    this.courseId,
    this.coursePrice,
    this.courseGstAmount,
    this.courseTotalPrice,
    this.paymentType,
    this.courseOrderStatus,
    this.courseCompletionStatus,
    this.createdAt,
    this.updatedAt,
    this.course,
    this.courseChapters,
  });

  factory CourseOrderModel.fromJson(Map<String, dynamic> json) =>
      CourseOrderModel(
        id: json["id"],
        astrologerId: json["astrologerId"],
        courseId: json["course_id"],
        coursePrice: json["course_price"],
        courseGstAmount: json["course_gst_amount"],
        courseTotalPrice: json["course_total_price"],
        paymentType: json["payment_type"],
        courseOrderStatus: json["course_order_status"],
        courseCompletionStatus: json["course_completion_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        courseChapters: json["course_chapters"] == null
            ? []
            : List<CourseChapter>.from(
                json["course_chapters"]!.map((x) => CourseChapter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologerId": astrologerId,
        "course_id": courseId,
        "course_price": coursePrice,
        "course_gst_amount": courseGstAmount,
        "course_total_price": courseTotalPrice,
        "payment_type": paymentType,
        "course_order_status": courseOrderStatus,
        "course_completion_status": courseCompletionStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "course": course?.toJson(),
        "course_chapters": courseChapters == null
            ? []
            : List<dynamic>.from(courseChapters!.map((x) => x.toJson())),
      };
}

class Course {
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

  Course({
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
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
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
      };
}

class CourseChapter {
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
  int? laravelThroughKey;

  CourseChapter({
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
    this.laravelThroughKey,
  });

  factory CourseChapter.fromJson(Map<String, dynamic> json) => CourseChapter(
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
        laravelThroughKey: json["laravel_through_key"],
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
        "laravel_through_key": laravelThroughKey,
      };
}
