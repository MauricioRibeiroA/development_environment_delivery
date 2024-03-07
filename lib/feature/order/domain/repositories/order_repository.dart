import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/update_status_body.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/ignore_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<OrderModel>?> getList() async {
    List<OrderModel>? allOrderList;
    Response response = await apiClient.getData(AppConstants.allOrdersUri + _getUserToken());
    if (response.statusCode == 200) {
      allOrderList = [];
      response.body.forEach((order) => allOrderList!.add(OrderModel.fromJson(order)));
    }
    return allOrderList;
  }

  @override
  Future<PaginatedOrderModel?> getCompletedOrderList(int offset) async {
    PaginatedOrderModel? paginatedOrderModel;
    Response response = await apiClient.getData('${AppConstants.allOrdersUri}?token=${_getUserToken()}&offset=$offset&limit=10');
    if (response.statusCode == 200) {
      paginatedOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return paginatedOrderModel;
  }

  @override
  Future<List<OrderModel>?> getCurrentOrders() async {
    List<OrderModel>? currentOrderList;
    Response response = await apiClient.getData(AppConstants.currentOrdersUri + _getUserToken());
    if (response.statusCode == 200) {
      currentOrderList = [];
      response.body.forEach((order) => currentOrderList!.add(OrderModel.fromJson(order)));
    }
    return currentOrderList;
  }

  @override
  Future<List<OrderModel>?> getLatestOrders() async {
    List<OrderModel>? latestOrderList;
    Response response = await apiClient.getData(AppConstants.latestOrdersUri + _getUserToken());
    if(response.statusCode == 200) {
      latestOrderList = [];
      response.body.forEach((order) => latestOrderList!.add(OrderModel.fromJson(order)));
    }
    return latestOrderList;
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusBody updateStatusBody, List<MultipartBody> proofAttachment) async {
    updateStatusBody.token = _getUserToken();
    ResponseModel responseModel;
    Response response = await apiClient.postMultipartData(AppConstants.updateOrderStatusUri, updateStatusBody.toJson(), proofAttachment , [], handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<List<OrderDetailsModel>?> getOrderDetails(int? orderID) async {
    List<OrderDetailsModel>? orderDetailsModel;
    Response response = await apiClient.getData('${AppConstants.orderDetailsUri}${_getUserToken()}&order_id=$orderID');
    if (response.statusCode == 200) {
      orderDetailsModel = [];
      response.body.forEach((orderDetails) => orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
    }
    return orderDetailsModel;
  }

  @override
  Future<ResponseModel> acceptOrder(int? orderID) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.acceptOrderUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  void setIgnoreList(List<IgnoreModel> ignoreList) {
    List<String> stringList = [];
    for (var ignore in ignoreList) {
      stringList.add(jsonEncode(ignore.toJson()));
    }
    sharedPreferences.setStringList(AppConstants.ignoreList, stringList);
  }

  @override
  List<IgnoreModel> getIgnoreList() {
    List<IgnoreModel> ignoreList = [];
    List<String> stringList = sharedPreferences.getStringList(AppConstants.ignoreList) ?? [];
    for (var ignore in stringList) {
      ignoreList.add(IgnoreModel.fromJson(jsonDecode(ignore)));
    }
    return ignoreList;
  }

  @override
  Future<OrderModel?> getOrderWithId(int? orderId) async {
    OrderModel? orderModel;
    Response response = await apiClient.getData('${AppConstants.currentOrderUri}${_getUserToken()}&order_id=$orderId');
    if (response.statusCode == 200) {
      orderModel = OrderModel.fromJson(response.body);
    }
    return orderModel;
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=deliveryman');
    if (response.statusCode == 200) {
      OrderCancellationBodyModel orderCancellationBody = OrderCancellationBodyModel.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
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
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }
  
}