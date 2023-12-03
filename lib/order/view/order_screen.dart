import 'package:codefactory/common/component/paginationListView.dart';
import 'package:codefactory/order/component/order_card.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/provider/order_provider.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<OrderModel>(
        provider: orderStateProvider,
        itemBuilder: <OrderModel>(_, index, model) {
          return OrderCard.fromModel(model: model);
        });
  }
}
