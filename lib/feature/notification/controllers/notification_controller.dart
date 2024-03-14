import 'package:stackfood_multivendor_driver/feature/notification/domain/services/notification_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor_driver/helper/date_converter_helper.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationServiceInterface notificationServiceInterface;
  NotificationController({required this.notificationServiceInterface});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  bool _hideNotificationButton = false;
  bool get hideNotificationButton => _hideNotificationButton;

  Future<void> getNotificationList() async {
    List<NotificationModel>? notificationList = await notificationServiceInterface.getNotificationList();
    if (notificationList != null) {
      _notificationList = [];
      _notificationList!.addAll(notificationList);
      _notificationList!.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updatedAt!).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
      });
      Iterable iterable = _notificationList!.reversed;
      _notificationList = iterable.toList() as List<NotificationModel>?;
    }
    update();
  }

  Future<bool> sendDeliveredNotification(int? orderID) async {
    _hideNotificationButton = true;
    update();
    bool success = await notificationServiceInterface.sendDeliveredNotification(orderID);
    bool isSuccess;
    success ? isSuccess = true : isSuccess = false;
    _hideNotificationButton = false;
    update();
    return isSuccess;
  }

  void saveSeenNotificationCount(int count) {
    notificationServiceInterface.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationServiceInterface.getSeenNotificationCount();
  }

}