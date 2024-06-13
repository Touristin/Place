class FavoritePlaces {
  final String id;
  final String name;
  final String addressName;
  final String fullName;
  final String purposeName;
  final String type;
  final String addressComment;
  final String buildingName;
  final List<ContextRubric>? contextRubrics;

  FavoritePlaces({
    required this.id,
    required this.name,
    required this.addressName,
    required this.fullName,
    required this.purposeName,
    required this.type,
    this.addressComment = '',
    this.buildingName = '',
    this.contextRubrics,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address_name': addressName,
      'full_name': fullName,
      'purpose_name': purposeName,
      'type': type,
      'address_comment': addressComment,
      'building_name': buildingName,
      'context_rubrics': contextRubrics?.map((e) => e.toMap()).toList(),
    };
  }

  factory FavoritePlaces.fromMap(Map<String, dynamic> map) {
    return FavoritePlaces(
      id: map['id'],
      name: map['name'],
      addressName: map['address_name'],
      fullName: map['full_name'],
      purposeName: map['purpose_name'],
      type: map['type'],
      addressComment: map['address_comment'] ?? '',
      buildingName: map['building_name'] ?? '',
      contextRubrics: (map['context_rubrics'] as List?)
          ?.map((e) => ContextRubric.fromJson(e))
          .toList(),
    );
  }
}

class ContextRubric {
  final String id;
  final int shortId;
  final String? name;
  final int? group;
  final String? caption;

  ContextRubric({
    required this.id,
    required this.shortId,
    this.name,
    this.group,
    this.caption,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'short_id': shortId,
      'name': name,
      'group': group,
      'caption': caption,
    };
  }

  factory ContextRubric.fromJson(Map<String, dynamic> json) {
    return ContextRubric(
      id: json['id'],
      shortId: json['short_id'],
      name: json['name'],
      group: json['group'],
      caption: json['caption'],
    );
  }
}

List<String> availableTypes = [
    'building',
    'street',
    'station',
    'attraction',
    'adm_div.country',
    'adm_div.region',
    'adm_div.city',
    'adm_div.district',
  ];
