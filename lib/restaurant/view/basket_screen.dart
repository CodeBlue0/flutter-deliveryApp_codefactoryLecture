import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/order/provider/order_provider.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('장바구니가 비어있습니다 ㅠㅠ'),
        ),
      );
    }

    final productsTotal =
        basket.fold<int>(0, (p, n) => p + (n.product.price * n.count));
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
        title: '장바구니',
        child: SafeArea(
          bottom: true,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, index) {
                        return const Divider(height: 16.0);
                      },
                      itemBuilder: (_, index) {
                        final model = basket[index];

                        return ProductCard.fromProductModel(
                          model: model.product,
                          onAdd: () {
                            ref
                                .read(basketProvider.notifier)
                                .addToBasket(product: model.product);
                          },
                          onSubtract: () => {
                            ref
                                .read(basketProvider.notifier)
                                .removeFromBasket(product: model.product)
                          },
                        );
                      },
                      itemCount: basket.length,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('장바구니 금액',
                              style: TextStyle(
                                color: BODY_TEXT_COLOR,
                              )),
                          Text('₩ $productsTotal'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('배달비',
                              style: TextStyle(
                                color: BODY_TEXT_COLOR,
                              )),
                          if (basket.isNotEmpty) Text('₩ $deliveryFee'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('총액',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('₩ ${deliveryFee + productsTotal}'),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final resp = await ref
                                .read(orderStateProvider.notifier)
                                .postOrder();

                            if (resp) {
                              context.goNamed('orderDone');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('주문에 실패했습니다.')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                          ),
                          child: const Text('결제하기'),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
