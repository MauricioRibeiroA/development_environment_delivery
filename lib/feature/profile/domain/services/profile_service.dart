import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/record_location_body.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/shift_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/services/profile_service_interface.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_alert_dialog_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo_coding;

class ProfileService implements ProfileServiceInterface {
  final ProfileRepositoryInterface profileRepositoryInterface;
  ProfileService({required this.profileRepositoryInterface});

  @override
  Future<ProfileModel?> getProfileInfo() async {
    return await profileRepositoryInterface.getProfileInfo();
  }

  @override
  Future<bool> recordLocation(RecordLocationBody recordLocationBody) async {
    return await profileRepositoryInterface.recordLocation(recordLocationBody);
  }

  @override
  Future<ResponseModel?> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    return await profileRepositoryInterface.updateProfile(userInfoModel, data, token);
  }

  @override
  Future<ResponseModel?> updateActiveStatus({int? shiftId}) async {
    return await profileRepositoryInterface.updateActiveStatus(shiftId: shiftId);
  }

  @override
  bool isNotificationActive() {
    return profileRepositoryInterface.isNotificationActive();
  }

  @override
  void setNotificationActive(bool isActive) {
    profileRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  Future<ResponseModel> deleteDriver() async {
    return await profileRepositoryInterface.deleteDriver();
  }

  @override
  Future<List<ShiftModel>?> getShiftList() async {
    return await profileRepositoryInterface.getShiftList();
  }

  @override
  Future<String> addressPlaceMark(Position locationResult) async {
    String address;
    try{
      List<geo_coding.Placemark> addresses = await geo_coding.placemarkFromCoordinates(locationResult.latitude, locationResult.longitude);
      geo_coding.Placemark placeMark = addresses.first;
      address = '${placeMark.name}, ${placeMark.subAdministrativeArea}, ${placeMark.isoCountryCode}';
    }catch(e) {
      address = 'Unknown Location Found';
    }
    return address;
  }

  @override
  void checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialogWidget(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialogWidget(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }

}