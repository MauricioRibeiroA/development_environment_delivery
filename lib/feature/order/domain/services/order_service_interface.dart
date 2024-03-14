import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/ignore_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/update_status_body.dart';

abstract class OrderServiceInterface{
  Future<dynamic> getAllOrders();
  Future<dynamic> getCompletedOrderList(int offset);
  Future<dynamic> getCurrentOrders();
  Future<dynamic> getLatestOrders();
  Future<dynamic> updateOrderStatus(UpdateStatusBody updateStatusBody, List<MultipartBody> proofAttachment);
  Future<dynamic> getOrderDetails(int? orderID);
  Future<dynamic> acceptOrder(int? orderID);
  void setIgnoreList(List<IgnoreModel> ignoreList);
  List<IgnoreModel> getIgnoreList();
  Future<dynamic> getOrderWithId(int? orderId);
  Future<dynamic> getCancelReasons();
  List<OrderModel> sortDeliveredOrderList(List<OrderModel> allOrderList);
  List<OrderModel> processLatestOrders(List<OrderModel> latestOrderList, List<int?> ignoredIdList);
  List<MultipartBody> prepareOrderProofImages(List<XFile> pickedPrescriptions);
  List<int?> prepareIgnoreIdList(List<IgnoreModel> ignoredRequests);
}