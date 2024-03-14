import 'dart:convert';

import 'package:get/get.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/address_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/address_service_interface.dart';

class AddressService implements AddressServiceInterface {
  final AddressRepositoryInterface addressRepositoryInterface;
  AddressService({required this.addressRepositoryInterface});

  @override
  Future<List<ZoneModel>?> getZoneList() async {
    return await addressRepositoryInterface.getList();
  }

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await addressRepositoryInterface.getZone(lat, lng);
  }

  @override
  String? getUserAddress() {
    return addressRepositoryInterface.getUserAddress();
  }


  @override
  Future<bool> saveUserAddress(String address) async {
    return await addressRepositoryInterface.saveUserAddress(address);
  }

  @override
  int? setZoneIndex(int? selectedIndex, List<ZoneModel>? zoneList, List<int>? zoneIds) {
    int? selectedZoneIndex = selectedIndex;
    for(int index=0; index<zoneList!.length; index++) {
      if(zoneIds!.contains(zoneList[index].id)) {
        selectedZoneIndex = index;
        break;
      }
    }
    return selectedZoneIndex;
  }

  @override
  List<int> prepareZoneIds(Response response) {
    List<int> zoneIds = [];
    jsonDecode(response.body['zone_id']).forEach((zoneId){
      zoneIds.add(int.parse(zoneId.toString()));
    });
    return zoneIds;
  }

  @override
  List<ZoneData> prepareZoneData(Response response) {
    List<ZoneData> zoneData = [];
    response.body['zone_data'].forEach((zone) => zoneData.add(ZoneData.fromJson(zone)));
    return zoneData;
  }

}