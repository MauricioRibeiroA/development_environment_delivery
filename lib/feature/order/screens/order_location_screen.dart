import 'dart:ui';
import 'dart:collection';
import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/feature/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_driver/feature/order/widgets/location_card_widget.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderLocationScreen extends StatefulWidget {
  final OrderModel orderModel;
  final OrderController orderController;
  final int index;
  final Function onTap;
  const OrderLocationScreen({super.key, required this.orderModel, required this.orderController, required this.index, required this.onTap});

  @override
  State<OrderLocationScreen> createState() => _OrderLocationScreenState();
}

class _OrderLocationScreenState extends State<OrderLocationScreen> {

  GoogleMapController? _controller;
  Set<Marker> _markers = HashSet<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'order_location'.tr),

      body: Stack(children: [

        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(
            double.parse(widget.orderModel.deliveryAddress?.latitude??'0'), double.parse(widget.orderModel.deliveryAddress?.longitude??'0'),
          ), zoom: 16),
          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
          zoomControlsEnabled: false,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _setMarker(widget.orderModel);
          },
        ),

        Positioned(
          bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
          child: LocationCardWidget(
            orderModel: widget.orderModel, orderController: widget.orderController,
            onTap: widget.onTap, index: widget.index,
          ),
        ),

      ]),
    );
  }

  void _setMarker(OrderModel orderModel) async {
    try {

      Uint8List restaurantImageData = await _convertAssetToUnit8List(Images.restaurantMarker, width: 100);
      Uint8List deliveryBoyImageData = await _convertAssetToUnit8List(Images.yourMarker, width: 100);
      Uint8List destinationImageData = await _convertAssetToUnit8List(Images.customerMarker, width: 100);

      /// Animate to coordinate
      LatLngBounds? bounds;
      if(_controller != null) {
        if ((Get.find<ProfileController>().recordLocationBody?.latitude ?? 0) < double.parse(orderModel.restaurantLat ?? '0')) {
          bounds = LatLngBounds(
            southwest: LatLng(Get.find<ProfileController>().recordLocationBody?.latitude ?? 0, Get.find<ProfileController>().recordLocationBody?.latitude ?? 0),
            northeast: LatLng(double.parse(orderModel.restaurantLat ?? '0'), double.parse(orderModel.restaurantLng ?? '0')),
          );
        }else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(orderModel.restaurantLat ?? '0'), double.parse(orderModel.restaurantLng ?? '0')),
            northeast: LatLng(Get.find<ProfileController>().recordLocationBody?.latitude ?? 0, Get.find<ProfileController>().recordLocationBody?.longitude ?? 0),
          );
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
      _zoomToFit(_controller, bounds, centerBounds, padding: 1.5);

      /// Marker
      _markers = HashSet<Marker>();
      orderModel.deliveryAddress != null ? _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(double.parse(orderModel.deliveryAddress?.latitude??'0'), double.parse(orderModel.deliveryAddress?.longitude??'0')),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: orderModel.deliveryAddress?.address,
        ),
        icon: BitmapDescriptor.fromBytes(destinationImageData),
      )) : const SizedBox();

      orderModel.restaurantLat != null ? _markers.add(Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(double.parse(orderModel.restaurantLat??'0'), double.parse(orderModel.restaurantLng??'0')),
        infoWindow: InfoWindow(
          title: orderModel.restaurantName,
          snippet: orderModel.restaurantAddress,
        ),
        icon: BitmapDescriptor.fromBytes(restaurantImageData),
      )) : const SizedBox();

      Get.find<ProfileController>().recordLocationBody != null ? _markers.add(Marker(
        markerId: const MarkerId('delivery_boy'),
        position: LatLng(Get.find<ProfileController>().recordLocationBody?.latitude ?? 0, Get.find<ProfileController>().recordLocationBody?.longitude ?? 0),
        infoWindow: InfoWindow(
          title: 'delivery_man'.tr,
          snippet: Get.find<ProfileController>().recordLocationBody?.location,
        ),
        // rotation: rotation,
        icon: BitmapDescriptor.fromBytes(deliveryBoyImageData),
      )) : const SizedBox();
    }catch(_) {}
    setState(() {});
  }

  Future<Uint8List> _convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(_fits(bounds!, screenBounds)){
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool _fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

}