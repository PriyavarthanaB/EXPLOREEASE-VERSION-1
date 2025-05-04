const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendBookingNotification = functions.firestore
  .document("booking_requests/{requestId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const guideId = data.guideId;

    // Get guide's FCM token
    const guideDoc = await admin.firestore().collection("guides").doc(guideId).get();
    const fcmToken = guideDoc.data().fcmToken;

    const message = {
      notification: {
        title: "New Booking Request!",
        body: `Tourist ${data.touristName} wants to book you.`,
      },
      token: fcmToken,
    };

    await admin.messaging().send(message);
  });
