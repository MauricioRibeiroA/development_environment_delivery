import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/shift_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/services/profile_service_interface.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/record_location_body.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface}){
    _notification = profileServiceInterface.isNotificationActive();
  }

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  bool _notification = true;
  bool get notification => _notification;

  Timer? _timer;

  RecordLocationBody? _recordLocation;
  RecordLocationBody? get recordLocationBody => _recordLocation;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  bool _shiftLoading = false;
  bool get shiftLoading => _shiftLoading;

  List<ShiftModel>? _shifts;
  List<ShiftModel>? get shifts => _shifts;

  int? _shiftId;
  int? get shiftId => _shiftId;

  Future<void> getProfile() async {
    ProfileModel? profileModel = await profileServiceInterface.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
      if (_profileModel!.active == 1) {
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
            || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          Get.dialog(ConfirmationDialogWidget(
            icon: Images.locationPermission, iconSize: 200, hasCancel: false,
            description: 'this_app_collects_location_data'.tr,
            onYesPressed: () {
              Get.back();
              profileServiceInterface.checkPermission(() => startLocationRecord());
            },
          ), barrierDismissible: false);
        }else {
          startLocationRecord();
        }
      } else {
        stopLocationRecord();
      }
    }
    update();
  }

  Future<bool> updateUserInfo(ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    bool isSuccess;
    if (responseModel.isSuccess) {
      _profileModel = updateUserModel;
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> updateActiveStatus({int? shiftId, bool isUpdate = false}) async {
    _shiftLoading = true;
    if(isUpdate){
      update();
    }
    ResponseModel responseModel = await profileServiceInterface.updateActiveStatus(shiftId: shiftId);
    bool isSuccess;
    if (responseModel.isSuccess) {
      _profileModel!.active = _profileModel!.active == 0 ? 1 : 0;
      showCustomSnackBar(responseModel.message, isError: false);
      isSuccess = true;
      if (_profileModel!.active == 1) {
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
            || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          Get.dialog(ConfirmationDialogWidget(
            icon: Images.locationPermission, iconSize: 200, hasCancel: false,
            description: 'this_app_collects_location_data'.tr,
            onYesPressed: () {
              Get.back();
              profileServiceInterface.checkPermission(() => startLocationRecord());
            },
          ), barrierDismissible: false);
        }else {
          startLocationRecord();
        }
      } else {
        stopLocationRecord();
      }
    } else {
      isSuccess = false;
    }
    _shiftLoading = false;
    update();
    return isSuccess;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    profileServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }

  Future<void> removeDriver() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.deleteDriver();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      stopLocationRecord();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  Future<void> getShiftList() async {
    _shifts = null;
    _isLoading = true;
    List<ShiftModel>? shifts = await profileServiceInterface.getShiftList();
    if (shifts != null) {
      _shifts = [];
      _shifts!.addAll(shifts);
    }
    _isLoading = false;
    update();
  }

  void setShiftId(int? id){
    _shiftId = id;
    update();
  }

  void initData() {
    _pickedFile = null;
    _shiftId = null;
  }

  void startLocationRecord() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      recordLocation();
    });
  }

  void stopLocationRecord() {
    _timer?.cancel();
  }

  Future<void> recordLocation() async {
    final Position locationResult = await Geolocator.getCurrentPosition();
    String address = await profileServiceInterface.addressPlaceMark(locationResult);

    _recordLocation = RecordLocationBody(
      location: address, latitude: locationResult.latitude, longitude: locationResult.longitude,
    );

    bool isSuccess  = await profileServiceInterface.recordLocation(_recordLocation!);
    if(isSuccess) {
      debugPrint('----Added record Lat: ${_recordLocation!.latitude} Lng: ${_recordLocation!.longitude} Loc: ${_recordLocation!.location}');
    }else {
      debugPrint('----Failed record');
    }
  }

}