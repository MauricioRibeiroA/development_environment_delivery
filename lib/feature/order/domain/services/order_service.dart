import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/ignore_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/update_status_body.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/services/order_service_interface.dart';

class OrderService implements OrderServiceInterface {
  final OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future<List<OrderModel>?> getAllOrders() async {
    return await orderRepositoryInterface.getList();
  }

  @override
  Future<PaginatedOrderModel?> getCompletedOrderList(int offset) async {
    return await orderRepositoryInterface.getCompletedOrderList(offset);
  }

  @override
  Future<List<OrderModel>?> getCurrentOrders() async {
    return await orderRepositoryInterface.getCurrentOrders();
  }

  @override
  Future<List<OrderModel>?> getLatestOrders() async {
    return await orderRepositoryInterface.getLatestOrders();
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusBody updateStatusBody, List<MultipartBody> proofAttachment) async {
    return await orderRepositoryInterface.updateOrderStatus(updateStatusBody, proofAttachment);
  }

  @override
  Future<List<OrderDetailsModel>?> getOrderDetails(int? orderID) async {
    return await orderRepositoryInterface.getOrderDetails(orderID);
  }

  @override
  Future<ResponseModel> acceptOrder(int? orderID) async {
    return await orderRepositoryInterface.acceptOrder(orderID);
  }

  @override
  void setIgnoreList(List<IgnoreModel> ignoreList) {
    orderRepositoryInterface.setIgnoreList(ignoreList);
  }

  @override
  List<IgnoreModel> getIgnoreList() {
    return orderRepositoryInterface.getIgnoreList();
  }

  @override
  Future<OrderModel?> getOrderWithId(int? orderId) async {
    return await orderRepositoryInterface.getOrderWithId(orderId);
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    return await orderRepositoryInterface.getCancelReasons();
  }

  @override
  List<OrderModel> sortDeliveredOrderList(List<OrderModel> allOrderList) {
    List<OrderModel> deliveredOrderList = [];
    for (var order in allOrderList) {
      if(order.orderStatus == 'delivered'){
        deliveredOrderList.add(order);
      }
    }
    return deliveredOrderList;
  }

  @override
  List<OrderModel> processLatestOrders(List<OrderModel> latestOrderList, List<int?> ignoredIdList) {
    List<OrderModel> latestOrderList0 = [];
    for (var order in latestOrderList) {
      if(!ignoredIdList.contains(order.id)) {
        latestOrderList0.add(order);
      }
    }
    return latestOrderList0;
  }

  @override
  List<int?> prepareIgnoreIdList(List<IgnoreModel> ignoredRequests) {
    List<int?> ignoredIdList = [];
    for (var ignore in ignoredRequests) {
      ignoredIdList.add(ignore.id);
    }
    return ignoredIdList;
  }

  @override
  List<MultipartBody> prepareOrderProofImages(List<XFile> pickedPrescriptions) {
    List<MultipartBody> multiParts = [];
    for(XFile file in pickedPrescriptions) {
      multiParts.add(MultipartBody('order_proof[]', file));
    }
    return multiParts;
  }

}