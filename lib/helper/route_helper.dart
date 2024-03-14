import 'dart:convert';
import 'package:stackfood_multivendor_driver/feature/Incentive/screens/incentive_screen.dart';
import 'package:stackfood_multivendor_driver/feature/auth/screens/delivery_man_registration_screen.dart';
import 'package:stackfood_multivendor_driver/feature/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/screens/cash_in_hand_screen.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/screens/transaction_history_screen.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/screens/payment_screen.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/screens/payment_successful_screen.dart';
import 'package:stackfood_multivendor_driver/feature/chat/screens/chat_screen.dart';
import 'package:stackfood_multivendor_driver/feature/chat/screens/conversation_screen.dart';
import 'package:stackfood_multivendor_driver/feature/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/screens/add_withdraw_method_screen.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/screens/disbursement_screen.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/screens/withdraw_method_screen.dart';
import 'package:stackfood_multivendor_driver/feature/auth/screens/forgot_password_screen.dart';
import 'package:stackfood_multivendor_driver/feature/auth/screens/new_password_screen.dart';
import 'package:stackfood_multivendor_driver/feature/auth/screens/verification_screen.dart';
import 'package:stackfood_multivendor_driver/feature/html/screens/html_viewer_screen.dart';
import 'package:stackfood_multivendor_driver/feature/language/screens/language_screen.dart';
import 'package:stackfood_multivendor_driver/feature/notification/screens/notification_screen.dart';
import 'package:stackfood_multivendor_driver/feature/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor_driver/feature/order/screens/running_order_screen.dart';
import 'package:stackfood_multivendor_driver/feature/profile/screens/update_profile_screen.dart';
import 'package:stackfood_multivendor_driver/feature/splash/screens/splash_screen.dart';
import 'package:stackfood_multivendor_driver/feature/update/screens/update_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';
  static const String runningOrder = '/running-order';
  static const String terms = '/terms-and-condition';
  static const String privacy = '/privacy-policy';
  static const String language = '/language';
  static const String update = '/update';
  static const String chatScreen = '/chat-screen';
  static const String conversationListScreen = '/conversation-list-screen';
  static const String deliveryManRegistration = '/delivery-man-registration';
  static const String incentive = '/incentive';
  static const String cashInHand = '/cash-in-hand';
  static const String disbursement = '/disbursement';
  static const String withdrawMethod = '/withdraw-method';
  static const String addWithdrawMethod = '/add-withdraw-method';
  static const String success = '/success';
  static const String payment = '/payment';
  static const String transactionHistory = '/transaction-history';


  static String getInitialRoute() => initial;
  static String getSplashRoute(NotificationBodyModel? body) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }
  static String getSignInRoute() => signIn;
  static String getVerificationRoute(String number) => '$verification?number=$number';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => forgotPassword;
  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int? id) => '$orderDetails?id=$id';
  static String getUpdateProfileRoute() => updateProfile;
  static String getNotificationRoute({bool fromNotification = false}) => '$notification?from_notification=${fromNotification.toString()}';
  static String getRunningOrderRoute() => runningOrder;
  static String getTermsRoute() => terms;
  static String getPrivacyRoute() => privacy;
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';
  static String getChatRoute({required NotificationBodyModel? notificationBody, User? user, int? conversationId}) {

    String notificationBody0 = 'null';
    String user0 = 'null';

    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody)));
    }
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$chatScreen?notification_body=$notificationBody0&user=$user0&conversation_id=$conversationId';
  }
  static String getConversationListRoute() => conversationListScreen;
  static String getDeliverymanRegistrationRoute() => deliveryManRegistration;
  static String getIncentiveRoute() => incentive;
  static String getCashInHandRoute() => cashInHand;
  static String getDisbursementRoute() => disbursement;
  static String getWithdrawMethodRoute({bool isFromDashBoard = false}) => '$withdrawMethod?is_from_dashboard=${isFromDashBoard.toString()}';
  static String getAddWithdrawMethodRoute() => addWithdrawMethod;
  static String getSuccessRoute(String status) => '$success?status=$status';
  static String getPaymentRoute(String? redirectUrl) {
    return '$payment?redirect-url=$redirectUrl';
  }
  static String getTransactionHistoryRoute() => transactionHistory;


  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () {
      NotificationBodyModel? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data);
    }),
    GetPage(name: signIn, page: () => SignInViewScreen()),
    GetPage(name: verification, page: () => VerificationScreen(number: Get.parameters['number'])),
    GetPage(name: main, page: () => DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'order-request' ? 1
          : Get.parameters['page'] == 'order' ? 2 : Get.parameters['page'] == 'profile' ? 3 : 0,
    )),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => NewPasswordScreen(
      resetToken: Get.parameters['token'], number: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: orderDetails, page: () {
      OrderDetailsScreen? orderDetails = Get.arguments;
      return orderDetails ?? OrderDetailsScreen(
        orderId: int.parse(Get.parameters['id']!), orderIndex: null, isRunningOrder: null,
      );
    }),
    GetPage(name: updateProfile, page: () => const UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen(fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: runningOrder, page: () => const RunningOrderScreen()),
    GetPage(name: terms, page: () => const HtmlViewerScreen(isPrivacyPolicy: false)),
    GetPage(name: privacy, page: () => const HtmlViewerScreen(isPrivacyPolicy: true)),
    GetPage(name: language, page: () => ChooseLanguageScreen(fromProfile: Get.parameters['page'] == 'profile')),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: chatScreen, page: () {

      NotificationBodyModel? notificationBody;
      if(Get.parameters['notification_body'] != 'null') {
        notificationBody = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification_body']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return ChatScreen(
        notificationBody : notificationBody, user: user,
        conversationId: Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null' ? int.parse(Get.parameters['conversation_id']!) : null,
      );
    }),
    GetPage(name: conversationListScreen, page: () => const ConversationScreen()),
    GetPage(name: deliveryManRegistration, page: () => const DeliveryManRegistrationScreen()),
    GetPage(name: incentive, page: () => const IncentiveScreen()),
    GetPage(name: cashInHand, page: () => const CashInHandScreen()),
    GetPage(name: disbursement, page: () => const DisbursementScreen()),
    GetPage(name: withdrawMethod, page: () => WithdrawMethodScreen(isFromDashboard: Get.parameters['is_from_dashboard'] == 'true')),
    GetPage(name: addWithdrawMethod, page: () => const AddWithDrawMethodScreen()),
    GetPage(name: success, page: () => PaymentSuccessfulScreen(success: Get.parameters['status'] == 'success')),
    GetPage(name: payment, page: () {
      String walletPayment = Get.parameters['redirect-url']!;
      return PaymentScreen(redirectUrl: walletPayment);
    }),
    GetPage(name: transactionHistory, page: () => const TransactionHistoryScreen()),

  ];
}