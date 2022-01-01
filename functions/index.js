const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { firestore } = require("firebase-admin");

admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();

exports.notifyNewDonation = functions.firestore.document('Users/{userId}/ACCEPTEDPRODUCTS/{productId}').onCreate(async (snapshot) => {
    const donationData = snapshot.data();
    
    

    const querySnapshot = db.collection("Users").doc(donationData.donerUserId).collection("TOKENS").get();
    const token = (await querySnapshot).docs.map(snap => snap.id);
    
    const payload = {
        notification: {
            title: `You have new Notifiation`,
            body: `${donationData.acceptedUserName} Accepted your Donation.`,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
           },
           
       };
       
       console.log(donationData.donerUserId);
       console.log(token);
       
       
           return fcm.sendToDevice(token,payload);
           
       
    

});

exports.deleteExpiredProduct = functions.firestore
.document('PRODUCTS/{productId}')
.onWrite(async () => {
  const now = admin.firestore.Timestamp.fromDate(new Date());
  
  let oldItemsQuery = db.collection('PRODUCTS').where('disAppearTime', '>=', now);
  const snapshot = await oldItemsQuery.get();
    // create a map with all children that need to be removed
    let batch = firestore.batch();
    snapshot.forEach(child => {
        batch.delete(child.ref);
    });
    return batch.commit();
});