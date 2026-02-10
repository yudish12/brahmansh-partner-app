

class CustomPujaModel {
    int? id;
    String? pujaTitle;
    String? pujaPlace;
    String? pujaPrice;
    String? longDescription;
    DateTime? pujaStartDatetime;
    DateTime? pujaEndDatetime;
    String? isAdminApproved;
    List<String>? pujaImages;
    String? pujaDuration;

    CustomPujaModel({
        this.id,
        this.pujaTitle,
        this.pujaPlace,
        this.pujaPrice,
        this.longDescription,
        this.pujaStartDatetime,
        this.pujaEndDatetime,
        this.isAdminApproved,
        this.pujaImages,
        this.pujaDuration,
    });

    factory CustomPujaModel.fromJson(Map<String, dynamic> json) => CustomPujaModel(
        id: json["id"],
        pujaTitle: json["puja_title"],
        pujaPlace: json["puja_place"],
        pujaPrice: json["puja_price"],
        longDescription: json["long_description"],
        pujaStartDatetime: json["puja_start_datetime"] == null ? null : DateTime.parse(json["puja_start_datetime"]),
        pujaEndDatetime: json["puja_end_datetime"] == null ? null : DateTime.parse(json["puja_end_datetime"]),
        isAdminApproved: json["isAdminApproved"],
        pujaImages: json["puja_images"] == null ? [] : List<String>.from(json["puja_images"]!.map((x) => x)),
        pujaDuration: json["puja_duration"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "puja_title": pujaTitle,
        "puja_place": pujaPlace,
        "puja_price": pujaPrice,
        "long_description": longDescription,
        "puja_start_datetime": pujaStartDatetime?.toIso8601String(),
        "puja_end_datetime": pujaEndDatetime?.toIso8601String(),
        "isAdminApproved": isAdminApproved,
        "puja_images": pujaImages == null ? [] : List<dynamic>.from(pujaImages!.map((x) => x)),
        "puja_duration": pujaDuration,
    };
}
