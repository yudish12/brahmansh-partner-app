const admin = require("firebase-admin");

// ---- CONFIGURE THESE ----
const SERVICE_ACCOUNT_PATH =
  "/Users/yudish/Downloads/brahmansh-a4c4e-firebase-adminsdk-fbsvc-8fa55eff83.json";
const FCM_TOKEN =
  "fPr95640SwWuPGW-R0fALb:APA91bHWE_XyhUEpts5R63guMatAj1eFQ5LZSxwwqpWRNgsuO8eq0Fru8dCukVBwmRw3WfdOCH1AWXzHaVKYkQo56PpHc_19h0hr_3BZ5B2orGZJrnp59xE";
// -------------------------

admin.initializeApp({
  credential: admin.credential.cert(require(SERVICE_ACCOUNT_PATH)),
});

const payload = {
  token: FCM_TOKEN,
  data: {
    title: "Chat Request",
    body: JSON.stringify({
      description: "New chat request received",
      notificationType: 8,
      chatId: 9999,
      userId: 1157,
      userName: "Test User",
      profile: "/build/assets/images/person.png",
      fcmToken: null,
      chat_duration: "120",
      subscription_id: "",
    }),
    click_action: "FLUTTER_NOTIFICATION_CLICK",
  },
  android: {
    priority: "high",
  },
};

admin
  .messaging()
  .send(payload)
  .then((response) => {
    console.log("✅ Sent successfully:", response);
    process.exit(0);
  })
  .catch((error) => {
    console.error("❌ Error:", error.message);
    process.exit(1);
  });
