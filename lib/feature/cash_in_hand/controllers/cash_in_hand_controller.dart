import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/models/wallet_payment_model.dart';
import 'package:stackfood_multivendor_driver/feature/cash_in_hand/domain/services/cash_in_hand_service_interface.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';

class CashInHandController extends GetxController implements GetxService {
  final CashInHandServiceInterface cashInHandServiceInterface;
  CashInHandController({required this.cashInHandServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Transactions>? _transactions;
  List<Transactions>? get transactions => _transactions;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await cashInHandServiceInterface.makeCollectCashPayment(amount, paymentGatewayName);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> makeWalletAdjustment() async {
    _isLoading = true;
    update();
    bool isSuccess = await cashInHandServiceInterface.makeWalletAdjustment();
    if(isSuccess) {
      Get.find<ProfileController>().getProfile();
      Get.back();
      showCustomSnackBar('wallet_adjustment_successfully'.tr, isError: false);
    }else {
      Get.back();
    }
    _isLoading = false;
    update();
  }

  Future<void> getWalletPaymentList() async {
    _transactions = null;
    List<Transactions>? transactions = await cashInHandServiceInterface.getWalletPaymentList();
    if(transactions != null) {
      _transactions = [];
      _transactions!.addAll(transactions);
    }
    update();
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void changeDigitalPaymentName(String? name, {bool canUpdate = true}){
    _digitalPaymentName = name;
    if(canUpdate) {
      update();
    }
  }

}