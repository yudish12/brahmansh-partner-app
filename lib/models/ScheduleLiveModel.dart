

class ScheduleLive {
    dynamic id;
    dynamic astrologerName;
    dynamic profileImage;
    dynamic isActive;
    dynamic scheduleLiveDate;
    dynamic scheduleLiveTime;

    ScheduleLive({
        this.id,
        this.astrologerName,
        this.profileImage,
        this.isActive,
        this.scheduleLiveDate,
        this.scheduleLiveTime,
    });

    factory ScheduleLive.fromJson(Map<String, dynamic> json) => ScheduleLive(
        id: json["id"],
        astrologerName: json["astrologerName"],
        profileImage: json["profileImage"],
        isActive: json["isActive"],
        scheduleLiveDate: json["schedule_live_date"],
        scheduleLiveTime: json["schedule_live_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "astrologerName": astrologerName,
        "profileImage": profileImage,
        "isActive": isActive,
        "schedule_live_date": scheduleLiveDate,
        "schedule_live_time": scheduleLiveTime,
    };
}
