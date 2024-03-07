import 'package:stackfood_multivendor_driver/feature/disbursements/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/withdraw_method_model.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_report_model.dart' as report;
import 'package:stackfood_multivendor_driver/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementController extends GetxController implements GetxService {
  final DisbursementServiceInterface disbursementServiceInterface;
  DisbursementController({required this.disbursementServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDeleteLoading = false;
  bool get isDeleteLoading => _isDeleteLoading;

  int? _selectedMethodIndex = 0;
  int? get selectedMethodIndex => _selectedMethodIndex;

  List<DropdownItem<int>> _methodList = [];
  List<DropdownItem<int>> get methodList => _methodList;

  List<TextEditingController> _textControllerList = [];
  List<TextEditingController> get textControllerList => _textControllerList;

  List<MethodFields> _methodFields = [];
  List<MethodFields> get methodFields => _methodFields;

  List<FocusNode> _focusList = [];
  List<FocusNode> get focusList => _focusList;

  List<WidthDrawMethodModel>? _widthDrawMethods;
  List<WidthDrawMethodModel>? get widthDrawMethods => _widthDrawMethods;

  disburse.DisbursementMethodBody? _disbursementMethodBody;
  disburse.DisbursementMethodBody? get disbursementMethodBody => _disbursementMethodBody;

  report.DisbursementReportModel? _disbursementReportModel;
  report.DisbursementReportModel? get disbursementReportModel => _disbursementReportModel;

  int? _index = -1;
  int? get index =>_index;


  void setMethodId(int? id, {bool canUpdate = true}) {
    _selectedMethodIndex = id;
    if(canUpdate){
      update();
    }
  }

  Future<void> setMethod({bool isUpdate = true}) async {
    if(_widthDrawMethods == null) {
      _widthDrawMethods = await getWithdrawMethodList();
    } else {
      _widthDrawMethods = widthDrawMethods;
    }
    _methodList = disbursementServiceInterface.processMethodList(_widthDrawMethods);
    _methodFields = disbursementServiceInterface.generateMethodFields(_widthDrawMethods, _selectedMethodIndex);
    _textControllerList = disbursementServiceInterface.generateTextControllerList(_widthDrawMethods, _selectedMethodIndex);
    _focusList = disbursementServiceInterface.generateFocusList(_widthDrawMethods, _selectedMethodIndex);

    if(isUpdate) {
      update();
    }
  }

  Future<void> addWithdrawMethod(Map<String?, String> data) async {
    _isLoading = true;
    update();
    bool isSuccess = await disbursementServiceInterface.addWithdraw(data);
    if(isSuccess) {
      Get.back();
      getDisbursementMethodList();
      showCustomSnackBar('add_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<bool> getDisbursementMethodList() async {
    bool success = false;
    disburse.DisbursementMethodBody? disbursementMethodBody = await disbursementServiceInterface.getDisbursementMethodList();
    if(disbursementMethodBody != null) {
      success = true;
      _disbursementMethodBody = disbursementMethodBody;
    }
    update();
    return success;
  }

  Future<void> makeDefaultMethod(Map<String, String> data, int index) async {
    _index = index;
    _isLoading = true;
    update();
    bool isSuccess = await disbursementServiceInterface.makeDefaultMethod(data);
    if(isSuccess) {
      _index = -1;
      getDisbursementMethodList();
      showCustomSnackBar('set_default_method_successful'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteMethod(int id) async {
    _isDeleteLoading = true;
    update();
    bool isSuccess = await disbursementServiceInterface.deleteMethod(id);
    if(isSuccess) {
      getDisbursementMethodList();
      Get.back();
      showCustomSnackBar('method_delete_successfully'.tr, isError: false);
    }
    _isDeleteLoading = false;
    update();
  }

  Future<void> getDisbursementReport(int offset) async {
    report.DisbursementReportModel? disbursementReportModel = await disbursementServiceInterface.getDisbursementReport(offset);
    if(disbursementReportModel != null) {
      _disbursementReportModel = disbursementReportModel;
    }
    update();
  }

  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    List<WidthDrawMethodModel>? widthDrawMethodList = await disbursementServiceInterface.getWithdrawMethodList();
    if(widthDrawMethodList != null) {
      _widthDrawMethods = [];
      _widthDrawMethods!.addAll(widthDrawMethodList);
    }
    update();
    return _widthDrawMethods;
  }
  
}