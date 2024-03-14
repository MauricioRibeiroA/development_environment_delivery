import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface {
  Future<dynamic> login(String phone, String password);
  Future<dynamic> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument);
  Future<bool> saveUserToken(String token, String topic);
  Future<dynamic> updateToken({String notificationDeviceToken = ''});
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode);
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
}
