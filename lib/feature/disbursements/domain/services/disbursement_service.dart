import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/withdraw_method_model.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_driver/feature/disbursements/domain/models/disbursement_report_model.dart' as report;

class DisbursementService implements DisbursementServiceInterface {
  final DisbursementRepositoryInterface disbursementRepositoryInterface;
  DisbursementService({required this.disbursementRepositoryInterface});

  @override
  Future<bool> addWithdraw(Map<String?, String> data) async {
    return await disbursementRepositoryInterface.addWithdraw(data);
  }

  @override
  Future<disburse.DisbursementMethodBody?> getDisbursementMethodList() async{
    return await disbursementRepositoryInterface.getList();
  }

  @override
  Future<bool> makeDefaultMethod(Map<String?, String> data) async {
    return await disbursementRepositoryInterface.makeDefaultMethod(data);
  }

  @override
  Future<bool> deleteMethod(int id) async{
    return await disbursementRepositoryInterface.delete(id);
  }

  @override
  Future<report.DisbursementReportModel?> getDisbursementReport(int offset) async {
    return await disbursementRepositoryInterface.getDisbursementReport(offset);
  }

  @override
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    return await disbursementRepositoryInterface.getWithdrawMethodList();
  }

  @override
  List<DropdownItem<int>> processMethodList(List<WidthDrawMethodModel>? widthDrawMethods) {
    List<DropdownItem<int>> methodList = [];
    if(widthDrawMethods != null && widthDrawMethods.isNotEmpty) {
      for (int i = 0; i < widthDrawMethods.length; i++) {
        methodList.add(DropdownItem<int>(value: i, child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widthDrawMethods[i].methodName}'),
          ),
        )));
      }
    }
    return methodList;
  }

  @override
  List<MethodFields> generateMethodFields(List<WidthDrawMethodModel>? widthDrawMethods, int? selectedMethodIndex) {
    List<MethodFields> methodFields = [];
    if(widthDrawMethods != null && widthDrawMethods.isNotEmpty) {
      for (var field in widthDrawMethods[selectedMethodIndex!].methodFields!) {
        methodFields.add(field);
      }
    }
    return methodFields;
  }

  @override
  List<TextEditingController> generateTextControllerList(List<WidthDrawMethodModel>? widthDrawMethods, int? selectedMethodIndex) {
    List<TextEditingController> textControllerList = [];
    if(widthDrawMethods != null && widthDrawMethods.isNotEmpty) {
      for (int i = 0; i < widthDrawMethods[selectedMethodIndex!].methodFields!.length; i++) {
        textControllerList.add(TextEditingController());
      }
    }
    return textControllerList;
  }

  @override
  List<FocusNode> generateFocusList(List<WidthDrawMethodModel>? widthDrawMethods, int? selectedMethodIndex) {
    List<FocusNode> focusList = [];
    if(widthDrawMethods != null && widthDrawMethods.isNotEmpty) {
      for (int i = 0; i < widthDrawMethods[selectedMethodIndex!].methodFields!.length; i++) {
        focusList.add(FocusNode());
      }
    }
    return focusList;
  }

}