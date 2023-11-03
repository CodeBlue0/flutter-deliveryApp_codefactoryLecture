// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantDetailModel _$RestaurantDetailModelFromJson(
        Map<String, dynamic> json) =>
    RestaurantDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbUrl: DataUtils.pathToUrl(json['thumbUrl'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      priceRange:
          $enumDecode(_$RestaruantPriceRangeEnumMap, json['priceRange']),
      ratings: (json['ratings'] as num).toDouble(),
      ratingsCount: json['ratingsCount'] as int,
      deliveryTime: json['deliveryTime'] as int,
      deliveryFee: json['deliveryFee'] as int,
      detail: json['detail'] as String,
      products: (json['products'] as List<dynamic>)
          .map(
              (e) => RestaurantProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantDetailModelToJson(
        RestaurantDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbUrl': instance.thumbUrl,
      'tags': instance.tags,
      'priceRange': _$RestaruantPriceRangeEnumMap[instance.priceRange]!,
      'ratings': instance.ratings,
      'ratingsCount': instance.ratingsCount,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
      'detail': instance.detail,
      'products': instance.products,
    };

const _$RestaruantPriceRangeEnumMap = {
  RestaruantPriceRange.expensive: 'expensive',
  RestaruantPriceRange.medium: 'medium',
  RestaruantPriceRange.cheap: 'cheap',
};

RestaurantProductModel _$RestaurantProductModelFromJson(
        Map<String, dynamic> json) =>
    RestaurantProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: DataUtils.pathToUrl(json['imgUrl'] as String),
      detail: json['detail'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$RestaurantProductModelToJson(
        RestaurantProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'detail': instance.detail,
      'price': instance.price,
    };
