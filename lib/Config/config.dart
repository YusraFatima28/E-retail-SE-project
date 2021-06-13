import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp
{
   static const String appName = 'E-Retail';
   static SharedPreferences sharedPreferences;
   static FirebaseUser user;
   static FirebaseUser admin;
   static FirebaseAuth auth;
   static Firestore firestore ;
   static String collectionUser = "users";
   static String collectionAdmin = "admins";
   static String collectionOrders = "orders";
   static String userCartList = 'userCart';
   static String userWishList = 'wishList' ;
   static String subCollectionAddress = 'userAddress';
   static final String userName = 'name';
   static final String userEmail = 'email';
   static final String userPassword = 'password';
   static final String userPhotoUrl = 'photoUrl';
   static final String userPhoneNumber ='PhoneNumber';
   static final String userUID = 'uid';
   static final String userAvatarUrl = 'url';
   static final String adminName = 'admin_name';
   static final String adminAddress = 'admin_address';
   static final String adminEmail = 'admin_email';
   static final String adminPassword = 'admin_password';
   static final String adminPhotoUrl = 'admin_photoUrl';
   static final String adminPhoneNumber = 'admin_PhoneNumber';
   static final String adminUID = 'admin_id';
   static final String adminAvatarUrl = 'admin_url';
   static final String addressID = 'addressID';
   static final String totalAmount = 'totalAmount';
   static final String productID = 'productIDs';
   static final String paymentDetails ='paymentDetails';
   static final String orderTime ='orderTime';
   static final String isSuccess ='isSuccess';

}