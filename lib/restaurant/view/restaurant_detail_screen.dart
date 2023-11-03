import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantdetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '불타는 떡볶이',
        child: FutureBuilder<RestaurantDetailModel>(
            future: getRestaurantDetail(),
            builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return CustomScrollView(
                slivers: [
                  renderTop(model: snapshot.data!),
                  renderLabel(),
                  renderProducts(products: snapshot.data!.products)
                ],
              );
            }));
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: model.name,
        tags: model.tags,
        ratingsCount: model.ratingsCount,
        deliveryTime: model.deliveryTime,
        deliveryFee: model.deliveryFee,
        ratings: model.ratings,
        isDetail: true,
        detail: model.detail,
      ),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(model: model),
          );
        }, childCount: products.length),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
          child: Text('메뉴',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500))),
    );
  }
}
