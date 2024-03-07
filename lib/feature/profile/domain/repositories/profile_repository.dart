import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/record_location_body.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/shift_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ProfileRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ProfileModel?> getProfileInfo() async {
    ProfileModel? profileModel;
    Response response = await apiClient.getData(AppConstants.profileUri + _getUserToken());
    if (response.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response.body);
    }
    return profileModel;
  }

  @override
  Future<bool> recordLocation(RecordLocationBody recordLocationBody) async {
    recordLocationBody.token = _getUserToken();
    Response response = await apiClient.postData(AppConstants.recordLocationUri, recordLocationBody.toJson());
    return (response.statusCode == 200);
  }

  @override
  Future<ResponseModel?> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!,
      'email': userInfoModel.email!, 'token': _getUserToken()
    });
    ResponseModel? responseModel;
    Response response = await apiClient.postMultipartData(AppConstants.updateProfileUri, fields, [MultipartBody('image', data)] , []);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel?> updateActiveStatus({int? shiftId}) async {
    Map<String, String> body = {};
    body['token'] = _getUserToken();
    if(shiftId != null){
      body['shift_id'] = shiftId.toString();
    }
    ResponseModel? responseModel;
    Response response = await apiClient.postData(AppConstants.activeStatusUri, body);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  @override
  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  @override
  void setNotificationActive(bool isActive) {
    if(isActive) {
      _updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        _updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  @override
  Future<ResponseModel> deleteDriver() async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.driverRemove + _getUserToken(), {"_method": "delete"}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<List<ShiftModel>?> getShiftList() async {
    List<ShiftModel>? shifts;
    Response response = await apiClient.getData('${AppConstants.shiftUri}${_getUserToken()}');
    if (response.statusCode == 200) {
      shifts = [];
      response.body.forEach((shift) => shifts!.add(ShiftModel.fromJson(shift)));
    }
    return shifts;
  }

  Future<Response> _updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if(notificationDeviceToken.isEmpty){
      if (GetPlatform.isIOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      }else {
        deviceToken = await _saveDeviceToken();
      }
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);

      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": _getUserToken(), "fcm_token": notificationDeviceToken.isNotEmpty ? notificationDeviceToken : deviceToken}, handleError: false);
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if(!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    return deviceToken;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}