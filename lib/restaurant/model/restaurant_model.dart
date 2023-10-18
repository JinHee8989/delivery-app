import 'package:delivery/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';
part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

// factory 생성자로 만든 fromJson은 반복적으로 속성을 또 넣어줘야하는데 이를 자동화하기 위해서 JsonSerializable을 사용함
@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;

  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String thumbUrl;

  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  // 인스턴스화할때 매개변수 다 넣을 수 있게 만듬
  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory RestaurantModel.fromJson({required Map<String, dynamic> json}) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values
  //           .firstWhere((e) => e.name == json['priceRange']),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee']);
  // }
}
