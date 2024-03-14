import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/forgot_password_service_interface.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';

class ForgotPasswordController extends GetxController implements GetxService{
  final ForgotPasswordServiceInterface forgotPasswordServiceInterface;
  ForgotPasswordController({required this.forgotPasswordServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  Future<bool> changePassword(ProfileModel updatedUserModel, String password) async {
    _isLoading = true;
    update();
    bool isSuccess;
    ResponseModel responseModel = await forgotPasswordServiceInterface.changePassword(updatedUserModel, password);
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<ResponseModel> forgotPassword(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.forgotPassword(email);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String phone, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.resetPassword(resetToken, phone, password, confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? number) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await forgotPasswordServiceInterface.verifyToken(number, _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

}