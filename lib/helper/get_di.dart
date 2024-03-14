import 'dart:convert';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/address_controller.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/address_repository.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/address_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/auth_repository.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/forgot_password_repository.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/forgot_password_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/address_service.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/address_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/auth_service.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/auth_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/forgot_password_service.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/forgot_password_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/controllers/cash_in_hand_controller.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/repositories/cash_in_hand_repository.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/repositories/cash_in_hand_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/services/cash_in_hand_service.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/services/cash_in_hand_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/repositories/disbursement_repository.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/services/disbursement_service.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/repositories/language_repository.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/repositories/language_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/services/language_service.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/services/language_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/repositories/notification_repository.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/repositories/notification_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/services/notification_service.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/services/notification_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/repositories/order_repository.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/services/order_service.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/repositories/chat_repository.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/services/chat_service.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/repositories/profile_repository.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/services/profile_service.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/services/profile_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/splash/domain/repositories/splash_repository.dart';
import 'package:stackfood_multivendor_driver/feature/splash/domain/repositories/splash_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/splash/domain/services/splash_service.dart';
import 'package:stackfood_multivendor_driver/feature/splash/domain/services/splash_service_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/models/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  ///Repository Interface
  AuthRepositoryInterface authRepositoryInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepositoryInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);

  ChatRepositoryInterface chatRepositoryInterface = ChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => chatRepositoryInterface);

  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => splashRepositoryInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);

  DisbursementRepositoryInterface disbursementRepositoryInterface = DisbursementRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => disbursementRepositoryInterface);

  LanguageRepositoryInterface languageRepositoryInterface = LanguageRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => languageRepositoryInterface);

  OrderRepositoryInterface orderRepositoryInterface = OrderRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => orderRepositoryInterface);

  ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface = ForgotPasswordRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => forgotPasswordRepositoryInterface);

  CashInHandRepositoryInterface cashInHandRepositoryInterface = CashInHandRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => cashInHandRepositoryInterface);

  AddressRepositoryInterface addressRepositoryInterface = AddressRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => addressRepositoryInterface);

  ///Service Interface
  AuthServiceInterface authServiceInterface = AuthService(authRepositoryInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  ChatServiceInterface chatServiceInterface = ChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => chatServiceInterface);

  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: Get.find());
  Get.lazyPut(() => splashServiceInterface);

  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  DisbursementServiceInterface disbursementServiceInterface = DisbursementService(disbursementRepositoryInterface: Get.find());
  Get.lazyPut(() => disbursementServiceInterface);

  LanguageServiceInterface languageServiceInterface = LanguageService(languageRepositoryInterface: Get.find());
  Get.lazyPut(() => languageServiceInterface);

  OrderServiceInterface orderServiceInterface = OrderService(orderRepositoryInterface: Get.find());
  Get.lazyPut(() => orderServiceInterface);

  ForgotPasswordServiceInterface forgotPasswordServiceInterface = ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find());
  Get.lazyPut(() => forgotPasswordServiceInterface);

  CashInHandServiceInterface cashInHandServiceInterface = CashInHandService(cashInHandRepositoryInterface: Get.find());
  Get.lazyPut(() => cashInHandServiceInterface);

  AddressServiceInterface addressServiceInterface = AddressService(addressRepositoryInterface: Get.find());
  Get.lazyPut(() => addressServiceInterface);


  ///Services
  Get.lazyPut(() => AuthService(authRepositoryInterface: Get.find()));
  Get.lazyPut(() => ProfileService(profileRepositoryInterface: Get.find()));
  Get.lazyPut(() => ChatService(chatRepositoryInterface: Get.find()));
  Get.lazyPut(() => SplashService(splashRepositoryInterface: Get.find()));
  Get.lazyPut(() => NotificationService(notificationRepositoryInterface: Get.find()));
  Get.lazyPut(() => DisbursementService(disbursementRepositoryInterface: Get.find()));
  Get.lazyPut(() => LanguageService(languageRepositoryInterface: Get.find()));
  Get.lazyPut(() => OrderService(orderRepositoryInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find()));
  Get.lazyPut(() => CashInHandService(cashInHandRepositoryInterface: Get.find()));
  Get.lazyPut(() => AddressService(addressRepositoryInterface: Get.find()));


  ///Controller
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => ChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => SplashController(splashServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementServiceInterface: Get.find()));
  Get.lazyPut(() => LocalizationController(languageServiceInterface: Get.find()));
  Get.lazyPut(() => OrderController(orderServiceInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordController(forgotPasswordServiceInterface: Get.find()));
  Get.lazyPut(() => CashInHandController(cashInHandServiceInterface: Get.find()));
  Get.lazyPut(() => AddressController(addressServiceInterface: Get.find()));


  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}