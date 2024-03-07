import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/repositories/notification_repository_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository implements NotificationRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<NotificationModel>?> getList() async {
    List<NotificationModel>? notificationList;
    Response response = await apiClient.getData('${AppConstants.notificationUri}${_getUserToken()}');
    if(response.statusCode == 200){
      notificationList = [];
      response.body.forEach((notify) {
        NotificationModel notification = NotificationModel.fromJson(notify);
        notification.title = notify['data']['title'];
        notification.description = notify['data']['description'];
        notification.image = notify['data']['image'];
        notificationList!.add(notification);
      });
    }
    return notificationList;
  }

  @override
  Future<bool> sendDeliveredNotification(int? orderID) async {
    Response response = await apiClient.postData(AppConstants.deliveredOrderNotificationUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID});
    return (response.statusCode == 200);
  }

  @override
  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  @override
  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount);
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