import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/withdraw_method_model.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_report_model.dart' as report;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisbursementRepository implements DisbursementRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  DisbursementRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<bool> addWithdraw(Map<String?, String> data) async {
    Response response = await apiClient.postData('${AppConstants.addWithdrawMethodUri}?token=${_getUserToken()}', data);
    return (response.statusCode == 200);
  }

  @override
  Future<disburse.DisbursementMethodBody?> getList() async{
    disburse.DisbursementMethodBody? disbursementMethodBody;
    Response response = await apiClient.getData('${AppConstants.disbursementMethodListUri}?limit=10&offset=1&token=${_getUserToken()}');
    if(response.statusCode == 200) {
      disbursementMethodBody = disburse.DisbursementMethodBody.fromJson(response.body);
    }
    return disbursementMethodBody;
  }

  @override
  Future<bool> makeDefaultMethod(Map<String?, String> data) async {
    Response response = await apiClient.postData('${AppConstants.makeDefaultDisbursementMethodUri}?token=${_getUserToken()}', data);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete(int id) async{
    Response response = await apiClient.postData('${AppConstants.deleteDisbursementMethodUri}?token=${_getUserToken()}', {'_method': 'delete', 'id': id});
    return (response.statusCode == 200);
  }

  @override
  Future<report.DisbursementReportModel?> getDisbursementReport(int offset) async {
    report.DisbursementReportModel? disbursementReportModel;
    Response response = await apiClient.getData('${AppConstants.getDisbursementReportUri}?limit=10&offset=$offset&token=${_getUserToken()}');
    if(response.statusCode == 200) {
      disbursementReportModel = report.DisbursementReportModel.fromJson(response.body);
    }
    return disbursementReportModel;
  }

  @override
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    List<WidthDrawMethodModel>? widthDrawMethodList;
    Response response = await apiClient.getData('${AppConstants.withdrawRequestMethodUri}?token=${_getUserToken()}');
    if(response.statusCode == 200) {
      widthDrawMethodList = [];
      response.body.forEach((method) {
        WidthDrawMethodModel withdrawMethod = WidthDrawMethodModel.fromJson(method);
        widthDrawMethodList!.add(withdrawMethod);
      });
    }
    return widthDrawMethodList;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}