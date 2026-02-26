class DeviceInfoLoginModel {
  DeviceInfoLoginModel({
    this.appId,
    this.appVersion,
    this.deviceId,
    this.deviceLocation,
    this.deviceManufacturer,
    this.deviceModel,
    this.fcmToken,
    this.onesignalSubscriptionID,
  });

  String? appId;
  String? deviceId;
  String? fcmToken;
  String? deviceLocation;
  String? deviceManufacturer;
  String? deviceModel;
  String? appVersion;
  String? onesignalSubscriptionID;

  factory DeviceInfoLoginModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoLoginModel(
      appId: json['appId']?.toString(),
      deviceId: json['deviceId']?.toString(),
      fcmToken: json['fcmToken']?.toString(),
      deviceLocation: json['deviceLocation']?.toString(),
      deviceManufacturer: json['deviceManufacturer']?.toString(),
      deviceModel: json['deviceModel']?.toString(),
      appVersion: json['appVersion']?.toString(),
      onesignalSubscriptionID: json['subscription_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "appId": appId ?? "2",
      "deviceId": deviceId,
      "fcmToken": fcmToken,
      "deviceLocation": deviceLocation ?? "",
      "deviceManufacturer": deviceManufacturer,
      "deviceModel": deviceModel,
      "appVersion": appVersion,
      "subscription_id": onesignalSubscriptionID,
    };
  }
}
