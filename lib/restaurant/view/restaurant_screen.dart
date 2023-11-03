import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final pitem = snapshot.data![index];

                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pitem.id,
                          ),
                        ));
                      },
                      child: RestaurantCard.fromModel(model: pitem));
                },
                separatorBuilder: (_, index) => const SizedBox(height: 16.0),
              );
            }),
      ),
    ));
  }
}
