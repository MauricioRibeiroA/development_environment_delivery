import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';

abstract class DisbursementRepositoryInterface implements RepositoryInterface {
  Future<dynamic> addWithdraw(Map<String?, String> data);
  Future<dynamic> makeDefaultMethod(Map<String?, String> data);
  Future<dynamic> getDisbursementReport(int offset);
  Future<dynamic> getWithdrawMethodList();
}