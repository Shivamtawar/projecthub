import 'dart:convert';

import 'package:projecthub/model/creation_model.dart';

class InCardCreationInfo {
  int carditemId;
  String addedOn;
  Creation creation;

  InCardCreationInfo({
    required this.carditemId,
    required this.addedOn,
    required this.creation,
  });

  Map<String, dynamic> toJson() {
    return {
      'carditem_id': carditemId,
      'added_on': addedOn,
      'creation': creation.toJson(),
    };
  }

  factory InCardCreationInfo.fromJson(Map<String, dynamic> json) {
    return InCardCreationInfo(
      carditemId: jsonDecode(json['card_item_details'])['carditem_id'],
      addedOn: jsonDecode(json['card_item_details'])['added_on'],
      creation:
          Creation.fromJson(jsonDecode(json['card_item_details'])['creation']),
    );
  }
}
